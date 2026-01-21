# Tekachi Codebase Guide for AI Agents

## Project Overview
**Tekachi** is a dual-stack placement preparation platform combining a **Flutter frontend** (mobile app) with a **Spring Boot Java backend**. The app helps students prepare for campus placements through aptitude tests, technical interviews, HR interviews, and an AI mentor system.

### Architecture Pattern
- **Frontend**: Flutter (Dart) - [lib/](lib/) folder contains all UI/business logic
- **Backend**: Spring Boot microservice - [tekachi/](tekachi/) folder (separate Maven project)
- **Build System**: Flutter for mobile; Maven for backend
- **Database**: MSSQL (configured but not yet integrated)

---

## Key Codebase Patterns

### 1. Navigation & App Flow
The app uses **Material Routing** with screen hierarchy:
- **Entry Point**: `Signup` → `Login` → `PrepHome` (dashboard)
- **Training Branches**: `PrepHome` → `AptitudeHome`/`TechnicalHome`/`HRHome` → topic-specific screens
- Pattern: Each training module has `[Topic]Home` → `[Topic]Topics` structure (e.g., [lib/prep/Aptitude Training/](lib/prep/Aptitude%20Training/))
- **Navigation Implementation**: `Navigator.push()` with `MaterialPageRoute` (NOT named routes yet)

### 2. UI/Theme Conventions
- **Dark Theme**: Base background `Color.fromRGBO(20, 20, 20, 1.0)` (near-black)
- **Accent Color**: `#8DD300` (lime green) - used for highlights, titles, CTA buttons
- **Custom Fonts**: 
  - `DelaGothicOne` - headings/titles
  - `Trebuchet` - body text
  - `RussoOne` - decorative
- **Responsive Design**: Uses `screenWidth`/`screenHeight` for scaling (e.g., `screenWidth * 0.05`)
- **No State Management**: Currently using `StatefulWidget` + `TextEditingController` (no Provider/Riverpod yet)

### 3. Flutter-Specific Patterns
- **Input Validation**: Email regex validation in both Signup/Login screens (see [lib/login.dart](lib/login.dart#L16))
- **Animations**: `AnimationController` with `TickerProviderStateMixin` for signup success UI (see [lib/signup.dart](lib/signup.dart#L11))
- **Form Controllers**: Manually disposed in `dispose()` method to prevent memory leaks
- **Async Patterns**: Uses `async/await` with `WidgetsFlutterBinding.ensureInitialized()`

### 4. Backend Structure (Java/Spring Boot)
- **Spring Boot Version**: 4.0.1
- **Java Version**: 25
- **Key Dependencies**:
  - `spring-boot-starter-data-jpa` - ORM
  - `mssql-jdbc` - Database driver
  - `lombok` - Boilerplate reduction
- **Entity Pattern**: JPA entities with Lombok annotations (see [tekachi/src/main/java/geojit/tekachi/auth/UserCreds.java](tekachi/src/main/java/geojit/tekachi/auth/UserCreds.java))
  - Example: `@Entity`, `@Getter`, `@Setter`, `@NoArgsConstructor`, `@EqualsAndHashCode`
- **Incomplete Setup**: `application.properties` minimal; backend APIs not yet wired to frontend

---

## File Organization Reference

### Frontend Structure
```
lib/
├── main.dart              # Entry point, orientation lock (portrait only)
├── signup.dart            # Registration with animations
├── login.dart             # Login validation
├── home.dart              # Legacy home (may be deprecated)
├── prep/
│   ├── prepHome.dart      # Dashboard with 3 training routes + AI mentor
│   ├── Aptitude Training/
│   │   ├── AptitudeHome.dart       # Aptitude menu (4 topics)
│   │   └── AptitudeTopics.dart     # Topic detail screen
│   ├── Technical Training/
│   ├── HR Training/
│   └── test/testHome.dart          # Test/exam interface
├── userSettings/userSettings.dart  # User profile/settings
└── test/widget_test.dart           # Basic test placeholder
```

### Backend Structure
```
tekachi/
├── pom.xml                              # Maven config (4.0.1 Spring Boot)
├── src/main/java/geojit/tekachi/
│   ├── TekachiApplication.java          # Spring Boot entry point
│   └── auth/
│       └── UserCreds.java               # User entity (minimal)
├── src/main/resources/
│   └── application.properties           # Config (placeholder)
└── src/test/                            # Test structure (unused)
```

---

## Integration Points & Gaps

### Planned/Incomplete Features
1. **API Integration**: Signup/Login screens validate locally but don't call backend
   - TODO: Connect to Spring Boot auth endpoints
   - Suggested pattern: Create `http` service using `http` package (already in pubspec.yaml)
2. **State Persistence**: No persistent login state (no SharedPreferences or similar)
3. **AI Mentor**: UI button exists in `PrepHome`, no implementation
4. **Database**: MSSQL driver configured in pom.xml but entities/repositories incomplete
5. **Error Handling**: Minimal error handling; no try-catch in backend

### External Dependencies
- **Frontend**: `bcrypt` (^1.1.1) - for password hashing (currently unused)
- **Backend**: `mssql-jdbc` - MSSQL driver (runtime scope)

---

## Development Workflows

### Flutter Development
```bash
# Get dependencies
flutter pub get

# Run app (portrait only)
flutter run

# Build APK/IPA
flutter build apk
flutter build ios
```

### Spring Boot Development
```bash
# Build backend
cd tekachi
mvn clean build

# Run backend (default: localhost:8080)
mvn spring-boot:run

# Run tests
mvn test
```

### Testing
- **Frontend**: Minimal widget tests in [test/widget_test.dart](test/widget_test.dart)
- **Backend**: Test structure exists but unused

---

## Common Development Tasks

### Adding a New Training Module
1. Create folder: `lib/prep/[Topic] Training/`
2. Create `[Topic]Home.dart` with menu list (reference: [lib/prep/Aptitude Training/AptitudeHome.dart](lib/prep/Aptitude%20Training/AptitudeHome.dart))
3. Create `[Topic]Topics.dart` with detail screen
4. Update `PrepHome` to add navigation button
5. Follow color scheme: accent `#8DD300` with dark background

### Connecting Frontend to Backend
1. Create service class in `lib/services/` using `http` package
2. Define API endpoints in Spring Boot (`@RestController`)
3. Use `async/await` in Flutter widgets for API calls
4. Add error handling with try-catch and user feedback (SnackBar)

### Adding Database Models
1. Create JPA entity in `tekachi/src/main/java/geojit/tekachi/` (follow UserCreds pattern)
2. Create repository interface extending `JpaRepository<Entity, ID>`
3. Configure MSSQL connection in `application.properties`

---

## Notes for AI Agents
- **State Management Gap**: Consider suggesting Provider/Riverpod refactor for complex data flows
- **API Contract**: No OpenAPI/Swagger docs exist; will need to define REST contract
- **Mobile-First**: All UI is responsive, but testing on actual devices recommended
- **Naming Quirk**: "Techincal Training" folder has typo (missing 'n'); keep as-is for consistency
- **Lombok Processor**: Java compilation requires Lombok annotation processor configuration (already in pom.xml)
