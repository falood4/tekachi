package com.geojit.tekachi.questionretrieval.controller;

import com.geojit.tekachi.questionretrieval.entity.Question;
import com.geojit.tekachi.questionretrieval.repository.service.QuestionService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class QuestionControllerTest {

    @Mock
    private QuestionService questionService;

    @InjectMocks
    private QuestionController questionController;

    @Test
    void getQuestionDelegatesToService() {
        Question question = new Question();
        question.setQId(1);
        when(questionService.findById(1)).thenReturn(question);

        Question actual = questionController.getQuestion(1);

        assertSame(question, actual);
        verify(questionService).findById(1);
    }
}
