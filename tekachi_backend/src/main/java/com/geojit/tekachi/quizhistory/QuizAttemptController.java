package com.geojit.tekachi.quizhistory;

import java.util.List;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.geojit.tekachi.quizhistory.services.AnswerService;
import com.geojit.tekachi.quizhistory.services.AttemptService;

@RestController
@CrossOrigin
public class QuizAttemptController {
    private final AttemptService quizAttemptService;
    private final AnswerService quizAnswerService;

    QuizAttemptController(AttemptService quizAttemptService, AnswerService quizAnswerService) {
        this.quizAttemptService = quizAttemptService;
        this.quizAnswerService = quizAnswerService;
    }

    @GetMapping("/history/{userId}/attempts")
    public ResponseEntity<?> getUserAttemptHistory(@PathVariable Long userId) {
        if (userId == null || userId <= 0) {
            return ResponseEntity.badRequest().body(
                    Map.of("error", "userId must be a positive number"));
        }

        List<?> history = quizAttemptService.getAttemptHistory(userId);
        if (history == null || history.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "No attempts found for userId", "userId", userId));
        }

        return ResponseEntity.ok(history);
    }

    @GetMapping("/history/{attemptId}")
    public ResponseEntity<?> getAttemptAnswers(@PathVariable Long attemptId) {
        if (attemptId == null || attemptId <= 0) {
            return ResponseEntity.badRequest().body(
                    java.util.Map.of("error", "attemptId must be a positive number"));
        }

        List<?> answers = quizAnswerService.getAnswers(attemptId);
        if (answers == null || answers.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "No answers found for attemptId", "attemptId", attemptId));
        }

        return ResponseEntity.ok(answers);
    }

}
