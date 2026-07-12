package com.sparkapp.sparkapi.controller;

import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.sparkapp.sparkapi.dto.CreateHabitRequest;
import com.sparkapp.sparkapi.dto.HabitResponse;
import com.sparkapp.sparkapi.dto.UpdateHabitRequest;
import com.sparkapp.sparkapi.service.HabitService;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;



@Validated
@RestController
@RequestMapping("/habits")
public class HabitController {

    private final HabitService habitService;

    public HabitController(HabitService habitService){
        this.habitService = habitService;

    }
    
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public HabitResponse createHabit(@RequestHeader("X-USER-ID") String userIdHeader,
                                    @Valid @RequestBody CreateHabitRequest createHabitRequest) {
        
        return habitService.createHabit(userIdHeader, createHabitRequest);
    }
    
    @GetMapping()
    public List<HabitResponse> getHabitList(@RequestHeader("X-USER-ID") String userIdHeader) {

        return habitService.getHabitList(userIdHeader);
    }

    @GetMapping("/{habitId}")
    public HabitResponse getHabitById(@RequestHeader("X-USER-ID") String userIdHeader,
                                        @PathVariable @Positive Long habitId) {
        return habitService.getHabitById(userIdHeader, habitId);
    }

    @PutMapping("/{habitId}")
    public HabitResponse updateHabit(@RequestHeader("X-USER-ID") String userIdHeader,
                                @PathVariable @Positive Long habitId, 
                                @Valid @RequestBody UpdateHabitRequest updateHabitRequest) {

        return habitService.updateHabit(userIdHeader, habitId, updateHabitRequest);
    }

    @DeleteMapping("/{habitId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteHabit(@RequestHeader("X-USER-ID") String userIdHeader,
                                @PathVariable @Positive Long habitId) {

        habitService.deleteHabit(userIdHeader, habitId);
    }


    
    
    
}
