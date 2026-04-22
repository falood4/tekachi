package com.geojit.tekachi.questionretrieval.repository.service;

import com.geojit.tekachi.questionretrieval.entity.Question;
import com.geojit.tekachi.questionretrieval.repository.QuestionRepo;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class QuestionServiceTest {

    @Mock
    private QuestionRepo questionRepo;

    @InjectMocks
    private QuestionService questionService;

    @Test
    void findByIdReturnsQuestionWhenPresent() {
        Question question = new Question();
        question.setQId(42);
        when(questionRepo.findById(42)).thenReturn(Optional.of(question));

        Question actual = questionService.findById(42);

        assertSame(question, actual);
    }

    @Test
    void findByIdThrowsNotFoundWhenMissing() {
        when(questionRepo.findById(100)).thenReturn(Optional.empty());

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> questionService.findById(100));

        assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
        assertEquals("Question not found", ex.getReason());
    }
}
