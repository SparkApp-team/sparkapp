package com.sparkapp.sparkapi.controller;

import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sparkapp.sparkapi.dto.CreateHabitRequest;
import com.sparkapp.sparkapi.dto.HabitResponse;
import com.sparkapp.sparkapi.service.HabitService;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;



@RestController
@RequestMapping("/habits")
public class HabitController {

    private final HabitService habitService;

    public HabitController(HabitService habitService){
        this.habitService = habitService;

    }
    
    @PostMapping
    public HabitResponse createHabit(@RequestHeader("X-USER-ID") String userIdHeader,
                                    @RequestBody CreateHabitRequest createHabitRequest) {
        
        return habitService.createHabit(userIdHeader, createHabitRequest);
    }
    
    @GetMapping()
    public List<HabitResponse> getHabitList(@RequestHeader("X-USER-ID") String userIdHeader) {

        return habitService.getHabitList(userIdHeader);
    }


    
    
    
}
