# registro-ponto-frontend

Frontend Flutter Web do sistema de registro de ponto da Player Contabilidade. A primeira feature entregue é o **login**: autenticação contra a API, sessão persistida no SecureStorage e auto-logout reativo a `401`.

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

**Logging de rede:** em `kDebugMode` (qualquer `flutter run`) o `PrettyDioLogger` imprime cada request/response do Dio no terminal — útil para inspecionar payloads do `/auth/login` e `/auth/me`. Em build de release, o logger não é registrado.

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
              (CounterPage)                  (LoginPage)
```

1. **Bootstrap (`main.dart`)** — antes de `runApp`, faz `await container.read(authSessionControllerProvider.future)` para carregar a sessão persistida. Evita flash de login para quem já tem token salvo.
2. **Router guard (`app/router.dart`)**:
   - Sessão `null` + rota ≠ `/login` → redireciona para `/login`.
   - Sessão presente + rota `/login` → redireciona para `/`.
   - `refreshListenable` ouve o `authSessionControllerProvider`, então qualquer mudança de sessão (login/logout/401) recalcula o redirect automaticamente.
3. **Login** (`POST /auth/login` → `GET /auth/me`):
   - Form com `username` + `password` (toggle de visibilidade).
   - Em sucesso: token e dados do usuário são salvos no SecureStorage e o `AuthSessionController` é atualizado → router leva ao contador.
   - Em falha: a mensagem do backend é exibida em um banner. Quando o backend retorna `errors: { campo: mensagem }` (RFC 7807 + extensão), as mensagens aparecem empilhadas no banner.
4. **Header `Authorization` automático** — o `AuthInterceptor` injeta `Authorization: <tokenType> <token>` em qualquer request autenticado (exceto `/auth/login`). Não é preciso passar token manualmente em novos data sources.
5. **Auto-logout em 401** — o mesmo `AuthInterceptor` observa respostas 401 (fora de `/auth/login`) e dispara `authSessionController.clear()`. A sessão zera, o router refaz o redirect e a aplicação volta para `/login`.
6. **Logout manual** — ícone de "sair" no AppBar do contador chama `clear()` (limpa SecureStorage + sessão) e o router redireciona para `/login`.
