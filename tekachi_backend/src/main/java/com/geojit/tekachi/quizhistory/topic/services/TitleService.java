package com.geojit.tekachi.quizhistory.topic.services;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.geojit.tekachi.quizhistory.topic.dtos.TitleView;
import com.geojit.tekachi.quizhistory.topic.entity.Title;
import com.geojit.tekachi.quizhistory.topic.repo.TitleRepo;

@Service
public class TitleService {
    private final TitleRepo titleRepo;

    public TitleService(TitleRepo titleRepo) {
        this.titleRepo = titleRepo;
    }

    public List<TitleView> findTopics(int low, int high) {
        return titleRepo.findTopicTitles(low, high);
    }

    public Title findById(int int1) {
        return titleRepo.findById((long) int1)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Topic not found"));
    }
}
