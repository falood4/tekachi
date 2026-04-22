package com.geojit.tekachi.quizhistory.services;

import com.geojit.tekachi.quizhistory.dtos.AnswerView;
import com.geojit.tekachi.quizhistory.entity.Answer;
import com.geojit.tekachi.quizhistory.repository.AnswerRepo;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AnswerServiceTest {

    @Mock
    private AnswerRepo answerRepo;

    @InjectMocks
    private AnswerService answerService;

    @Test
    void getAnswersDelegatesToRepository() {
        List<AnswerView> answers = List.of(org.mockito.Mockito.mock(AnswerView.class));
        when(answerRepo.findAnswersByAttemptId(5L)).thenReturn(answers);

        List<AnswerView> actual = answerService.getAnswers(5L);

        assertSame(answers, actual);
        verify(answerRepo).findAnswersByAttemptId(5L);
    }

    @Test
    void newAnswerDelegatesToRepository() {
        Answer answer = new Answer();
        Answer saved = new Answer();
        when(answerRepo.save(answer)).thenReturn(saved);

        Answer actual = answerService.newAnswer(answer);

        assertSame(saved, actual);
        verify(answerRepo).save(answer);
    }

    @Test
    void deleteAnswerHistoryDeletesAllAnswersForAttempt() {
        List<Answer> answers = List.of(new Answer(), new Answer());
        when(answerRepo.findByAttemptId(8L)).thenReturn(answers);

        answerService.deleteAnswerHistory(8L);

        verify(answerRepo).findByAttemptId(8L);
        verify(answerRepo).deleteAll(answers);
    }
}
