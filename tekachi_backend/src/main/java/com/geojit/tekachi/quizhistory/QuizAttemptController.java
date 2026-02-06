package com.geojit.tekachi.quizhistory;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;

import com.geojit.tekachi.quizhistory.services.QuizAttemptService;

@RestController
@CrossOrigin
public class QuizAttemptController {
    private final QuizAttemptService quizAttemptService;

    QuizAttemptController(QuizAttemptService quizAttemptService) {
        this.quizAttemptService = quizAttemptService;
    }

    @GetMapping("/history/{userId}/attempts")
    public ResponseEntity<?> getUserAttemptHistory(@PathVariable Long userId) {
        if (userId == null || userId <= 0) {
            return ResponseEntity.badRequest().body(
                    java.util.Map.of("error", "userId must be a positive number"));
        }

        return ResponseEntity.ok(quizAttemptService.getAttemptReview(userId));
    }

    @GetMapping("/history/{userId}/attempts/{attemptId}")
    public ResponseEntity<?> getUserAttemptAnswers(@PathVariable Long userId,
            @PathVariable Long attemptId) {
        if (userId == null || userId <= 0 || attemptId == null || attemptId <= 0) {
            return ResponseEntity.badRequest().body(
                    java.util.Map.of("error", "userId or attemptId must be a positive number"));
        }

        return ResponseEntity.ok(quizAttemptService.getAttemptReview(userId));
    }

}
