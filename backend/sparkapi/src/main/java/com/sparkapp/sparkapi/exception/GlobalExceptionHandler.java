package com.sparkapp.sparkapi.exception;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;


import jakarta.servlet.http.HttpServletRequest;

@RestControllerAdvice
public class GlobalExceptionHandler {



    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorResponse> handleValidationErrors(
        MethodArgumentNotValidException exception,
        HttpServletRequest request
    ) {
        Map<String, String> fieldErrors = new LinkedHashMap<>();
        
        exception.getBindingResult()
            .getFieldErrors()
            .forEach(fieldError ->
                fieldErrors.putIfAbsent(
                    fieldError.getField(),
                    fieldError.getDefaultMessage()    
                )
            );
        
        HttpStatus status = HttpStatus.BAD_REQUEST;
        
        ApiErrorResponse response = new ApiErrorResponse(
            Instant.now(),
            status.value(),
            status.getReasonPhrase(),
            "Validation failed",
            request.getRequestURI(),
            fieldErrors
        );
        
        return ResponseEntity
            .status(status)
            .body(response);
    }

    @ExceptionHandler(InvalidCredentialsException.class)
    public ResponseEntity<ApiErrorResponse> handleInvalidCredentialsException(
        InvalidCredentialsException exception,
        HttpServletRequest request
    ) {
        HttpStatus status = HttpStatus.UNAUTHORIZED;

        ApiErrorResponse response = new ApiErrorResponse(
            Instant.now(),
            status.value(),
            status.getReasonPhrase(),
            exception.getMessage(),
            request.getRequestURI(),
            Map.of()
        );
        
        return ResponseEntity
            .status(status)
            .body(response);
    }

    @ExceptionHandler(EmailAlreadyRegisteredException.class)
    public ResponseEntity<ApiErrorResponse> handleEmailAlreadyRegisteredException(
        EmailAlreadyRegisteredException exception,
        HttpServletRequest request
    ) {
        HttpStatus status = HttpStatus.CONFLICT;

        ApiErrorResponse response = new ApiErrorResponse(
            Instant.now(),
            status.value(),
            status.getReasonPhrase(),
            exception.getMessage(),
            request.getRequestURI(),
            Map.of(
                "email",
                exception.getMessage()
            )
        );
        
        return ResponseEntity
            .status(status)
            .body(response);
    }

    @ExceptionHandler(PasswordDoNotMatchException.class)
    public ResponseEntity<ApiErrorResponse> handlePasswordDoNotMatchException(
        PasswordDoNotMatchException exception,
        HttpServletRequest request
    ) {
        HttpStatus status = HttpStatus.BAD_REQUEST;

        ApiErrorResponse response = new ApiErrorResponse(
            Instant.now(),
            status.value(),
            status.getReasonPhrase(),
            exception.getMessage(),
            request.getRequestURI(),
            Map.of(
                "passwordConfirmation",
                exception.getMessage()
            )
        );
        
        return ResponseEntity
            .status(status)
            .body(response);
    }

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleUserNotFoundException(
        UserNotFoundException exception,
        HttpServletRequest request
    ) {
        HttpStatus status = HttpStatus.NOT_FOUND;

        ApiErrorResponse response = new ApiErrorResponse(
            Instant.now(),
            status.value(),
            status.getReasonPhrase(),
            exception.getMessage(),
            request.getRequestURI(),
            Map.of()
        );
        
        return ResponseEntity
            .status(status)
            .body(response);
    }
    @ExceptionHandler(HabitNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleHabitNotFoundException(
        HabitNotFoundException exception,
        HttpServletRequest request
    ) {
        HttpStatus status = HttpStatus.NOT_FOUND;

        ApiErrorResponse response = new ApiErrorResponse(
            Instant.now(),
            status.value(),
            status.getReasonPhrase(),
            exception.getMessage(),
            request.getRequestURI(),
            Map.of()
        );
        
        return ResponseEntity
            .status(status)
            .body(response);
    }

}
