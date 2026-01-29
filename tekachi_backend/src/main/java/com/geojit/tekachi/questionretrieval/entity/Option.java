package com.geojit.tekachi.questionretrieval.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "options")
public class Option {

    @Id
    private int op_id;
    private String op;
    private int q_id;
}
