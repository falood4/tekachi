package com.geojit.tekachi.usersignin.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.context.SecurityContextHolder;

import com.geojit.tekachi.usersignin.repository.UserRepository;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.service.UserService;
import com.geojit.tekachi.usersignin.service.JwtService;
import com.geojit.tekachi.usersignin.service.TokenBlacklistService;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@CrossOrigin
public class UserController {

    private final UserRepository repository;
    private final UserService userService;
    private final JwtService jwtService;
    private final TokenBlacklistService tokenBlacklistService;

    public UserController(UserRepository repository, UserService userService, JwtService jwtService,
            TokenBlacklistService tokenBlacklistService) {
        this.repository = repository;
        this.userService = userService;
        this.jwtService = jwtService;
        this.tokenBlacklistService = tokenBlacklistService;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Map<String, String> request) {
        try {
            String email = request.get("email");
            String password = request.get("password");

            if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Email and password are required"));
            }

            User user = new User();
            user.setEmail(email);
            user.setPassword(password);

            User registeredUser = userService.register(user);
            String token = jwtService.generateToken(email, Map.of("userId", registeredUser.getId()));

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(Map.of(
                            "id", registeredUser.getId(),
                            "email", registeredUser.getEmail(),
                            "token", token,
                            "message", "User registered successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> request) {
        try {
            String email = request.get("email");
            String password = request.get("password");

            if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Email and password are required"));
            }

            User user = userService.login(email, password);

            // Generate JWT token
            String token = jwtService.generateToken(email, Map.of("userId", user.getId()));

            return ResponseEntity.ok(Map.of(
                    "id", user.getId(),
                    "email", user.getEmail(),
                    "token", token,
                    "message", "Login successful"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping
    public ResponseEntity<?> getAll() {
        try {
            List<User> users = repository.findAll();
            users.forEach(u -> u.setPassword(null));
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to fetch users"));
        }
    }

    // Get current user profile (requires authentication)
    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser() {
        try {
            String email = SecurityContextHolder.getContext().getAuthentication().getName();
            User user = repository.findByEmail(email);

            if (user == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("error", "User not found"));
            }

            user.setPassword(null);
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to fetch user profile"));
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(@RequestHeader("Authorization") String authHeader) {
        try {
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Missing or invalid token"));
            }

            String token = authHeader.substring(7);
            tokenBlacklistService.blacklistToken(token);

            return ResponseEntity.ok(Map.of("message", "Logout successful. Token revoked."));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Logout failed"));
        }
    }

    @PostMapping("/change-password")
    public ResponseEntity<?> changePassword(@RequestBody Map<String, String> request) {
        try {
            String oldPassword = request.get("oldPassword");
            String newPassword = request.get("newPassword");

            if (oldPassword == null || oldPassword.isEmpty() || newPassword == null || newPassword.isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Old password and new password are required"));
            }

            // Get current authenticated user
            String email = SecurityContextHolder.getContext().getAuthentication().getName();
            User user = repository.findByEmail(email);

            if (user == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("error", "User not found"));
            }

            // Change password (validates old password)
            User updatedUser = userService.changePassword(user.getId(), oldPassword, newPassword);
            updatedUser.setPassword(null);

            return ResponseEntity.ok(Map.of(
                    "message", "Password changed successfully",
                    "user", updatedUser));
        } catch (Exception e) {
            if (e.getMessage().contains("Old password is incorrect")) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("error", e.getMessage()));
            }
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    // Delete user account
    @DeleteMapping("/delete")
    public ResponseEntity<?> deleteUser() {
        try {
            // Get current authenticated user
            String email = SecurityContextHolder.getContext().getAuthentication().getName();
            User user = repository.findByEmail(email);

            if (user == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("error", "User not found"));
            }

            // Delete user account
            repository.deleteById(user.getId());
            return ResponseEntity.ok(Map.of("message", "User account deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Delete failed: " + e.getMessage()));
        }
    }
}