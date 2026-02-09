package com.geojit.tekachi.quizhistory.services;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.geojit.tekachi.quizhistory.dtos.AttemptView;
import com.geojit.tekachi.quizhistory.entity.Attempt;
import com.geojit.tekachi.quizhistory.repository.AttemptRepo;

@Service
public class AttemptService {
    private final AttemptRepo attemptedRepo;

    public AttemptService(AttemptRepo attemptedRepo) {
        this.attemptedRepo = attemptedRepo;
    }

    public List<AttemptView> getAttemptHistory(Long userId) {
        return attemptedRepo.findAttemptByUserId(userId);
    }

    public Attempt findById(Long id) {
        return attemptedRepo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Atttempt not found"));
    }

    public Attempt newAttempt(Attempt attempt) {
        return attemptedRepo.save(attempt);
    }
}
