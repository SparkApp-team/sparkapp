package com.sparkapp.sparkapi.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.sparkapp.sparkapi.dto.CreateHabitRequest;
import com.sparkapp.sparkapi.dto.HabitResponse;
import com.sparkapp.sparkapi.model.Habit;
import com.sparkapp.sparkapi.repository.HabitRepository;


@Service
public class HabitService {
    private final HabitRepository habitRepository;
    private final FakeAuthService fakeAuthService;

    public HabitService(HabitRepository habitRepository, FakeAuthService fakeAuthService){
        this.habitRepository = habitRepository;
        this.fakeAuthService = fakeAuthService;

    }

    public HabitResponse createHabit(String userIdHeader, CreateHabitRequest request) {
        
        Habit newHabit = new Habit(fakeAuthService.getCurrentUserId(userIdHeader));

        newHabit.setName(request.name());
        newHabit.setFrequency(request.frequency());
        habitRepository.save(newHabit);
        return new HabitResponse(newHabit.getId(), newHabit.getUserId(), newHabit.getName(), newHabit.getFrequency());
    }

    public List<HabitResponse> getHabitList(String userIdHeader) {

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
