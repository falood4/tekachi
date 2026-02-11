package com.geojit.tekachi.topic.repo;

import com.geojit.tekachi.topic.dtos.TitleView;
import com.geojit.tekachi.topic.entity.Title;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface TitleRepo extends JpaRepository<Title, Long> {
    @Query(value = """
                    SELECT
                    topic_id AS topicID,
                    topic_title AS titleString
              FROM training_topics
              WHERE topic_id>= :low AND topic_id<= :high
            """, nativeQuery = true)
    List<TitleView> findTopicTitles(@Param("low") int low, @Param("high") int high);
}
