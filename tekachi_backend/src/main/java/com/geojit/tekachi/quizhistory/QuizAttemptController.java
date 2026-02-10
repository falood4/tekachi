package com.geojit.tekachi.quizhistory;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.geojit.tekachi.questionretrieval.entity.Question;
import com.geojit.tekachi.questionretrieval.entity.Option;
import com.geojit.tekachi.questionretrieval.repository.OptionRepo;
import com.geojit.tekachi.questionretrieval.repository.QuestionRepo;
import com.geojit.tekachi.quizhistory.entity.Answer;
import com.geojit.tekachi.quizhistory.entity.Attempt;
import com.geojit.tekachi.quizhistory.repository.AttemptRepo;
import com.geojit.tekachi.quizhistory.services.AnswerService;
import com.geojit.tekachi.quizhistory.services.AttemptService;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.repository.UserRepository;

@RestController
@CrossOrigin
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

        List<?> history = quizAttemptService.getAttemptHistory(userId);
        if (history == null || history.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "No attempts found for userId", "userId", userId));
        }

        return ResponseEntity.ok(history);
    }

    @GetMapping("/history/{attemptId}")
    public ResponseEntity<?> getAttemptAnswers(@PathVariable Long attemptId) {

        List<?> answers = quizAnswerService.getAnswers(attemptId);
        if (answers == null || answers.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "No answers found for attemptId", "attemptId", attemptId));
        }

        return ResponseEntity.ok(answers);
    }

    @PostMapping("/history/newattempt")
    public ResponseEntity<?> storeAttempt(@RequestBody Map<String, Integer> request) {
        try {
            Integer user_id = request.get("user");
            Integer correct_answers = request.get("correctAnswers");

            if (user_id == null || user_id <= 0) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "user id is not accepted"));
            }

            LocalDateTime attempted_on = LocalDateTime.now();

            User user = userRepository.findById(user_id.longValue()).orElse(null);
            if (user == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Map.of("error", "User not found"));
            }

            Attempt attempt = new Attempt();
            attempt.setUser(user);
            attempt.setAttemptedOn(attempted_on);
            attempt.setTotalQuestions(15);
            attempt.setCorrectAnswers(correct_answers);

            Attempt saved = quizAttemptService.newAttempt(attempt);

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(Map.of(
                            "attempt_id", saved.getAttemptId(),
                            "user_id", saved.getUser().getId(),
                            "attempted_on", saved.getAttemptedOn(),
                            "correct_answers", saved.getCorrectAnswers(),
                            "message", "Attempt stored successfully"));

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
                        .body(Map.of("error", "attemptId id is not accepted"));
            }

            Attempt attempt = attemptRepo.findById(attempt_id.longValue()).orElse(null);
            if (attempt == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Map.of("error", "Attempt not found"));
            }

            Question question = questionRepo.findById(q_id).orElse(null);
            Option option = optionRepo.findById(selected_op_id).orElse(null);

            Answer answer = new Answer();
            answer.setAttempt(attempt);
            answer.setQuestion(question);
            answer.setSelectedOption(option);

            Answer saved = quizAnswerService.newAnswer(answer);

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(Map.of(
                            "answer_id", saved.getAnswerId(),
                            "attempt_id", saved.getAttempt(),
                            "q_id", saved.getQuestion(),
                            "selected_op_Id", saved.getSelectedOption(),
                            "message", "Answer stored successfully"));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("error", e.getMessage()));
        }
    }

}
