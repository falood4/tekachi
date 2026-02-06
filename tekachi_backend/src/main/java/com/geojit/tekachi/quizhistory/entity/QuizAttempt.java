package com.geojit.tekachi.quizhistory.entity;

import java.time.LocalDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.geojit.tekachi.usersignin.entity.User;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "aptitude_attempts")
@Getter
@Setter
public class QuizAttempt {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "attempt_id")
    private Long attemptId;

    @ManyToOne
    @JoinColumn(name = "id", nullable = false)
    private User user;

    @Column(name = "attempted_on", nullable = false)
    private LocalDateTime attemptedOn;

    @Column(name = "total_questions", nullable = false)
    private int totalQuestions;

    @Column(name = "correct_answers", nullable = false)
    private int correctAnswers;

    @Column(name = "score")
    private int score;

    @JsonManagedReference
    @OneToMany(mappedBy = "attempt", cascade = CascadeType.ALL)
    private List<AttemptedAnswer> answers;
}
