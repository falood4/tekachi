package com.geojit.tekachi.usersignin.service;

import com.geojit.tekachi.usersignin.entity.BlacklistedToken;
import com.geojit.tekachi.usersignin.repository.BlacklistedTokenRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TokenBlacklistServiceTest {

    @Mock
    private BlacklistedTokenRepository blacklistedTokenRepository;

    @Mock
    private JwtService jwtService;

    @InjectMocks
    private TokenBlacklistService tokenBlacklistService;

    @Test
    void blacklistTokenIgnoresBlankInput() {
        tokenBlacklistService.blacklistToken("  ");

        verify(blacklistedTokenRepository, never()).save(any());
    }

    @Test
    void blacklistTokenStoresHashedTokenAndExpiry() {
        String token = "header.payload.signature";
        Date expiry = Date.from(LocalDateTime.now().plusHours(1).atZone(ZoneId.systemDefault()).toInstant());
        when(jwtService.extractExpiration(token)).thenReturn(expiry);

        tokenBlacklistService.blacklistToken(token);

        verify(blacklistedTokenRepository).deleteByExpiresAtBefore(any(LocalDateTime.class));
        ArgumentCaptor<BlacklistedToken> captor = ArgumentCaptor.forClass(BlacklistedToken.class);
        verify(blacklistedTokenRepository).save(captor.capture());

        BlacklistedToken saved = captor.getValue();
        assertEquals(64, saved.getTokenHash().length());
        assertNotEquals(token, saved.getTokenHash());
        assertEquals(expiry.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime(), saved.getExpiresAt());
    }

    @Test
    void isTokenBlacklistedReturnsFalseForBlankToken() {
        assertFalse(tokenBlacklistService.isTokenBlacklisted(""));
    }

    @Test
    void isTokenBlacklistedQueriesRepositoryWithHashedValue() {
        when(blacklistedTokenRepository.existsByTokenHashAndExpiresAtAfter(anyString(), any(LocalDateTime.class)))
                .thenReturn(true);

        boolean blacklisted = tokenBlacklistService.isTokenBlacklisted("token");

        assertTrue(blacklisted);
        verify(blacklistedTokenRepository).existsByTokenHashAndExpiresAtAfter(anyString(), any(LocalDateTime.class));
    }

    @Test
    void removeTokenIgnoresBlankInput() {
        tokenBlacklistService.removeToken(" ");

        verify(blacklistedTokenRepository, never()).deleteById(anyString());
    }

    @Test
    void removeTokenDeletesByHashedId() {
        tokenBlacklistService.removeToken("token-value");

        verify(blacklistedTokenRepository).deleteById(anyString());
    }
}
