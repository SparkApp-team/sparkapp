package com.sparkapp.sparkapi.exception;

public class InvalidCredentialsException extends RuntimeException{
    public InvalidCredentialsException() {
        super("Invalid email or password");
    }
}
