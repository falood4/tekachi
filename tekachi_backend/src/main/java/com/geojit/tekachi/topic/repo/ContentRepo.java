package com.geojit.tekachi.topic.repo;

import com.geojit.tekachi.topic.dtos.ContentView;
import com.geojit.tekachi.topic.entity.Content;
import com.geojit.tekachi.topic.entity.Title;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ContentRepo extends JpaRepository<Content, Long> {

    ContentView findByTitle(Title title);
}
