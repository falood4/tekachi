package com.geojit.tekachi.quizhistory;

import com.geojit.tekachi.questionretrieval.entity.Option;
import com.geojit.tekachi.questionretrieval.entity.Question;
import com.geojit.tekachi.questionretrieval.repository.OptionRepo;
import com.geojit.tekachi.questionretrieval.repository.QuestionRepo;
import com.geojit.tekachi.quizhistory.entity.Answer;
import com.geojit.tekachi.quizhistory.entity.Attempt;
import com.geojit.tekachi.quizhistory.repository.AttemptRepo;
import com.geojit.tekachi.quizhistory.services.AnswerService;
import com.geojit.tekachi.quizhistory.services.AttemptService;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.repository.UserRepository;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class QuizAttemptControllerTest {

    @Mock
    private AttemptService attemptService;

    @Mock
    private AnswerService answerService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private AttemptRepo attemptRepo;

    @Mock
    private QuestionRepo questionRepo;

    @Mock
    private OptionRepo optionRepo;

    @AfterEach
    void tearDown() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void getUserAttemptHistoryRejectsOtherUsers() {
        QuizAttemptController controller = new QuizAttemptController(
                attemptService, answerService, userRepository, attemptRepo, questionRepo, optionRepo);
        setAuthenticatedUser("alice@example.com", 1L);

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> controller.getUserAttemptHistory(2L));

        assertEquals(HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    @Test
    void getUserAttemptHistoryReturnsNotFoundWhenEmpty() {
        QuizAttemptController controller = new QuizAttemptController(
                attemptService, answerService, userRepository, attemptRepo, questionRepo, optionRepo);
        setAuthenticatedUser("alice@example.com", 1L);
        when(attemptService.getAttemptHistory(1L)).thenReturn(List.of());

        ResponseEntity<?> response = controller.getUserAttemptHistory(1L);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void storeAttemptRejectsOutOfRangeScore() {
        QuizAttemptController controller = new QuizAttemptController(
                attemptService, answerService, userRepository, attemptRepo, questionRepo, optionRepo);
        setAuthenticatedUser("alice@example.com", 1L);

        ResponseEntity<?> response = controller.storeAttempt(Map.of("correctAnswers", 16));

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    @Test
    void storeAttemptRejectsAnotherUser() {
        QuizAttemptController controller = new QuizAttemptController(
                attemptService, answerService, userRepository, attemptRepo, questionRepo, optionRepo);
        setAuthenticatedUser("alice@example.com", 1L);

        ResponseEntity<?> response = controller.storeAttempt(Map.of(
                "user", 2,
                "correctAnswers", 7));

        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
    }

    @Test
    void storeAttemptCreatesAttemptForAuthenticatedUser() {
        QuizAttemptController controller = new QuizAttemptController(
                attemptService, answerService, userRepository, attemptRepo, questionRepo, optionRepo);
        setAuthenticatedUser("alice@example.com", 1L);

        Attempt saved = new Attempt();
        saved.setAttemptId(20L);
        saved.setAttemptedOn(LocalDateTime.now());
        saved.setCorrectAnswers(10);
        User u = new User();
        u.setId(1L);
        saved.setUser(u);

        when(attemptService.newAttempt(any(Attempt.class))).thenReturn(saved);

        ResponseEntity<?> response = controller.storeAttempt(Map.of(
                "user", 1,
                "correctAnswers", 10));

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        verify(attemptService).newAttempt(any(Attempt.class));
    }

    @Test
    void storeAnswerRejectsOptionThatDoesNotBelongToQuestion() {
        QuizAttemptController controller = new QuizAttemptController(
                attemptService, answerService, userRepository, attemptRepo, questionRepo, optionRepo);
        setAuthenticatedUser("alice@example.com", 1L);

        Attempt attempt = new Attempt();
        User owner = new User();
        owner.setId(1L);
        attempt.setUser(owner);
        when(attemptRepo.findById(4L)).thenReturn(Optional.of(attempt));

        Question question = new Question();
        question.setQId(9);
        when(questionRepo.findById(9)).thenReturn(Optional.of(question));

        Question anotherQuestion = new Question();
        anotherQuestion.setQId(10);
        Option option = new Option();
        option.setQuestion(anotherQuestion);
        when(optionRepo.findById(3)).thenReturn(Optional.of(option));

        ResponseEntity<?> response = controller.storeAnswer(Map.of(
                "attemptId", 4,
                "QId", 9,
                "selectedOption", 3));

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    @Test
    void storeAnswerCreatesAnswerWhenDataIsValid() {
        QuizAttemptController controller = new QuizAttemptController(
                attemptService, answerService, userRepository, attemptRepo, questionRepo, optionRepo);
        setAuthenticatedUser("alice@example.com", 1L);

        Attempt attempt = new Attempt();
        attempt.setAttemptId(4L);
        User owner = new User();
        owner.setId(1L);
        attempt.setUser(owner);
        when(attemptRepo.findById(4L)).thenReturn(Optional.of(attempt));

        Question question = new Question();
        question.setQId(9);
        when(questionRepo.findById(9)).thenReturn(Optional.of(question));

        Option option = new Option();
        option.setOpId(3);
        option.setQuestion(question);
        when(optionRepo.findById(3)).thenReturn(Optional.of(option));

        Answer saved = new Answer();
        saved.setAnswerId(100L);
        saved.setAttempt(attempt);
        saved.setQuestion(question);
        saved.setSelectedOption(option);
        when(answerService.newAnswer(any(Answer.class))).thenReturn(saved);

        ResponseEntity<?> response = controller.storeAnswer(Map.of(
                "attemptId", 4,
                "QId", 9,
                "selectedOption", 3));

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
    }

    @Test
    void deleteAnswersByAttemptIdRejectsUnownedAttempt() {
        QuizAttemptController controller = new QuizAttemptController(
                attemptService, answerService, userRepository, attemptRepo, questionRepo, optionRepo);
        setAuthenticatedUser("alice@example.com", 1L);

        Attempt attempt = new Attempt();
        User owner = new User();
        owner.setId(2L);
        attempt.setUser(owner);
        when(attemptRepo.findById(4L)).thenReturn(Optional.of(attempt));

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> controller.deleteAnswersByAttemptId(4L));

        assertEquals(HttpStatus.FORBIDDEN, ex.getStatusCode());
    }

    @Test
    void getAttemptScoreFormatsCorrectly() {
        QuizAttemptController controller = new QuizAttemptController(
                attemptService, answerService, userRepository, attemptRepo, questionRepo, optionRepo);

        Attempt attempt = new Attempt();
        attempt.setCorrectAnswers(12);
        attempt.setTotalQuestions(15);
        when(attemptService.findById(5L)).thenReturn(attempt);

        String score = controller.getAttemptScore(5L);

        assertEquals("12/15", score);
    }

    private void setAuthenticatedUser(String email, Long id) {
        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(email, null, List.of());
        SecurityContextHolder.getContext().setAuthentication(auth);

        User user = new User();
        user.setId(id);
        user.setEmail(email);
        when(userRepository.findByEmail(email)).thenReturn(user);
    }
}
