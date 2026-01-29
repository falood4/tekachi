package com.geojit.tekachi.questionretrieval.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.geojit.tekachi.questionretrieval.entity.Question;
import com.geojit.tekachi.questionretrieval.repository.QuestionRepo;

@Service
public class QuestionService {

    @Autowired
    private QuestionRepo questionRepo;

    public Question findById(Integer id) {
        return questionRepo.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Question not found"));
    }
}
