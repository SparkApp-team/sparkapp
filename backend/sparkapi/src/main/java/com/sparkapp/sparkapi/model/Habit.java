package com.sparkapp.sparkapi.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Entity
public class Habit {

    @Id
    @GeneratedValue
    private Long id;

    private Long userId;

    private String name;

    private String frequency;
    protected Habit() {
    }
    public Habit(Long userId) {
        this.userId = userId;
    }

    public Long getId() {
        return id;
    }

    public Long getUserId(){
        return userId;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }
}
