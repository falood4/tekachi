package com.geojit.tekachi.quizhistory.topic.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "training_topics")
public class Title {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long topic_id;

    @Column(name = "topic_title")
    private String titleString;

}
