package com.sparkapp.sparkapi.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sparkapp.sparkapi.dto.CreateUserRequest;
import com.sparkapp.sparkapi.dto.UserResponse;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/users")
public class UserController {
    private static final AtomicLong id = new AtomicLong(1);

    @PostMapping()
    public UserResponse createUser(@RequestBody CreateUserRequest createUserRequest) {

        return new UserResponse(String.valueOf(id.getAndIncrement()), createUserRequest.email());
    }

}
