package com.geojit.tekachi.quizhistory.repository;

import com.geojit.tekachi.quizhistory.dtos.AttemptView;
import com.geojit.tekachi.quizhistory.entity.Attempt;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AttemptRepo extends JpaRepository<Attempt, Long> {

    @Query(value = """
            SELECT
                attempt_id AS attemptId,
                user_id AS userId,
                attempted_on AS attemptedOn,
                score AS score

                FROM aptitude_attempts
                WHERE user_id = :userId
                ORDER BY attempted_on
            """, nativeQuery = true)
    List<AttemptView> findAttemptByUserId(@Param("userId") Long userId);

}
