package com.geojit.tekachi.quizhistory.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.geojit.tekachi.questionretrieval.entity.Option;
import com.geojit.tekachi.questionretrieval.entity.Question;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "aptitude_answers")
@Getter
@Setter
public class Answer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "answer_id")
    private Long answerId;

    @JsonManagedReference
    @ManyToOne
    @JoinColumn(name = "attempt_id", nullable = false)
    private Attempt attempt;

    @ManyToOne
    @JoinColumn(name = "q_id", nullable = false)
    private Question question; // Renamed to 'question' for clarity

    @ManyToOne
    @JoinColumn(name = "selected_op_id")
    private Option selectedOption;

    
}
