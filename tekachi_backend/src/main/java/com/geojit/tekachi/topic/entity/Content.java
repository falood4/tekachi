package com.geojit.tekachi.topic.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "topic_content")
public class Content {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long content_id;

    @JoinColumn(name = "topic_id")
    @OneToOne
    private Title title;

    @Column(name = "content_text")
    private String content;
}
