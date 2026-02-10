package com.geojit.tekachi.quizhistory.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.geojit.tekachi.quizhistory.entity.Answer;
import com.geojit.tekachi.quizhistory.dtos.AnswerView;

import java.util.List;

@Repository
public interface AnswerRepo extends JpaRepository<Answer, Long> {

    @Query(value = """
             SELECT
                a.answer_id        AS answerId,
                a.attempt_id       AS attemptId,
                q.q_id             AS qId,
                q.qsn              AS qString,

                a.selected_op_id   AS selectedOption,
                sel.op             AS selectedOptionText,

                q.correct_op_id    AS correctOption,
                cor.op             AS correctOptionText

            FROM aptitude_answers a
            JOIN questions q
                ON a.q_id = q.q_id

            -- selected option
            LEFT JOIN options sel
                ON sel.op_id = a.selected_op_id

            -- correct option
            LEFT JOIN options cor
                ON cor.op_id = q.correct_op_id

            WHERE a.attempt_id = :attemptId
            ORDER BY a.answer_id
            """, nativeQuery = true)
    List<AnswerView> findAnswersByAttemptId(@Param("attemptId") Long attemptId);

    @Query("SELECT a FROM Answer a WHERE a.attempt.attemptId = :attemptId")
    List<Answer> findByAttemptId(@Param("attemptId") Long attemptId);
}