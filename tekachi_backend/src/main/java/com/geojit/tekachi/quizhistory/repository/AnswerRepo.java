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
            SELECT a.answer_id as answerId,
                   a.attempt_id as attemptId,
                   q.q_id as qId,
                   q.qsn as qString,
                   a.selected_op_id as selectedOption
              FROM aptitude_answers a
              JOIN questions q ON a.q_id = q.q_id
             WHERE a.attempt_id = :attemptId
            """, nativeQuery = true)
    List<AnswerView> findAnswersByAttemptId(@Param("attemptId") Long attemptId);
}