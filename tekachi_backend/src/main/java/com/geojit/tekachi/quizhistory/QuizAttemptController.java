package com.geojit.tekachi.quizhistory;

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
                    java.util.Map.of("error", "userId must be a positive number"));
        }

        return ResponseEntity.ok(quizAttemptService.getAttemptHistory(userId));
    }

    @GetMapping("/history/{attemptId}")
    public ResponseEntity<?> getAttemptAnswers(@PathVariable Long attemptId) {
        if (attemptId == null || attemptId <= 0) {
            return ResponseEntity.badRequest().body(
                    java.util.Map.of("error", "attemptId must be a positive number"));
        }

        return ResponseEntity.ok(quizAnswerService.getAnswers(attemptId));
    }

}
