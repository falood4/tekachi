package com.geojit.tekachi.usersignin.service;

import io.jsonwebtoken.Claims;
import org.junit.jupiter.api.Test;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class JwtServiceTest {

    @Test
    void generateAccessTokenIncludesAccessTypeAndUsername() {
        JwtService jwtService = buildJwtService(
                "245f99ebadb01b0dd4a7be0546098deaf89a9a12101745c140c27013edf3fb92", 300000L, 86400000L);

        String token = jwtService.generateAccessToken("alice@example.com", Map.of("userId", 1L));

        assertTrue(jwtService.isTokenValid(token));
        assertEquals("alice@example.com", jwtService.extractUsername(token));
        String type = jwtService.extractClaim(token, claims -> claims.get("type", String.class));
        assertEquals("access", type);
    }

    @Test
    void generateRefreshTokenIncludesRefreshType() {
        JwtService jwtService = buildJwtService(
                "245f99ebadb01b0dd4a7be0546098deaf89a9a12101745c140c27013edf3fb92", 300000L, 86400000L);

        String token = jwtService.generateRefreshToken("alice@example.com", Map.of("userId", 1L));

        assertTrue(jwtService.isTokenValid(token));
        String type = jwtService.extractClaim(token, claims -> claims.get("type", String.class));
        assertEquals("refresh", type);
    }

    @Test
    void isTokenValidReturnsFalseForTamperedToken() {
        JwtService jwtService = buildJwtService(
                "245f99ebadb01b0dd4a7be0546098deaf89a9a12101745c140c27013edf3fb92", 300000L, 86400000L);

        String token = jwtService.generateAccessToken("alice@example.com", Map.of());

        assertFalse(jwtService.isTokenValid(token + "x"));
    }

    @Test
    void isTokenValidWithUserDetailsChecksSubject() {
        JwtService jwtService = buildJwtService(
                "245f99ebadb01b0dd4a7be0546098deaf89a9a12101745c140c27013edf3fb92", 300000L, 86400000L);

        String token = jwtService.generateAccessToken("alice@example.com", Map.of());
        UserDetails sameUser = new User("alice@example.com", "pw", java.util.List.of());
        UserDetails otherUser = new User("bob@example.com", "pw", java.util.List.of());

        assertTrue(jwtService.isTokenValid(token, sameUser));
        assertFalse(jwtService.isTokenValid(token, otherUser));
    }

    @Test
    void validateSecretRejectsShortSecret() throws Exception {
        JwtService jwtService = new JwtService();
        setField(jwtService, "jwtSecret", "short-secret");
        setField(jwtService, "jwtExpiration", 300000L);
        setField(jwtService, "refreshExpiration", 86400000L);

        Method validate = JwtService.class.getDeclaredMethod("validateSecret");
        validate.setAccessible(true);

        InvocationTargetException ex = assertThrows(InvocationTargetException.class, () -> validate.invoke(jwtService));
        assertTrue(ex.getCause() instanceof IllegalStateException);
        assertNotNull(ex.getCause().getMessage());
    }

    private JwtService buildJwtService(String secret, long accessMs, long refreshMs) {
        try {
            JwtService jwtService = new JwtService();
            setField(jwtService, "jwtSecret", secret);
            setField(jwtService, "jwtExpiration", accessMs);
            setField(jwtService, "refreshExpiration", refreshMs);

            Method validate = JwtService.class.getDeclaredMethod("validateSecret");
            validate.setAccessible(true);
            validate.invoke(jwtService);
            return jwtService;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void setField(Object target, String fieldName, Object value) throws Exception {
        Field field = JwtService.class.getDeclaredField(fieldName);
        field.setAccessible(true);
        field.set(target, value);
    }
}
