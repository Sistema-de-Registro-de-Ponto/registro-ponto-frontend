# registro-ponto-frontend

Frontend Flutter Web do sistema de registro de ponto da Player Contabilidade. Inclui **login** (autenticação na API, sessão no `SecureStorage`, auto-logout em `401`), **área do colaborador** em `/` e **área de gestão** em `/management` (conforme o `role` devolvido no login). Contratos e fluxos estão nas secções **Área do colaborador** e **Área de gestão** abaixo.

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
- **Destinos ainda em desenvolvimento** (`AppDeveloping`): Jornadas, Relatórios, RPA, Configurações.
- **Colaboradores (API):**
  - **Listagem:** `GET /v1/manager/collaborators?page=<int>&size=<int>&search=<string?>` — `search` opcional (debounce na UI). Resposta no formato **página Spring** (ver secção **Paginação**). Cada item em `content`:
    - `id`, `first_name`, `current_journey_status` (`in_progress` | `completed` | …), `hours_today_seconds`, `adherence_percentage` (pode ser `null`).
  - **Detalhe:** `GET /v1/manager/collaborators/{id}` — inclui os mesmos campos de resumo mais `current_journey` (objeto jornada, mesmo contrato de `JourneyDto`) quando houver jornada ativa.
- **Colaboradores (UI):** `ManagerCollaboratorsBody` — busca (`AppTextFormField`), botão **Filtros** apenas visual (sem lógica), tabela (`ManagerCollaboratorsTable`), paginação (`AppDataTablePagination`). Ícone de detalhes: abre `JourneyDetailDialog` se existir `current_journey`; caso contrário `ManagerCollaboratorSummaryDialog`.

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
- **UI compartilhada** em `lib/shared/data_table/`: `AppDataTableHeaderCell`, `AppDataTableTextCell`, `AppDataTableStatusBadge`, `AppDataTableAdherenceCell`, `AppDataTablePagination`, `AppDataTableStyle`. Usados em `JourneyHistoryTable` e `ManagerCollaboratorsTable`.
- **Histórico do colaborador** ainda usa `JourneyPageDto` / `last` (“carregar mais”), não `PageDto` — migração futura se o endpoint passar a expor o mesmo envelope Spring completo.

### Credenciais de teste

| Campo   | Valor          |
| ------- | -------------- |
| Usuário | `colaborador`  |
| Senha   | `12345678`     |

A senha deve obedecer ao padrão `^\d{8}$` (exatamente 8 dígitos numéricos). A regra é aplicada no backend — o front se limita a checar campos não vazios e exibe a mensagem que vier no `detail`/`errors` da resposta de erro.

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
