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
    private int test_id;

    @Column(name = "user_id")
    private int user_id;

    @Column(name = "attempted_on")
    LocalDateTime attempted_on;

    @Column(name = "apt_attempt_id")
    private int apt_attempt;

    @Column(name = "tech_interview_id")
    private int tech_interview;

    @Column(name = "hr_interview_id")
    private int hr_interview;
}
