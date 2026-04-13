package com.geojit.tekachi.quizhistory.topic.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.geojit.tekachi.quizhistory.topic.dtos.ContentView;
import com.geojit.tekachi.quizhistory.topic.entity.Content;
import com.geojit.tekachi.quizhistory.topic.entity.Title;

@Repository
public interface ContentRepo extends JpaRepository<Content, Long> {

    ContentView findByTitle(Title title);
}
