package com.geojit.tekachi.quizhistory;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import com.geojit.tekachi.questionretrieval.entity.Question;
import com.geojit.tekachi.questionretrieval.entity.Option;
import com.geojit.tekachi.questionretrieval.repository.OptionRepo;
import com.geojit.tekachi.questionretrieval.repository.QuestionRepo;
import com.geojit.tekachi.quizhistory.entity.Answer;
import com.geojit.tekachi.quizhistory.entity.Attempt;
import com.geojit.tekachi.quizhistory.services.AnswerService;
import com.geojit.tekachi.quizhistory.services.AttemptService;
import com.geojit.tekachi.quizhistory.repository.AttemptRepo;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.repository.UserRepository;

@RestController
public class QuizAttemptController {
    private final AttemptService quizAttemptService;
    private final AnswerService quizAnswerService;
    private final UserRepository userRepository;
    private final AttemptRepo attemptRepo;
    private final QuestionRepo questionRepo;
    private final OptionRepo optionRepo;

    QuizAttemptController(AttemptService quizAttemptService, AnswerService quizAnswerService,
            UserRepository userRepository, AttemptRepo attemptRepo, QuestionRepo questionRepo, OptionRepo optionRepo) {
        this.quizAttemptService = quizAttemptService;
        this.quizAnswerService = quizAnswerService;
        this.userRepository = userRepository;
        this.attemptRepo = attemptRepo;
        this.questionRepo = questionRepo;
        this.optionRepo = optionRepo;
    }

    @GetMapping("/history/{userId}/attempts")
    public ResponseEntity<?> getUserAttemptHistory(@PathVariable Long userId) {
        ensurePathUserMatchesAuthenticated(userId);

        List<?> history = quizAttemptService.getAttemptHistory(userId).reversed();
        if (history == null || history.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "No attempts found for userId", "userId", userId));
        }

        return ResponseEntity.ok(history);
    }

    @GetMapping("/history/{attemptId}")
    public ResponseEntity<?> getAttemptAnswers(@PathVariable Long attemptId) {
        getOwnedAttempt(attemptId);

        List<?> answers = quizAnswerService.getAnswers(attemptId);
        if (answers == null || answers.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "No answers found for attemptId", "attemptId", attemptId));
        }

        return ResponseEntity.ok(answers);
    }

    @GetMapping("/history/{attemptId}/score")
    public String getAttemptScore(@PathVariable Long attemptId) {
        Attempt attempt = quizAttemptService.findById(attemptId);
        String score = String.format("%d/%d", attempt.getCorrectAnswers(), attempt.getTotalQuestions());
        return score;
    }

    @PostMapping("/history/newattempt")
    public ResponseEntity<?> storeAttempt(@RequestBody Map<String, Integer> request) {
        try {
            User authenticatedUser = getAuthenticatedUser();
            Integer user_id = request.get("user");
            Integer correct_answers = request.get("correctAnswers");

            if (user_id != null && !authenticatedUser.getId().equals(user_id.longValue())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("error", "Cannot create attempt for another user"));
            }

            if (correct_answers == null || correct_answers < 0 || correct_answers > 15) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "correctAnswers must be between 0 and 15"));
            }

            LocalDateTime attempted_on = LocalDateTime.now();

            Attempt attempt = new Attempt();
            attempt.setUser(authenticatedUser);
            attempt.setAttemptedOn(attempted_on);
            attempt.setTotalQuestions(15);
            attempt.setCorrectAnswers(correct_answers);
            attempt.setScore(String.format("%d/15", correct_answers));

            Attempt saved = quizAttemptService.newAttempt(attempt);

            Map<String, Object> body = new HashMap<>();
            body.put("attempt_id", saved.getAttemptId());
            body.put("user_id", saved.getUser().getId());
            body.put("attempted_on", saved.getAttemptedOn());
            body.put("correct_answers", saved.getCorrectAnswers());
            body.put("score", saved.getScore() != null ? saved.getScore() : attempt.getScore());
            body.put("message", "Attempt stored successfully");

            return ResponseEntity.status(HttpStatus.CREATED).body(body);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/history/newanswer")
    public ResponseEntity<?> storeAnswer(@RequestBody Map<String, Integer> request) {
        try {
            Integer attempt_id = request.get("attemptId");
            Integer q_id = request.get("QId");
            Integer selected_op_id = request.get("selectedOption");

            if (attempt_id == null || attempt_id <= 0) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "attemptId is required"));
            }

            if (q_id == null || selected_op_id == null) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "QId and selectedOption are required"));
            }

            Attempt attempt = getOwnedAttempt(attempt_id.longValue());
            Question question = questionRepo.findById(q_id).orElse(null);
            Option option = optionRepo.findById(selected_op_id).orElse(null);

            if (question == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Map.of("error", "Question not found"));
            }

            if (option == null || option.getQuestion() == null
                    || !question.getQId().equals(option.getQuestion().getQId())) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Map.of("error", "Selected option does not belong to the question"));
            }

            Answer answer = new Answer();
            answer.setAttempt(attempt);
            answer.setQuestion(question);
            answer.setSelectedOption(option);

            Answer saved = quizAnswerService.newAnswer(answer);

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(Map.of(
                            "answer_id", saved.getAnswerId(),
                            "attempt_id", saved.getAttempt().getAttemptId(),
                            "q_id", saved.getQuestion().getQId(),
                            "selected_op_Id", saved.getSelectedOption().getOpId(),
                            "message", "Answer stored successfully"));

        } catch (ResponseStatusException e) {
            return ResponseEntity.status(e.getStatusCode())
                    .body(Map.of("error", e.getReason() == null ? "Request rejected" : e.getReason()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @DeleteMapping("/history/{userId}")
    public String deleteAttemptHistory(@PathVariable Long userId) {
        ensurePathUserMatchesAuthenticated(userId);
        quizAttemptService.deleteAttemptHistory(userId);
        return "User quiz history deleted successfully.";
    }

    @DeleteMapping("/history/answer/{attemptId}")
    public String deleteAnswersByAttemptId(@PathVariable Long attemptId) {
        getOwnedAttempt(attemptId);
        quizAnswerService.deleteAnswerHistory(attemptId);
        return "Answers for the attempt deleted successfully.";
    }

    private User getAuthenticatedUser() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByEmail(email);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Authenticated user not found");
        }
        return user;
    }

    private void ensurePathUserMatchesAuthenticated(Long userId) {
        if (!getAuthenticatedUser().getId().equals(userId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Cannot access another user's quiz history");
        }
    }

    private Attempt getOwnedAttempt(Long attemptId) {
        Attempt attempt = attemptRepo.findById(attemptId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Attempt not found"));
        if (!attempt.getUser().getId().equals(getAuthenticatedUser().getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Attempt does not belong to this user");
        }
        return attempt;
    }

}
