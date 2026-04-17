package com.geojit.tekachi.fullplacement.entity;

import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "placementfulltest")
public class Placement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "test_id")
    private Integer testId;

    @Column(name = "user_id", nullable = false)
    private Integer userId;

    @Column(name = "attempted_on")
    private LocalDateTime attemptedOn;

    @Column(name = "apt_attempt_id")
    private Integer aptAttemptId;

    @Column(name = "tech_interview_id")
    private Integer techInterviewId;

    @Column(name = "hr_interview_id")
    private Integer hrInterviewId;
}
