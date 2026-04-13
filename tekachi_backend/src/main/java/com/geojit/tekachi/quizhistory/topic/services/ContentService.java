package com.geojit.tekachi.quizhistory.topic.services;

import org.springframework.stereotype.Service;

import com.geojit.tekachi.quizhistory.topic.dtos.ContentView;
import com.geojit.tekachi.quizhistory.topic.entity.Title;
import com.geojit.tekachi.quizhistory.topic.repo.ContentRepo;

@Service
public class ContentService {

    private final ContentRepo contentRepo;

    private ContentService(ContentRepo contentRepo) {
        this.contentRepo = contentRepo;
    }

    public ContentView findByTitle(Title title) {
        return contentRepo.findByTitle(title);
    }
}
