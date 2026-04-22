package com.geojit.tekachi.topic.services;

import org.springframework.stereotype.Service;

import com.geojit.tekachi.topic.dtos.ContentView;
import com.geojit.tekachi.topic.entity.Title;
import com.geojit.tekachi.topic.repo.ContentRepo;

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
