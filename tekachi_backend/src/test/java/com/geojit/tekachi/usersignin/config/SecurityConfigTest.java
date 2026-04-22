package com.geojit.tekachi.usersignin.config;

import com.geojit.tekachi.usersignin.service.JwtAuthFilter;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@ExtendWith(MockitoExtension.class)
class SecurityConfigTest {

    @Mock
    private JwtAuthFilter jwtAuthFilter;

    @Test
    void corsConfigurationIncludesConfiguredOriginsAndMethods() {
        SecurityConfig config = new SecurityConfig(
                jwtAuthFilter,
                "http://localhost:3000, http://localhost:5173");

        CorsConfigurationSource source = config.corsConfigurationSource();
        CorsConfiguration cors = source.getCorsConfiguration(new org.springframework.mock.web.MockHttpServletRequest());

        assertEquals(2, cors.getAllowedOrigins().size());
        assertTrue(cors.getAllowedOrigins().contains("http://localhost:3000"));
        assertTrue(cors.getAllowedOrigins().contains("http://localhost:5173"));
        assertTrue(cors.getAllowedMethods().contains("GET"));
        assertTrue(cors.getAllowedMethods().contains("POST"));
    }

    @Test
    void passwordEncoderEncodesAndMatchesRawPassword() {
        SecurityConfig config = new SecurityConfig(
                jwtAuthFilter,
                "http://localhost:3000");

        PasswordEncoder encoder = config.passwordEncoder();
        String hashed = encoder.encode("secret");

        assertNotEquals("secret", hashed);
        assertTrue(encoder.matches("secret", hashed));
    }
}
