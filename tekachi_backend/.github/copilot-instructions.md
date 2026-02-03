# Copilot / Agent Instructions for Tekachi Backend

Purpose
- Help an AI coding agent get productive quickly in this Spring Boot monolith.

High-level architecture (big picture)
- Spring Boot app (entry: `com.geojit.tekachi.TekachiApplication`) with two logical areas:
  - `usersignin` — authentication, JWT handling, user management (`controller`, `service`, `config`, `repository`).
  - `questionretrieval` — domain controllers, services, entities and repositories for questions and options.
- Typical flow: HTTP -> Controller -> Service -> Repository -> DB. Security is applied via a global `JwtAuthFilter` configured in `SecurityConfig`.

Key files to reference (examples)
- `src/main/java/com/geojit/tekachi/usersignin/config/SecurityConfig.java` — where the JWT filter is registered and endpoints are permitted.
- `src/main/java/com/geojit/tekachi/usersignin/service/JwtService.java` — token generation/validation logic and config-driven `jwt.secret` and `jwt.expiration`.
- `src/main/java/com/geojit/tekachi/usersignin/service/JwtAuthFilter.java` — extracts Bearer token, checks blacklist via `TokenBlacklistService`, and sets Spring Security context.
- `src/main/java/com/geojit/tekachi/usersignin/service/TokenBlacklistService.java` — in-memory blacklist (ConcurrentHashMap key set).
- `src/main/java/com/geojit/tekachi/questionretrieval/controller/QuestionController.java` — example minimal controller calling `QuestionService`.
- `src/main/resources/application.properties` — database and jwt defaults (SQL Server connection, driver, `jwt.secret`, `jwt.expiration`).

Build / run / test (repo-specific)
- Windows (preferred in this repo):
  - Run app: `mvnw.cmd spring-boot:run` (from repo root)
  - Build: `mvnw.cmd -DskipTests=false clean package`
  - Run tests: `mvnw.cmd test`
- Unix/macOS: use `./mvnw` instead of `mvnw.cmd`.
- Debugging: the app is a standard Spring Boot main class — run `com.geojit.tekachi.TekachiApplication` from IDE with remote JDWP as needed (IDE configurations in use on developer machine).

Project-specific conventions & patterns
- Package layout: controllers in `.../controller`, business logic in `.../service`, JPA entities in `.../entity`, persistence in `.../repository`.
- REST endpoints: authentication endpoints use `/api/users/*` (see `UserController`), domain endpoints are top-level (e.g., `/questions/{id}`).
- Security: stateless JWT auth; `SecurityConfig` disables sessions and registers `JwtAuthFilter` before username/password filter.
- Token revocation: `TokenBlacklistService` is in-memory — the agent should note that revocation state is ephemeral and propose persistence if required.
- Passwords use `BCryptPasswordEncoder` provided by `SecurityConfig`.

Integration points and external dependencies
- Database: SQL Server configured in `application.properties`. Ensure the SQL Server JDBC driver is on the classpath (pom.xml includes it).
- JWT library: uses `io.jsonwebtoken` (JJWT). Secret is read from properties; default is long hard-coded secret in properties — consider environment overrides for production.

Safe changes guidance (what an agent should do first)
- Small, focused PRs: follow package conventions — add service + repository + controller when adding a new domain.
- When touching auth, update `SecurityConfig` to keep permits for `/api/users/register` and `/api/users/login`.
- For DB schema changes, prefer JPA entities + `spring.jpa.hibernate.ddl-auto` review (`update` is enabled in properties).

Notes & caveats discovered in repo
- `TokenBlacklistService` is memory-backed — token revocation is lost on restart.
- `application.properties` contains secrets and SQL Server credentials — use environment variables or externalized config for production.

Where to look next when extending functionality
- To add an authenticated endpoint: create controller in `questionretrieval/controller`, add service in `questionretrieval/service`, persist via `questionretrieval/repository`.
- To modify auth flow: update `JwtService`, `JwtAuthFilter`, and `SecurityConfig` together.

If anything here is unclear or you want this file to include additional examples (unit-test patterns, PR checklist, or CI commands), tell me which area to expand.
