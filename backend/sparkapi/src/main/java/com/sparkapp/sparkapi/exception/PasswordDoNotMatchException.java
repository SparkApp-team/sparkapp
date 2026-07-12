package com.sparkapp.sparkapi.exception;

public class PasswordDoNotMatchException extends RuntimeException{
    public PasswordDoNotMatchException() {
        super("Passwords do not match");
    }
}
