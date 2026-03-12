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
    private Integer test_id;

    @Column(name = "user_id")
    private Integer user_id;

    @Column(name = "attempted_on")
    LocalDateTime attempted_on;

    @Column(name = "apt_attempt_id")
    private Integer apt_attempt;

    @Column(name = "tech_interview_id")
    private Integer tech_interview;

    @Column(name = "hr_interview_id")
    private Integer hr_interview;
}
