package com.geojit.tekachi.questionretrieval.entity;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@Table(name = "questions")
public class Question {

    @Id
    @Column(name = "q_id")
    private Integer qId;

    @Column(name = "qsn", length = 1000)
    private String qsn;

    @Column(name = "q_correct_option")
    private Integer qCorrectOption;

    @Column(name = "correct_op_id")
    private Integer correctOpId;

    @OneToMany(mappedBy = "question", fetch = FetchType.EAGER)
    @JsonManagedReference
    private List<Option> options;

}
