package com.geojit.tekachi.questionretrieval.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@Table(name = "questions")
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int q_id;

    @Column(name = "qsn")
    private String question;

    @Column(name = "q_correct_option")
    private int q_correct_option;
}
