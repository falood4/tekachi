package com.geojit.tekachi.quizhistory.repository;

import com.geojit.tekachi.quizhistory.dtos.AttemptView;
import com.geojit.tekachi.quizhistory.entity.AttemptedAnswer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AttemptRepo
        extends JpaRepository<AttemptedAnswer, Long> {

    @Query(value = """
            SELECT
                att.attempt_id AS attemptId,
                att.user_id AS userId,
                a.answer_id AS answerId,

                q.q_id AS qId,
                q.qsn AS qString,

                o.op_id AS opId,
                o.op AS op,

                q.q_correct_option AS qCorrectOption,

                CASE
                    WHEN o.op_id = a.selected_op_id THEN 1 ELSE 0
                END                 AS isSelected

            FROM aptitude_attempts att
            JOIN aptitude_answers a
                ON att.attempt_id = a.attempt_id
            JOIN questions q
                ON a.q_id = q.q_id
            JOIN options o
                ON o.q_id = q.q_id

            WHERE att.user_id = :userId
            ORDER BY att.attempt_id;
            """, nativeQuery = true)
    List<AttemptView> findAttemptAnswersByUserId(
            @Param("userId") Long userId);
}
