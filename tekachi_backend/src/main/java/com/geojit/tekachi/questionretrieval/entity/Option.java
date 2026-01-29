package com.geojit.tekachi.questionretrieval.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "options")
public class Option {

    @Id
    @Column(name = "op_id")
    private Integer opId;

    @Column(name = "op")
    private String op;

    @ManyToOne
    @JoinColumn(name = "q_id")
    @JsonBackReference
    private Question question;

    // getters & setters
}
