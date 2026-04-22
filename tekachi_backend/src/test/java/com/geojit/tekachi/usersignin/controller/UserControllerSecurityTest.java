package com.geojit.tekachi.usersignin.controller;

import com.geojit.tekachi.quizhistory.services.AttemptService;
import com.geojit.tekachi.usersignin.repository.UserRepository;
import com.geojit.tekachi.usersignin.service.JwtService;
import com.geojit.tekachi.usersignin.service.TokenBlacklistService;
import com.geojit.tekachi.usersignin.service.UserService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserControllerSecurityTest {

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

    private UserController userController;

    @BeforeEach
    void setUp() {
        userController = new UserController(userRepository, userService, jwtService, tokenBlacklistService,
                attemptService);
    }

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void logoutRejectsMissingRefreshToken() {
        ResponseEntity<?> response = userController.logout("Bearer access-token", Map.of());

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        verify(tokenBlacklistService, never()).blacklistToken(any());
    }

    @Test
    void logoutRejectsInvalidTokenType() {
        when(jwtService.isTokenValid("refresh-token")).thenReturn(true);
        when(jwtService.extractClaim(eq("refresh-token"), any())).thenReturn("access");

        ResponseEntity<?> response = userController.logout(
                "Bearer access-token",
                Map.of("refresh_token", "refresh-token"));

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        verify(tokenBlacklistService, never()).blacklistToken(any());
    }

    @Test
    void logoutRejectsRefreshTokenBelongingToAnotherUser() {
        setAuthenticatedUser("alice@example.com");

        when(jwtService.isTokenValid("refresh-token")).thenReturn(true);
        when(jwtService.extractClaim(eq("refresh-token"), any())).thenReturn("refresh");
        when(jwtService.extractUsername("refresh-token")).thenReturn("bob@example.com");

        ResponseEntity<?> response = userController.logout(
                "Bearer access-token",
                Map.of("refresh_token", "refresh-token"));

        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        verify(tokenBlacklistService, never()).blacklistToken(any());
    }

    @Test
    void logoutBlacklistsAccessAndRefreshTokensWhenValidAndOwnedByUser() {
        setAuthenticatedUser("alice@example.com");

        when(jwtService.isTokenValid("refresh-token")).thenReturn(true);
        when(jwtService.extractClaim(eq("refresh-token"), any())).thenReturn("refresh");
        when(jwtService.extractUsername("refresh-token")).thenReturn("alice@example.com");

        ResponseEntity<?> response = userController.logout(
                "Bearer access-token",
                Map.of("refresh_token", "refresh-token"));

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        verify(tokenBlacklistService).blacklistToken("access-token");
        verify(tokenBlacklistService).blacklistToken("refresh-token");
    }

    private void setAuthenticatedUser(String email) {
        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(email, null, null);
        SecurityContextHolder.getContext().setAuthentication(authentication);
    }
}
