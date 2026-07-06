package com.sparkapp.sparkapi.controller;

import com.sparkapp.sparkapi.repository.UserRepository;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sparkapp.sparkapi.dto.CreateHabitRequest;
import com.sparkapp.sparkapi.dto.CreateUserRequest;
import com.sparkapp.sparkapi.dto.HabitResponse;
import com.sparkapp.sparkapi.model.Habit;
import com.sparkapp.sparkapi.repository.HabitRepository;
import com.sparkapp.sparkapi.service.FakeAuthService;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;



@RestController
@RequestMapping("/habits")
public class HabitController {

    private final HabitRepository habitRepository;
    private final FakeAuthService fakeAuthService;

    public HabitController(HabitRepository habitRepository, FakeAuthService fakeAuthService){
        this.habitRepository = habitRepository;
        this.fakeAuthService = fakeAuthService;

    }
    
    @PostMapping
    public HabitResponse createHabit(@RequestHeader("X-USER-ID") String userIdHeader,
                                    @RequestBody CreateHabitRequest createHabitRequest) {
        
        Habit newHabit = new Habit(fakeAuthService.getCurrentUserId(userIdHeader));

        newHabit.setName(createHabitRequest.name());
        newHabit.setFrequency(createHabitRequest.frequency());
        habitRepository.save(newHabit);
        return new HabitResponse(newHabit.getId(), newHabit.getUserId(), newHabit.getName(), newHabit.getFrequency());
    }
    
    @GetMapping()
    public List<HabitResponse> getHabitList(@RequestHeader("X-USER-ID") String userIdHeader) {

        Long currentUserId = fakeAuthService.getCurrentUserId(userIdHeader);

        return habitRepository.findByUserId(currentUserId)
                .stream()
                .map(habit -> new HabitResponse(                    
                    habit.getId(),
                    habit.getUserId(),
                    habit.getName(),
                    habit.getFrequency()))
                    .toList();
    }


    
    
    
}
