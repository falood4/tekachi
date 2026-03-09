package com.geojit.tekachi.usersignin.repository;

import com.geojit.tekachi.usersignin.entity.BlacklistedToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface BlacklistedTokenRepository extends JpaRepository<BlacklistedToken, String> {
    boolean existsByTokenHashAndExpiresAtAfter(String tokenHash, LocalDateTime now);

    void deleteByExpiresAtBefore(LocalDateTime now);
}
