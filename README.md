# registro-ponto-frontend

Frontend Flutter Web do sistema de registro de ponto da Player Contabilidade. Inclui **login** (autenticação na API, sessão no `SecureStorage`, auto-logout em `401`) e **área do colaborador** em `/` (shell com dashboard, histórico e perfil — resumo na secção **Área do colaborador e contratos úteis** abaixo).

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
- **Estado / UI:** `collaboratorProfileViewModelProvider` carrega o perfil no `build()`; shell usa `AppLoading` / `AppError` (retry com `ref.invalidate(collaboratorProfileViewModelProvider)`) / `CollaboratorShellLoaded` — abas Dashboard, Histórico e Perfil (`IndexedStack`; dashboard em `CollaboratorDashboardBody`; resto `AppDeveloping` por agora), **Sair** no `AppProfileMenu` via `AuthSessionController`. Em falha na API, o view model pode expor placeholder (`userId: 0`, `firstName: 'Desconhecido'`). Código em `lib/features/collaborator/`.
- **Locale:** datas e UI em `pt_BR` (`main.dart`, `lib/app/app.dart`).
- **Jornada (API):** `PUT /v1/journeys/activities/planned/{id}` com corpo `{ "is_checked": <bool> }`; respostas de jornada usam `journey_planned_activities` e, em cada item, `is_checked`. `GET /v1/journeys/current` inclui `unplanned_activities` (lista; pode ser vazia). Atividades não planejadas: `POST /v1/journeys/{id}/activities/unplanned/` com `{ "description": "<string>" }` (resposta com `id`, `journey_id`, `description`, `created_at` ou `create_at`) e `DELETE /v1/journeys/activities/unplanned/{id}`. No dashboard, `UnplannedActivitiesSection` reutiliza `AppInformActivity`; o utilizador só pode adicionar ou remover enquanto a jornada estiver `in_progress` (com `completed`, a lista permanece visível em modo leitura).

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
              GET /                          GET /login
        (CollaboratorShellPage)               (LoginPage)
```

1. **Bootstrap (`main.dart`)** — inicializa formatação de datas `pt_BR` (`initializeDateFormatting`). Em seguida, `await container.read(authSessionControllerProvider.future)` carrega a sessão persistida antes de `runApp`, evitando flash de login para quem já tem token.
2. **Router guard (`lib/app/router.dart`)**:
   - Sessão `null` + rota ≠ `/login` → redireciona para `/login`.
   - Sessão presente + rota `/login` → redireciona para `/` (home do colaborador).
   - `refreshListenable` ouve o `authSessionControllerProvider`; login, logout ou `401` recalculam o redirect.
3. **Login** (`POST /v1/auth/login`):
   - Form com `username` + `password` (toggle de visibilidade) e logo da marca no card.
   - Em sucesso: a resposta inclui `token`, `tokenType`, `username` e `roles`; o repositório monta a sessão, persiste no `SecureStorage` e atualiza o `AuthSessionController` → redirect para `/`.
   - Em falha: o repositório devolve `Result` com `Failure<String>`; o estado de login guarda a mensagem e o banner (`AppErrorBanner`) exibe o texto retornado (incluindo detalhes mapeados de `errors` / `detail` quando a API responde nesse formato).
4. **Home colaborador (`/`)** — após autenticar, `CollaboratorShellPage` dispara o carregamento do perfil (`GET /v1/collaborator`); ver a secção **Área do colaborador e contratos úteis** neste README.
5. **Header `Authorization` automático** — o `AuthInterceptor` injeta `Authorization: <tokenType> <token>` em requests autenticados (exceto `POST /v1/auth/login`). Novos data sources podem reutilizar o mesmo `Dio` configurado em `dio_client_provider.dart`.
6. **Auto-logout em 401** — respostas `401` fora de `POST /v1/auth/login` disparam `authSessionController.clear()`; o router volta para `/login`.
7. **Logout manual** — no shell do colaborador, o menu de perfil (`AppProfileMenu`) oferece **Sair**, chamando o mesmo fluxo de `clear()` (limpa storage + sessão) e redirect para `/login`.
