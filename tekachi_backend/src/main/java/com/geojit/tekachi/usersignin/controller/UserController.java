package com.geojit.tekachi.usersignin.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.context.SecurityContextHolder;

import com.geojit.tekachi.usersignin.repository.UserRepository;
import com.geojit.tekachi.quizhistory.services.AttemptService;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.service.UserService;

import lombok.extern.slf4j.Slf4j;

import com.geojit.tekachi.usersignin.service.JwtService;
import com.geojit.tekachi.usersignin.service.TokenBlacklistService;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/users")
@Slf4j
public class UserController {

    private final UserRepository repository;
    private final UserService userService;
    private final JwtService jwtService;
    private final TokenBlacklistService tokenBlacklistService;

    private final AttemptService quizAttemptService;

    public UserController(UserRepository repository, UserService userService, JwtService jwtService,
            TokenBlacklistService tokenBlacklistService, AttemptService quizAttemptService) {
        this.repository = repository;
        this.userService = userService;
        this.jwtService = jwtService;
        this.tokenBlacklistService = tokenBlacklistService;
        this.quizAttemptService = quizAttemptService;
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

            User checkUser = repository.findByEmail(email);
            if (checkUser != null) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("error", "Email is already registered"));
            }

            User user = new User();
            user.setEmail(email);
            user.setPassword(password);

            User registeredUser = userService.register(user);
            String access_token = jwtService.generateAccessToken(email, Map.of("userId", registeredUser.getId()));
            String refresh_token = jwtService.generateRefreshToken(email, Map.of("userId", registeredUser.getId()));

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(Map.of(
                            "id", registeredUser.getId(),
                            "email", registeredUser.getEmail(),
                            "access_token", access_token,
                            "refresh_token", refresh_token,
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

            String access_token = jwtService.generateAccessToken(email, Map.of("userId", user.getId()));
            String refresh_token = jwtService.generateRefreshToken(email, Map.of("userId", user.getId()));

            return ResponseEntity.ok(Map.of(
                    "id", user.getId(),
                    "email", user.getEmail(),
                    "access_token", access_token,
                    "refresh_token", refresh_token,
                    "message", "Login successful"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping
    public ResponseEntity<?> getAll() {
        try {
            User currentUser = getAuthenticatedUser();
            currentUser.setPassword(null);
            return ResponseEntity.ok(List.of(currentUser));
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
    public ResponseEntity<?> logout(@RequestHeader("Authorization") String authHeader,
            @RequestBody Map<String, String> request) {
        try {
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Missing or invalid token"));
            }

            String access_token = authHeader.substring(7);
            String refresh_token = request.get("refresh_token");
            if (refresh_token == null || refresh_token.isBlank()) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Valid Refresh token is required"));
            }

            // Check refresh token validity before extracting claims
            if (!jwtService.isTokenValid(refresh_token)) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Valid Refresh token is required"));
            }

            String tokenType = jwtService.extractClaim(refresh_token, claims -> claims.get("type", String.class));
            if (!"refresh".equals(tokenType)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("error", "Invalid token type"));
            }

            // Check if refresh token belongs to authenticated user
            String email = SecurityContextHolder.getContext().getAuthentication().getName();
            String refreshTokenEmail = jwtService.extractUsername(refresh_token);
            if (!email.equals(refreshTokenEmail)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("error", "Token mismatch. Refresh token not authorized."));
            }

            tokenBlacklistService.blacklistToken(access_token);
            tokenBlacklistService.blacklistToken(refresh_token);

            return ResponseEntity.ok(Map.of("message", "Logout successful. Token revoked."));
        } catch (Exception e) {
            log.error("Exception {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Logout failed " + e.getMessage()));
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

            // Delete quiz attempt history for the user
            quizAttemptService.deleteAttemptHistory(user.getId());
            // Delete user account
            repository.deleteById(user.getId());
            return ResponseEntity.ok(Map.of("message", "User account deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Delete failed: " + e.getMessage()));
        }
    }

    private User getAuthenticatedUser() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = repository.findByEmail(email);
        if (user == null) {
            throw new IllegalStateException("Authenticated user not found");
        }
        return user;
    }

    @PostMapping("/refresh")
    public ResponseEntity<?> refreshToken(@RequestBody Map<String, String> request) {

        try {
            String oldToken = request.get("old_token");
            String refreshToken = request.get("refresh_token");

            // CHECK VALIDITY OF REFRESH TOKEN
            if (refreshToken == null || !jwtService.isTokenValid(refreshToken)) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Valid Refresh token is required"));
            }
            String type = jwtService.extractClaim(refreshToken, claims -> claims.get("type", String.class));

            if (!"refresh".equals(type)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("error", "Refresh token required"));
            }
            if (tokenBlacklistService.isTokenBlacklisted(refreshToken)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("error", "Refresh token is blacklisted. Please login again."));
            }

            // CHECK IF OLD TOKEN IS STILL VALID, IF YES THEN BLACKLIST IT
            if (oldToken != null && jwtService.isTokenValid(oldToken)) {
                tokenBlacklistService.blacklistToken(oldToken);
            }

            String email = jwtService.extractUsername(refreshToken);

            // Blacklist old access token only if it is valid, is an access token,
            // and belongs to the same user as the refresh token.
            if (oldToken != null && jwtService.isTokenValid(oldToken)) {
                String oldType = jwtService.extractClaim(oldToken, claims -> claims.get("type", String.class));
                String oldEmail = jwtService.extractUsername(oldToken);

                if ("access".equals(oldType) && email.equals(oldEmail)) {
                    tokenBlacklistService.blacklistToken(oldToken);
                }
            }

            User user = repository.findByEmail(email);
            if (user == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("error", "User not found"));
            }

            String newAccessToken = jwtService.generateAccessToken(email, Map.of("userId", user.getId()));
            String newRefreshToken = jwtService.generateRefreshToken(email, Map.of("userId", user.getId()));
            final TokenBlacklistService blacklistService = tokenBlacklistService;
            blacklistService.blacklistToken(refreshToken);

            return ResponseEntity.ok(Map.of(
                    "access_token", newAccessToken,
                    "refresh_token", newRefreshToken,
                    "message", "Token refreshed successfully"));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("error", "Could not refresh token: " + e.getMessage()));
        }

    }

}
