package com.geojit.tekachi.quizhistory.services;

import java.util.List;

import org.springframework.stereotype.Service;

import com.geojit.tekachi.quizhistory.dtos.AnswerView;
import com.geojit.tekachi.quizhistory.entity.Answer;
import com.geojit.tekachi.quizhistory.repository.AnswerRepo;

@Service
public class AnswerService {
    private final AnswerRepo answerRepo;

    public AnswerService(AnswerRepo answerRepo) {
        this.answerRepo = answerRepo;
    }

    public List<AnswerView> getAnswers(Long attemptId) {
        return answerRepo.findAnswersByAttemptId(attemptId);
    }

    public Answer newAnswer(Answer attempt) {
        return answerRepo.save(attempt);
    }

    public void deleteAnswerHistory(Long attemptId) {
        List<Answer> answers = answerRepo.findByAttemptId(attemptId);
        answerRepo.deleteAll(answers);
    }
}
