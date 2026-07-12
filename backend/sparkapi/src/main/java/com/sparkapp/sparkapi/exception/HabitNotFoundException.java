package com.sparkapp.sparkapi.exception;

public class HabitNotFoundException extends RuntimeException{

    public HabitNotFoundException() {
        super("Habit not found");
    }

}
