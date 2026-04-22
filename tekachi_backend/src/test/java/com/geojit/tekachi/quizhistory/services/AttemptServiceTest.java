package com.geojit.tekachi.quizhistory.services;

import com.geojit.tekachi.quizhistory.entity.Attempt;
import com.geojit.tekachi.quizhistory.repository.AttemptRepo;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InOrder;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AttemptServiceTest {

    @Mock
    private AttemptRepo attemptRepo;

    @Mock
    private AnswerService answerService;

    @InjectMocks
    private AttemptService attemptService;

    @Test
    void findByIdReturnsAttemptWhenPresent() {
        Attempt attempt = new Attempt();
        attempt.setAttemptId(13L);
        when(attemptRepo.findById(13L)).thenReturn(Optional.of(attempt));

        Attempt actual = attemptService.findById(13L);

        assertSame(attempt, actual);
    }

    @Test
    void findByIdThrowsNotFoundWhenMissing() {
        when(attemptRepo.findById(99L)).thenReturn(Optional.empty());

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> attemptService.findById(99L));

        assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
        assertEquals("Atttempt not found", ex.getReason());
    }

    @Test
    void deleteAttemptHistoryDeletesAnswersThenAttempts() {
        Attempt first = new Attempt();
        first.setAttemptId(1L);
        Attempt second = new Attempt();
        second.setAttemptId(2L);
        List<Attempt> attempts = List.of(first, second);

        when(attemptRepo.findByUserId(7L)).thenReturn(attempts);

        attemptService.deleteAttemptHistory(7L);

        InOrder order = inOrder(answerService, attemptRepo);
        order.verify(answerService).deleteAnswerHistory(1L);
        order.verify(answerService).deleteAnswerHistory(2L);
        order.verify(attemptRepo).deleteAll(attempts);
        verify(attemptRepo).findByUserId(7L);
    }
}
