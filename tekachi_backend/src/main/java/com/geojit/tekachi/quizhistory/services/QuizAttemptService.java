package com.geojit.tekachi.quizhistory.services;

import java.util.List;

import org.springframework.stereotype.Service;

import com.geojit.tekachi.quizhistory.dtos.AttemptView;
import com.geojit.tekachi.quizhistory.repository.AttemptRepo;

@Service
public class QuizAttemptService {

    private final AttemptRepo attemptedRepo;

    public QuizAttemptService(AttemptRepo attemptedRepo) {
        this.attemptedRepo = attemptedRepo;
    }

    public List<AttemptView> getAttemptReview(Long userId) {
        return attemptedRepo.findAttemptAnswersByUserId(userId);
    }
}
