# Spring Security + JWT Implementation Guide

## Overview
This is a complete Spring Security with JWT (JSON Web Token) authentication system for the Tekachi backend. The implementation follows best practices for secure API development.

## Components

### 1. **SecurityConfig.java** (Configuration)
- **PasswordEncoder**: Uses BCrypt for password hashing
- **AuthenticationManager**: Manages authentication process
- **SecurityFilterChain**: 
  - CSRF disabled (for REST APIs)
  - CORS enabled for cross-origin requests
  - Stateless session management (JWT doesn't need sessions)
  - Permit `/api/users/register` and `/api/users/login` without authentication
  - All other endpoints require authentication
  - JWT filter added before UsernamePasswordAuthenticationFilter

### 2. **JwtService.java** (Token Generation & Validation)
Key methods:
- `generateToken(UserDetails)`: Create JWT token from user details
- `generateToken(String, Map)`: Create token with custom claims
- `extractUsername(String)`: Extract email from token
- `isTokenValid(String, UserDetails)`: Validate token with user details
- `isTokenValid(String)`: Validate token without user details

**Token Structure**:
- Algorithm: HS512 (HMAC-SHA512)
- Expiration: 24 hours (configurable)
- Claims: Email (subject), issue time, expiration

### 3. **JwtAuthFilter.java** (Authentication Filter)
- Runs on every request
- Extracts JWT from `Authorization: Bearer <token>` header
- Validates token signature and expiration
- Sets authentication in SecurityContext if valid
- Allows request to proceed even if JWT is invalid (security is per-endpoint)

### 4. **CustomUserDetailsService.java** (User Details Service)
- Implements Spring Security's `UserDetailsService`
- Loads user from database by email
- Returns `UserDetails` object for authentication
- Supports role-based access control (currently: ROLE_USER)

### 5. **UserService.java** (Business Logic)
- `register(User)`: Register new user with password encoding
- `login(String, String)`: Authenticate user by email and password
- `findByEmail(String)`: Retrieve user by email
- `findById(Long)`: Retrieve user by ID

### 6. **UserController.java** (REST API)
Endpoints:

#### Public Endpoints (No Authentication Required)
```
POST /api/users/register
Request:
{
  "email": "user@example.com",
  "password": "password123"
}

Response:
{
  "id": 1,
  "email": "user@example.com",
  "message": "User registered successfully"
}
```

```
POST /api/users/login
Request:
{
  "email": "user@example.com",
  "password": "password123"
}

Response:
{
  "id": 1,
  "email": "user@example.com",
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "message": "Login successful"
}
```

#### Protected Endpoints (JWT Required)
Add header: `Authorization: Bearer <token>`

```
GET /api/users
Response: [List of users without passwords]
```

```
GET /api/users/me
Response: Current authenticated user profile
```

```
POST /api/users/logout
Response: {"message": "Logout successful. Please remove the token from client."}
```

## Configuration

### JWT Configuration (application.properties)
```properties
jwt.secret=MyVerySecureSecretKeyForJWTTokenGenerationWithAtLeast256BitsLength123456789
jwt.expiration=86400000  # 24 hours in milliseconds
```

**Important**: Change the secret key to a strong, unique value in production!

## Dependencies (Already in pom.xml)
- `spring-boot-starter-security`: Spring Security framework
- `spring-boot-starter-data-jpa`: Database access
- `jjwt-api`, `jjwt-impl`, `jjwt-jackson` v0.11.5: JWT library
- `spring-security-crypto`: Password encoding

## Usage Flow

### 1. User Registration
```
POST /api/users/register
→ UserController.register()
→ UserService.register()
→ Password encoded with BCrypt
→ User saved to database
```

### 2. User Login
```
POST /api/users/login
→ UserController.login()
→ UserService.login()
→ Password verified
→ JWT token generated with email as subject
→ Token returned to client
```

### 3. Protected Request
```
GET /api/users/me (with Authorization: Bearer <token>)
→ JwtAuthFilter extracts and validates token
→ CustomUserDetailsService loads user details
→ SecurityContext set with authenticated user
→ UserController processes request with authentication
→ User profile returned
```

## Security Features

✅ Password Hashing: BCrypt with salt
✅ Token Expiration: 24 hours
✅ CORS Protection: Configurable origins
✅ CSRF Protection: Disabled for stateless REST API
✅ Stateless Auth: JWT-based, no session needed
✅ Role-Based Access: ROLE_USER (extensible)

## Error Handling

- **409 Conflict**: Email already registered
- **400 Bad Request**: Missing email or password
- **401 Unauthorized**: Invalid credentials or expired token
- **404 Not Found**: User not found
- **500 Internal Server Error**: Server error

## Next Steps / Extensions

1. **Refresh Token**: Implement refresh token for better security
2. **Roles & Permissions**: Add ROLE_ADMIN, ROLE_MODERATOR
3. **Token Blacklist**: Implement logout by invalidating tokens
4. **Email Verification**: Add email confirmation
5. **Rate Limiting**: Prevent brute force attacks
6. **Audit Logging**: Log authentication events

## Testing

### Register User
```bash
curl -X POST http://localhost:8080/api/users/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"pass123"}'
```

### Login
```bash
curl -X POST http://localhost:8080/api/users/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"pass123"}'
```

### Access Protected Endpoint
```bash
curl -X GET http://localhost:8080/api/users/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## Production Checklist

- [ ] Change `jwt.secret` to strong, random key (min 256 bits)
- [ ] Update `jwt.expiration` based on security needs
- [ ] Configure CORS properly for your frontend domain
- [ ] Use HTTPS in production
- [ ] Implement rate limiting
- [ ] Add request logging and monitoring
- [ ] Use environment variables for sensitive config
- [ ] Implement refresh tokens
- [ ] Add email verification
- [ ] Set up proper error logging
