package com.geojit.tekachi.usersignin.service;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.io.IOException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class JwtAuthFilterSecurityTest {

    @Mock
    private JwtService jwtService;

    @Mock
    private CustomUserDetailsService customUserDetailsService;

    @Mock
    private TokenBlacklistService tokenBlacklistService;

    @Mock
    private FilterChain filterChain;

    private JwtAuthFilter jwtAuthFilter;

    @BeforeEach
    void setUp() {
        jwtAuthFilter = new JwtAuthFilter(jwtService, customUserDetailsService, tokenBlacklistService);
    }

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void blocksBlacklistedToken() throws ServletException, IOException {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("Authorization", "Bearer blocked-token");
        MockHttpServletResponse response = new MockHttpServletResponse();

        when(tokenBlacklistService.isTokenBlacklisted("blocked-token")).thenReturn(true);

        jwtAuthFilter.doFilterInternal(request, response, filterChain);

        assertEquals(401, response.getStatus());
        assertEquals("Token blacklisted", response.getContentAsString());
        verify(filterChain, never()).doFilter(any(), any());
    }

    @Test
    void blocksRefreshTokenInAuthorizationHeader() throws ServletException, IOException {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("Authorization", "Bearer token");
        MockHttpServletResponse response = new MockHttpServletResponse();

        when(tokenBlacklistService.isTokenBlacklisted("token")).thenReturn(false);
        when(jwtService.isTokenValid("token")).thenReturn(true);
        when(jwtService.extractClaim(eq("token"), any())).thenReturn("refresh");

        jwtAuthFilter.doFilterInternal(request, response, filterChain);

        assertEquals(401, response.getStatus());
        assertEquals("Refresh token detected. Access token required.", response.getContentAsString());
        verify(filterChain, never()).doFilter(any(), any());
    }

    @Test
    void blocksTokenWithUnknownSubject() throws ServletException, IOException {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("Authorization", "Bearer token");
        MockHttpServletResponse response = new MockHttpServletResponse();

        when(tokenBlacklistService.isTokenBlacklisted("token")).thenReturn(false);
        when(jwtService.isTokenValid("token")).thenReturn(true);
        when(jwtService.extractClaim(eq("token"), any())).thenReturn("access");
        when(jwtService.extractEmail("token")).thenReturn("missing@example.com");
        doThrow(new UsernameNotFoundException("User not found"))
                .when(customUserDetailsService).loadUserByUsername("missing@example.com");

        jwtAuthFilter.doFilterInternal(request, response, filterChain);

        assertEquals(401, response.getStatus());
        assertEquals("Invalid token subject", response.getContentAsString());
        verify(filterChain, never()).doFilter(any(), any());
    }

    @Test
    void allowsValidAccessTokenAndSetsAuthentication() throws ServletException, IOException {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("Authorization", "Bearer access-token");
        MockHttpServletResponse response = new MockHttpServletResponse();

        UserDetails userDetails = new User("alice@example.com", "pw", List.of());

        when(tokenBlacklistService.isTokenBlacklisted("access-token")).thenReturn(false);
        when(jwtService.isTokenValid("access-token")).thenReturn(true);
        when(jwtService.extractClaim(eq("access-token"), any())).thenReturn("access");
        when(jwtService.extractEmail("access-token")).thenReturn("alice@example.com");
        when(customUserDetailsService.loadUserByUsername("alice@example.com")).thenReturn(userDetails);

        jwtAuthFilter.doFilterInternal(request, response, filterChain);

        assertNotNull(SecurityContextHolder.getContext().getAuthentication());
        verify(filterChain).doFilter(any(), any());
    }
}
