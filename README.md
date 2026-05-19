# registro-ponto-frontend

Frontend **Flutter Web** do sistema de registro de ponto da Player Contabilidade. Inclui **login** (JWT, sessão no `SecureStorage`, auto-logout em `401`), **área do colaborador** em `/` e **área de gestão** em `/management` (conforme o `role` devolvido no login).

### Repositórios do sistema

| Repositório | Descrição |
|-------------|-----------|
| [registro-ponto-backend](https://github.com/Sistema-de-Registro-de-Ponto/registro-ponto-backend) | API REST, MySQL, regras de jornada |
| **registro-ponto-frontend** (este) | Interface web (colaborador + gestor) |
| [registro-ponto-rpa](https://github.com/Sistema-de-Registro-de-Ponto/registro-ponto-rpa) | Robô Python — importa batidas do Portal Ponto Ágil |

### Execução integrada (com RPA)

Para ver dados na aba **RPA** do gestor, execute antes o backend e o robô:

1. **Backend** — `mvn spring-boot:run` com `RPA_API_KEY` alinhada ao RPA (ex.: `dev-rpa-key-change-me`).
2. **Portal mock + RPA** — no repo `registro-ponto-rpa`: `py serve_mock.py` e `py main.py`.
3. **Frontend** (esta pasta):

   ```powershell
   flutter pub get
   flutter pub run build_runner build
   flutter run -d chrome
   ```

4. Login **gestor** (`gerente` / `87654321`) → menu lateral **RPA**.

Passo a passo completo: README do `registro-ponto-rpa`.

### Requisitos

- **Flutter SDK** `^3.11.1` (Dart 3 — usa sealed classes, pattern matching e wildcards).
- **Chrome** instalado (alvo principal do projeto é Flutter Web).
- **Backend** `registro-ponto-backend` em execução em `http://localhost:8080` com **CORS** habilitado para a origem do front-end (inclusive em respostas de erro 4xx/5xx).

### Configuração do ambiente

```powershell
# 1. Instala dependências
flutter pub get

# 2. Gera os arquivos .g.dart (Riverpod 3 + riverpod_generator)
flutter pub run build_runner build
```

Sempre que adicionar/alterar um `@riverpod` (provider, notifier), rodar o `build_runner` novamente para regenerar os `.g.dart`.

### Variáveis de ambiente

Configuradas em tempo de compilação via `--dart-define`.

| Variável         | Default                  | Descrição              |
| ---------------- | ------------------------ | ---------------------- |
| `API_BASE_URL`   | `http://localhost:8080`  | URL base do backend.   |

### Execução do frontend

```powershell
# Backend local (default API_BASE_URL=http://localhost:8080)
flutter run -d chrome

# Backend em outra URL
flutter run -d chrome --dart-define=API_BASE_URL=https://staging.example.com
```

**Testes:**

```powershell
flutter test
```

**Linter / análise estática:**

```powershell
flutter analyze
```

**Logging de rede:** em `kDebugMode` (qualquer `flutter run`) o `PrettyDioLogger` imprime cada request/response do Dio no terminal — útil para inspecionar payloads do `POST /v1/auth/login` e do `GET /v1/collaborator`. Em build de release, o logger não é registrado.

### Área do colaborador e contratos úteis

- **GoRouter:** `/` exige sessão (`CollaboratorShellPage`); `/login` é pública (com sessão ativa → redirect para `/`). Ver `lib/app/router.dart`.
- **Perfil:** `GET /v1/collaborator` com header `Authorization`. JSON esperado: `{ "user_id": <int>, "first_name": "<string>" }`. `CollaboratorRepository.fetchProfile()` devolve `Result<CollaboratorProfile, String>`.
- **Estado / UI:** `collaboratorProfileViewModelProvider` carrega o perfil no `build()`; shell usa `AppLoading` / `AppError` (retry com `ref.invalidate(collaboratorProfileViewModelProvider)`) / `CollaboratorShellLoaded` — abas Dashboard, Histórico e Perfil (`IndexedStack`; dashboard em `CollaboratorDashboardBody`, histórico em `JourneyHistoryBody`; Perfil ainda `AppDeveloping`), **Sair** no `AppProfileMenu` via `AuthSessionController`. Em falha na API, o view model pode expor placeholder (`userId: 0`, `firstName: 'Desconhecido'`). Código em `lib/features/collaborator/`.
- **Locale:** datas e UI em `pt_BR` (`main.dart`, `lib/app/app.dart`).
- **Jornada (API):**
  - **Iniciar:** `POST /v1/journeys/start` — resposta com a jornada na raiz ou em `{ "journey": { ... } }` (`JourneyDto.fromResponseJson`).
  - **Em andamento:** `GET /v1/journeys/current` — devolve a jornada `in_progress` ou `404` quando não há jornada ativa.
  - **Encerrar:** `POST /v1/journeys/current/end` com `{ "summary": "<string>" }` — resposta é o objeto da jornada na **raiz** (não aninhado em `journey`). Apenas jornadas `in_progress` podem ser encerradas; após `completed`, o backend define `ended_at`, `duration_seconds` (segundos) e persiste o resumo.
  - **Checklist da jornada:** `PUT /v1/journeys/activities/planned/{id}` com `{ "is_checked": <bool> }`. Itens em `journey_planned_activities` com `is_checked`.
  - **Não planejadas:** `POST /v1/journeys/{id}/activities/unplanned/` com `{ "description": "<string>" }`; `DELETE /v1/journeys/activities/unplanned/{id}`.
  - **Campos opcionais na jornada encerrada:** `ended_at`, `duration_seconds`, `summary`.
- **Jornada (UI no dashboard):**
  - `JourneySection` carrega a jornada ao montar; **iniciar** e **encerrar** pedem confirmação (`AppConfirmDialog`). O encerramento abre `JourneySummaryDialog` (resumo obrigatório) e, em sucesso, `AppConfirmDialog.showAcknowledgement` confirma o encerramento.
  - Após encerrar com sucesso, o estado volta ao modo **pronto para nova jornada** (`journey` limpa): card em aguardo com **Iniciar jornada**, `PlannedActivitiesSection` visível e sem painel de não planejadas nem checklist da jornada.
  - Checklist de atividades planejadas da jornada (`AppCheckList`) visível **somente** com jornada `in_progress`.
  - `UnplannedActivitiesSection` só aparece com jornada `in_progress`; remoções pedem confirmação.
  - `PlannedActivitiesSection` (atividades do dia, feature `activity`) fica oculta com jornada `in_progress`; remoções pedem confirmação.
  - Após encerrar, mutações na jornada (marcar checklist, adicionar/remover não planejadas) são bloqueadas no `JourneyViewModel`.
- **Histórico de jornadas:** `GET /v1/journeys` com `start_date`, `end_date`, `page`, `size` (paginação por `last` / “carregar mais”). UI em `JourneyHistoryBody` + `JourneyHistoryTable` (detalhe via `JourneyDetailDialog`).

### Área de gestão (gestor) e contratos úteis

- **GoRouter:** utilizadores com role de gestor são redirecionados para `/management` (`Routes.management`); colaborador permanece em `/`. Ver `lib/app/router.dart` e `lib/app/auth_navigation.dart`.
- **Perfil:** `GET /v1/manager` — JSON: `{ "user_id": <int>, "first_name": "<string>" }`. `ManagerRepository.fetchProfile()` → `Result<ManagerProfile, String>`.
- **Estado / UI:** `managerProfileViewModelProvider`; shell em `ManagerShellLoaded` com sidebar (`ManagerSidebar`) e destinos em `ManagerNavDestination`. **Sair** no `AppProfileMenu` (role “Gestor”). Código em `lib/features/manager/`.
- **Destinos implementados:**
  - **Visão geral** — `GET /v1/manager/overview?start_date=yyyy-MM-dd&end_date=yyyy-MM-dd`. Resposta: `duration_seconds`, `journeys_progress`, `average_adherence_percentage`, `activities_completed`, `unplanned_activities`. Filtro de período no header (`AppPeriodField`).
  - **Colaboradores** — listagem paginada e busca; detalhe com jornada atual quando existir.
  - **Jornadas** — consulta paginada de jornadas dos colaboradores; detalhe via `GET /v1/manager/journeys/{id}`.
  - **Relatórios** — relatório consolidado com métricas globais e tabela por colaborador; ver secção abaixo.
- **RPA** — registros importados pelo robô Python (portal externo). Ver secção **RPA (importações)** abaixo.
- **Destinos ainda em desenvolvimento** (`AppDeveloping`): Configurações.
- **Colaboradores (API):**
  - **Listagem:** `GET /v1/manager/collaborators?page=<int>&size=<int>&search=<string?>` — `search` opcional (debounce na UI). Resposta no formato **página Spring** (ver secção **Paginação**). Cada item em `content`:
    - `id`, `first_name`, `current_journey_status` (`in_progress` | `completed` | …), `hours_today_seconds`, `adherence_percentage` (pode ser `null`).
  - **Detalhe:** `GET /v1/manager/collaborators/{id}` — inclui os mesmos campos de resumo mais `current_journey` (objeto jornada, mesmo contrato de `JourneyDto`) quando houver jornada ativa.
- **Colaboradores (UI):** `ManagerCollaboratorsBody` — busca (`AppTextFormField`), botão **Filtros** apenas visual (sem lógica), tabela (`ManagerCollaboratorsTable`), paginação (`AppDataTablePagination`). Ícone de detalhes: abre `JourneyDetailDialog` se existir `current_journey`; caso contrário `ManagerCollaboratorSummaryDialog`.
- **Jornadas (API):**
  - **Listagem:** `GET /v1/manager/journeys?page=<int>&size=<int>` — padrão do backend: jornadas de **hoje** (sem `start_date`/`end_date`). Com filtro de período: `start_date`, `end_date` (`yyyy-MM-dd`). Busca por nome: `collaborator_name` (opcional). Resposta no formato **página Spring** (ver **Paginação**). Cada item em `content`: `id`, `journey_date`, `collaborator_id`, `collaborator_first_name`, `started_at`, `ended_at` (opcional), `duration_seconds`, `status` (`in_progress` | `completed`).
  - **Detalhe:** `GET /v1/manager/journeys/{id}` — mesmo contrato de `JourneyDto` (atividades planejadas/não planejadas, resumo, etc.).
- **Jornadas (UI):** `ManagerJourneysBody` — período (`AppPeriodField`, exibido como hoje até o utilizador alterar; só então envia datas), busca por nome do colaborador, tabela (`ManagerJourneysTable`, sem coluna de aderência), paginação (`AppDataTablePagination`). Ícone de detalhes: `JourneyDetailDialog` após `fetchJourneyById`.
- **Relatórios consolidados (API):**
  - **Consulta:** `GET /v1/manager/reports/consolidated?start_date=yyyy-MM-dd&end_date=yyyy-MM-dd&page=<int>&size=<int>&search=<string?>`. Resposta: `period` (`start_date`, `end_date`), `summary` (`duration_seconds`, `planned_activities`, `activities_completed`, `unplanned_activities`, `average_adherence_percentage`), `collaborators` (página Spring). Cada item em `collaborators.content`: `id`, `first_name`, `duration_seconds`, `planned_activities`, `activities_completed`, `unplanned_activities`, `adherence_percentage`.
- **Relatórios consolidados (UI):** `ManagerReportsBody` — período inicial hoje (`AppPeriodField`), busca por nome (`search`, debounce), cards de métricas (`ManagerReportsMetricsRow`) e tabela (`ManagerReportsTable`) com paginação (`AppDataTablePagination`). Sem ação de detalhe por linha.

### RPA (importações do portal externo)

A aba **RPA** exibe batidas coletadas pelo `registro-ponto-rpa` no **Portal Ponto Ágil** (mock ou site real). **Não** são as jornadas que o colaborador registra no app (`journeys`); são dados espelhados do portal, persistidos em `rpa_records` no backend.

**API:** `GET /v1/manager/rpa/records`

| Query | Obrigatório | Comportamento na UI |
|-------|-------------|---------------------|
| `start_date` | não | Enviado após o usuário alterar o período (`AppPeriodField`) |
| `end_date` | não | Idem |
| `page` | não | Paginação (`AppDataTablePagination`) |
| `size` | não | Tamanho da página |
| `search` | não | Busca por nome com debounce (~400 ms) |

Sem `start_date`/`end_date` na primeira carga, o backend usa o **dia atual** (`APP_TIME_ZONE`).

**Campos em cada item de `content`:**

| Campo JSON | Exibição na tabela |
|------------|-------------------|
| `work_date` | Data + dia da semana |
| `employee_name` / `collaborator_first_name` | Colaborador |
| `external_employee_id` | Matrícula |
| `check_in_at` | Entrada |
| `check_out_at` | Saída |
| `worked_seconds` | Horas (`HH:mm`) |
| `source_system` | Origem (ex.: `ponto_agil` → “Ponto Ágil”) |
| `imported_at` | Data/hora da importação |

**Código:**

| Camada | Arquivo |
|--------|---------|
| Entity | `lib/features/manager/domain/entities/manager_rpa_record.dart` |
| DTO | `lib/features/manager/data/models/manager_rpa_record_dto.dart` |
| ViewModel | `lib/features/manager/presentation/view_models/manager_rpa_view_model.dart` |
| UI | `lib/features/manager/presentation/views/manager_rpa_body.dart` |
| Tabela | `lib/features/manager/presentation/widgets/rpa/manager_rpa_table.dart` |

**Fluxo de dados:**

```
registro-ponto-rpa (py main.py)
        → POST /v1/rpa/imports
        → MySQL rpa_records
        → GET /v1/manager/rpa/records (JWT gerente)
        → ManagerRpaBody (Flutter Web)
```

### Paginação (Spring) e componentes de tabela

Respostas paginadas do backend seguem o contrato abaixo. Tipos genéricos em `lib/core/pagination/`:

| Campo JSON        | Uso no front                          |
| ----------------- | ------------------------------------- |
| `content`         | Lista de itens (`Page.content`)       |
| `number`          | Página atual (0-based)                |
| `size`            | Tamanho da página                     |
| `total_elements`  | Total de registros (rodapé da tabela) |
| `first` / `last`  | Navegação                             |
| `empty`           | Página vazia                          |

- **`PageDto<T>`** — `PageDto.fromJson(json, ItemDto.fromJson)`; **`Page<T>`** — `dto.toEntity((dto) => dto.toEntity())`.
- **UI compartilhada** em `lib/shared/data_table/`: `AppDataTableHeaderCell`, `AppDataTableTextCell`, `AppDataTableStatusBadge`, `AppDataTableAdherenceCell`, `AppDataTablePagination`, `AppDataTableStyle`. Usados em `JourneyHistoryTable`, `ManagerCollaboratorsTable`, `ManagerJourneysTable`, `ManagerReportsTable` e `ManagerRpaTable`.
- **Histórico do colaborador** ainda usa `JourneyPageDto` / `last` (“carregar mais”), não `PageDto` — migração futura se o endpoint passar a expor o mesmo envelope Spring completo.

### Credenciais de teste

| Usuário | Senha | Role | Área após login |
|---------|-------|------|-----------------|
| `colaborador` | `12345678` | Colaborador | `/` — jornada, histórico |
| `gerente` | `87654321` | Gestor | `/management` — visão geral, jornadas, **RPA**, relatórios |

A senha deve obedecer ao padrão `^\d{8}$` (exatamente 8 dígitos numéricos). A regra é aplicada no backend — o front se limita a checar campos não vazios e exibe a mensagem que vier no `detail`/`errors` da resposta de erro.

**Portal mock (robô RPA):** usuário `demo`, senha `demo123` — ver `registro-ponto-rpa`.

### Fluxo da aplicação

```
                   ┌──────────────────────────┐
   App boot ─────▶ │ Carrega sessão do        │
                   │ SecureStorage            │
                   └──────────────┬───────────┘
                                  │
                  ┌───────────────┴──────────────┐
                  │                              │
              tem sessão?                    sem sessão
                  │                              │
                  ▼                              ▼
         role.shellRoute                   GET /login
    (/ ou /management)                      (LoginPage)
```

1. **Bootstrap (`main.dart`)** — inicializa formatação de datas `pt_BR` (`initializeDateFormatting`). Em seguida, `await container.read(authSessionControllerProvider.future)` carrega a sessão persistida antes de `runApp`, evitando flash de login para quem já tem token.
2. **Router guard (`lib/app/router.dart`)**:
   - Sessão `null` + rota ≠ `/login` → redireciona para `/login`.
   - Sessão presente + rota `/login` → redireciona para a home do role (`/` colaborador, `/management` gestor).
   - `refreshListenable` ouve o `authSessionControllerProvider`; login, logout ou `401` recalculam o redirect.
3. **Login** (`POST /v1/auth/login`):
   - Form com `username` + `password` (toggle de visibilidade) e logo da marca no card.
   - Em sucesso: a resposta inclui `token`, `tokenType`, `username` e `roles`; o repositório monta a sessão, persiste no `SecureStorage` e atualiza o `AuthSessionController` → redirect para `/`.
   - Em falha: o repositório devolve `Result` com `Failure<String>`; o estado de login guarda a mensagem e o banner (`AppErrorBanner`) exibe o texto retornado (incluindo detalhes mapeados de `errors` / `detail` quando a API responde nesse formato).
4. **Home por role** — colaborador: `CollaboratorShellPage` + `GET /v1/collaborator`; gestor: `ManagerShellPage` + `GET /v1/manager`. Ver secções **Área do colaborador** e **Área de gestão** neste README.
5. **Header `Authorization` automático** — o `AuthInterceptor` injeta `Authorization: <tokenType> <token>` em requests autenticados (exceto `POST /v1/auth/login`). Novos data sources podem reutilizar o mesmo `Dio` configurado em `dio_client_provider.dart`.
6. **Auto-logout em 401** — respostas `401` fora de `POST /v1/auth/login` disparam `authSessionController.clear()`; o router volta para `/login`.
7. **Logout manual** — no shell do colaborador, o menu de perfil (`AppProfileMenu`) oferece **Sair**, chamando o mesmo fluxo de `clear()` (limpa storage + sessão) e redirect para `/login`.
8. **RPA (gestor)** — após o robô importar registros, o gestor abre **RPA** no menu; `ManagerRpaViewModel` chama `GET /v1/manager/rpa/records` e preenche `ManagerRpaTable`. Filtros de período e busca recarregam a listagem paginada.

### Compartilhamento (avaliação)

Compartilhe os três repositórios com o usuário GitHub **playercontabilidade** (backend, frontend e RPA).
