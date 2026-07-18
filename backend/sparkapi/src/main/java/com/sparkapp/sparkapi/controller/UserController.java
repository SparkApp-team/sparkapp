package com.sparkapp.sparkapi.controller;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.sparkapp.sparkapi.dto.UpdateUserRequest;
import com.sparkapp.sparkapi.dto.UserResponse;
import com.sparkapp.sparkapi.service.UserService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/me")
    public UserResponse getCurrentUser(@RequestHeader("X-USER-ID") String userIdHeader) {
        return userService.getCurrentUser(userIdHeader);
    }

    @PatchMapping("/me")
    public UserResponse updateCurrentUser(@RequestHeader("X-USER-ID") String userIdHeader,
            @Valid @RequestBody UpdateUserRequest updateUserRequest) {
        return userService.updateCurrentUser(userIdHeader, updateUserRequest);
    }

    @DeleteMapping("/me")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteCurrentUser(@RequestHeader("X-USER-ID") String userIdHeader) {
        userService.deleteCurrentUser(userIdHeader);
    }

}
