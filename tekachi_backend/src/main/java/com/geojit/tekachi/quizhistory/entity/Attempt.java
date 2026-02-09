package com.geojit.tekachi.quizhistory.entity;

import java.time.LocalDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.geojit.tekachi.usersignin.entity.User;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Formula;

@Entity
@Table(name = "aptitude_attempts")
@Getter
@Setter
public class Attempt {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "attempt_id")
    private Long attemptId;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false) // FIX: was "id"
    private User user;

    @Column(name = "attempted_on", nullable = false)
    private LocalDateTime attemptedOn;

    @Column(name = "total_questions", nullable = false)
    private int totalQuestions;

    @Column(name = "correct_answers", nullable = false)
    private int correctAnswers;

    @Formula("score")
    private String score;

    @JsonManagedReference
    @OneToMany(mappedBy = "attempt", cascade = CascadeType.ALL)
    private List<Answer> answers;
}
