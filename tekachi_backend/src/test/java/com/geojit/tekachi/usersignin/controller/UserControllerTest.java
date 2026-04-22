package com.geojit.tekachi.usersignin.controller;

import com.geojit.tekachi.quizhistory.services.AttemptService;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.repository.UserRepository;
import com.geojit.tekachi.usersignin.service.JwtService;
import com.geojit.tekachi.usersignin.service.TokenBlacklistService;
import com.geojit.tekachi.usersignin.service.UserService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserControllerTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserService userService;

    @Mock
    private JwtService jwtService;

    @Mock
    private TokenBlacklistService tokenBlacklistService;

    @Mock
    private AttemptService attemptService;

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void registerReturnsConflictWhenEmailAlreadyExists() {
        UserController controller = new UserController(
                userRepository, userService, jwtService, tokenBlacklistService, attemptService);

        User existing = new User();
        existing.setEmail("alice@example.com");
        when(userRepository.findByEmail("alice@example.com")).thenReturn(existing);

        ResponseEntity<?> response = controller.register(Map.of(
                "email", "alice@example.com",
                "password", "secret"));

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
    }

    @Test
    void registerReturnsCreatedWithTokensOnSuccess() {
        UserController controller = new UserController(
                userRepository, userService, jwtService, tokenBlacklistService, attemptService);

        User created = new User();
        created.setId(1L);
        created.setEmail("alice@example.com");

        when(userRepository.findByEmail("alice@example.com")).thenReturn(null);
        when(userService.register(any(User.class))).thenReturn(created);
        when(jwtService.generateAccessToken(eq("alice@example.com"), any())).thenReturn("access");
        when(jwtService.generateRefreshToken(eq("alice@example.com"), any())).thenReturn("refresh");

        ResponseEntity<?> response = controller.register(Map.of(
                "email", "alice@example.com",
                "password", "secret"));

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
    }

    @Test
    void loginReturnsUnauthorizedWhenServiceFails() {
        UserController controller = new UserController(
                userRepository, userService, jwtService, tokenBlacklistService, attemptService);

        when(userService.login("alice@example.com", "bad")).thenThrow(new RuntimeException("Invalid"));

        ResponseEntity<?> response = controller.login(Map.of(
                "email", "alice@example.com",
                "password", "bad"));

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
    }

    @Test
    void getCurrentUserReturnsNotFoundWhenNoUserInRepository() {
        UserController controller = new UserController(
                userRepository, userService, jwtService, tokenBlacklistService, attemptService);
        setAuthenticatedUser("alice@example.com");
        when(userRepository.findByEmail("alice@example.com")).thenReturn(null);

        ResponseEntity<?> response = controller.getCurrentUser();

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void changePasswordReturnsUnauthorizedForWrongOldPassword() {
        UserController controller = new UserController(
                userRepository, userService, jwtService, tokenBlacklistService, attemptService);
        setAuthenticatedUser("alice@example.com");

        User user = new User();
        user.setId(1L);
        user.setEmail("alice@example.com");

        when(userRepository.findByEmail("alice@example.com")).thenReturn(user);
        when(userService.changePassword(1L, "old", "new"))
                .thenThrow(new RuntimeException("Old password is incorrect"));

        ResponseEntity<?> response = controller.changePassword(Map.of(
                "oldPassword", "old",
                "newPassword", "new"));

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
    }

    @Test
    void deleteUserDeletesAttemptHistoryAndUser() {
        UserController controller = new UserController(
                userRepository, userService, jwtService, tokenBlacklistService, attemptService);
        setAuthenticatedUser("alice@example.com");

        User user = new User();
        user.setId(10L);
        user.setEmail("alice@example.com");
        when(userRepository.findByEmail("alice@example.com")).thenReturn(user);

        ResponseEntity<?> response = controller.deleteUser();

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(attemptService).deleteAttemptHistory(10L);
        verify(userRepository).deleteById(10L);
    }

    @Test
    void refreshTokenRejectsInvalidToken() {
        UserController controller = new UserController(
                userRepository, userService, jwtService, tokenBlacklistService, attemptService);

        when(jwtService.isTokenValid("bad-refresh")).thenReturn(false);

        ResponseEntity<?> response = controller.refreshToken(Map.of("refresh_token", "bad-refresh"));

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    @Test
    void refreshTokenRejectsInvalidType() {
        UserController controller = new UserController(
                userRepository, userService, jwtService, tokenBlacklistService, attemptService);

        when(jwtService.isTokenValid("token")).thenReturn(true);
        when(jwtService.extractClaim(eq("token"), any())).thenReturn("access");

        ResponseEntity<?> response = controller.refreshToken(Map.of("refresh_token", "token"));

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
    }

    @Test
    void refreshTokenRejectsBlacklistedToken() {
        UserController controller = new UserController(
                userRepository, userService, jwtService, tokenBlacklistService, attemptService);

        when(jwtService.isTokenValid("token")).thenReturn(true);
        when(jwtService.extractClaim(eq("token"), any())).thenReturn("refresh");
        when(tokenBlacklistService.isTokenBlacklisted("token")).thenReturn(true);

        ResponseEntity<?> response = controller.refreshToken(Map.of("refresh_token", "token"));

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
    }

    @Test
    void refreshTokenReturnsNewTokensAndBlacklistsOldRefreshToken() {
        UserController controller = new UserController(
                userRepository, userService, jwtService, tokenBlacklistService, attemptService);

        User user = new User();
        user.setId(15L);
        user.setEmail("alice@example.com");

        when(jwtService.isTokenValid("refresh")).thenReturn(true);
        when(jwtService.extractClaim(eq("refresh"), any())).thenReturn("refresh");
        when(tokenBlacklistService.isTokenBlacklisted("refresh")).thenReturn(false);
        when(jwtService.extractUsername("refresh")).thenReturn("alice@example.com");
        when(userRepository.findByEmail("alice@example.com")).thenReturn(user);
        when(jwtService.generateAccessToken(eq("alice@example.com"), any())).thenReturn("new-access");
        when(jwtService.generateRefreshToken(eq("alice@example.com"), any())).thenReturn("new-refresh");

        ResponseEntity<?> response = controller.refreshToken(Map.of("refresh_token", "refresh"));

        assertEquals(HttpStatus.OK, response.getStatusCode());
        verify(tokenBlacklistService).blacklistToken("refresh");
    }

    @Test
    void getAllReturnsCurrentAuthenticatedUser() {
        UserController controller = new UserController(
                userRepository, userService, jwtService, tokenBlacklistService, attemptService);
        setAuthenticatedUser("alice@example.com");

        User user = new User();
        user.setId(1L);
        user.setEmail("alice@example.com");
        user.setPassword("hash");
        when(userRepository.findByEmail("alice@example.com")).thenReturn(user);

        ResponseEntity<?> response = controller.getAll();

        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    private void setAuthenticatedUser(String email) {
        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(email, null, List.of());
        SecurityContextHolder.getContext().setAuthentication(auth);
    }
}
