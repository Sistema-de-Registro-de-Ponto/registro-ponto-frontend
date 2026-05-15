# Área do colaborador

Tela inicial após o login: shell com **Dashboard**, **Histórico** e **Perfil**, carregamento do perfil via API e layout alinhado à identidade do produto (logo, menu, saudação e relógio).

### Rotas (GoRouter)

| Rota     | Autenticação | Comportamento |
| -------- | ------------ | ------------- |
| `/`      | Obrigatória  | `CollaboratorShellPage` — carrega perfil e exibe o shell. |
| `/login` | Pública      | Com sessão ativa, redirect para `/`. |

Sem sessão e tentando acessar `/`, o router envia para `/login` (ver `lib/app/router.dart`).

### API

| Método | Caminho               | Descrição |
| ------ | --------------------- | --------- |
| `GET`  | `/v1/colaborator`     | Perfil do colaborador autenticado. Header `Authorization` injetado pelo `AuthInterceptor` (mesmo padrão do restante do app). |

**Corpo esperado (JSON):** `{ "user_id": <int>, "first_name": "<string>" }` — o DTO faz cast direto; `user_id` deve ser número no JSON.

### Camada de dados

- **`CollaboratorRepository.fetchProfile()`** — retorna `Result<CollaboratorProfile, String>`. Sucesso: entidade mapeada do DTO. Falha: `Failure` com mensagem (`ApiException.message` ou `toString()` de outros erros), conforme `CollaboratorRepositoryImpl`.

### Apresentação (Riverpod)

- **`collaboratorProfileViewModelProvider`** (`CollaboratorProfileViewModel`) — `AsyncNotifier` que chama o repositório no `build()`. Em `Success`, devolve o perfil; em `Failure`, devolve hoje um perfil placeholder (`userId: 0`, `firstName: 'Desconhecido'`) para não quebrar o shell (comportamento sujeito a evolução).
- **`CollaboratorShellPage`** — observa o provider: `loading` → `AppLoading`; `error` → `AppError` com retry (`ref.invalidate(collaboratorProfileViewModelProvider)`); `data` → `CollaboratorShellLoaded`.
- **`CollaboratorShellLoaded`** — cabeçalho com `AppBrandLogo`, `NavTabs` (Dashboard / Histórico / Perfil), `AppProfileMenu` (avatar, nome, cargo, **Sair**); corpo com `IndexedStack` — dashboard (`CollaboratorDashboardBody`), demais abas com `AppDeveloping`.

### UI resumida

- **Dashboard:** saudação (Bom dia / Boa tarde / Boa noite), nome do `first_name`, data longa em `pt_BR`, relógio em tempo real (ver `lib/core/extensions/datetime_extensions.dart` e `CollaboratorDashboardBody`).
- **Histórico / Perfil:** mensagem de “em desenvolvimento” (`AppDeveloping`).
- **Logout:** `AppProfileMenu` → encerra sessão via `AuthSessionController` (mesmo fluxo de limpar token e redirect para login).

### Locale

- `main.dart` — `initializeDateFormatting('pt_BR')` antes do `runApp`.
- `MaterialApp` (`lib/app/app.dart`) — `locale: pt_BR`, `supportedLocales` e `localizationsDelegates` para Material/Cupertino.

### Código (pastas principais)

- `lib/features/collaborator/` — feature (entidades, repositório, remote, view models, views e widgets).

Para comandos de build, testes e variáveis de ambiente, use o [README](../README.md) na raiz do repositório.
