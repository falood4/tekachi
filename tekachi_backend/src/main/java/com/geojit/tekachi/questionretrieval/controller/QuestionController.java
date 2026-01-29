package com.geojit.tekachi.questionretrieval.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import com.geojit.tekachi.questionretrieval.entity.Question;
import com.geojit.tekachi.questionretrieval.service.QuestionService;

@RestController
public class QuestionController {
    @Autowired
    private QuestionService questionService;

    @GetMapping("/questions/{id}")
    public Question getQuestion(@PathVariable Integer id) {
        return questionService.findById(id);
    }
}
