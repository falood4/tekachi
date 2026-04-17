package com.geojit.tekachi.usersignin.service;

import com.geojit.tekachi.usersignin.entity.BlacklistedToken;
import com.geojit.tekachi.usersignin.repository.BlacklistedTokenRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.HexFormat;

@Service
public class TokenBlacklistService {

    private final BlacklistedTokenRepository blacklistedTokenRepository;
    private final JwtService jwtService;

    public TokenBlacklistService(BlacklistedTokenRepository blacklistedTokenRepository, JwtService jwtService) {
        this.blacklistedTokenRepository = blacklistedTokenRepository;
        this.jwtService = jwtService;
    }

    @Transactional
    public void blacklistToken(String token) {
        if (token == null || token.isBlank()) {
            return;
        }

        blacklistedTokenRepository.deleteByExpiresAtBefore(LocalDateTime.now());

        BlacklistedToken blacklistedToken = new BlacklistedToken();
        blacklistedToken.setTokenHash(hashToken(token));
        try {
            blacklistedToken.setExpiresAt(
                    jwtService.extractExpiration(token).toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime());
        } catch (Exception e) {
            blacklistedToken.setExpiresAt(LocalDateTime.now());
        }
        blacklistedTokenRepository.save(blacklistedToken);
    }

    public boolean isTokenBlacklisted(String token) {
        if (token == null || token.isBlank()) {
            return false;
        }

        return blacklistedTokenRepository.existsByTokenHashAndExpiresAtAfter(hashToken(token), LocalDateTime.now());
    }

    @Transactional
    public void removeToken(String token) {
        if (token == null || token.isBlank()) {
            return;
        }
        blacklistedTokenRepository.deleteById(hashToken(token));
    }

    private String hashToken(String token) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashed = digest.digest(token.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hashed);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 algorithm not available", e);
        }
    }
}
