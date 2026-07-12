package com.sparkapp.sparkapi.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.sparkapp.sparkapi.dto.CreateHabitRequest;
import com.sparkapp.sparkapi.model.Habit;
import com.sparkapp.sparkapi.repository.HabitRepository;

@ExtendWith(MockitoExtension.class)
class HabitServiceTest {

    @Mock
    private HabitRepository habitRepository;

    @Mock
    private FakeAuthService fakeAuthService;

    private HabitService habitService;

    @BeforeEach
    void setUp() {
        habitService = new HabitService(habitRepository, fakeAuthService);
    }

    @Test
    void createHabitSavesHabitForCurrentUserAndReturnsResponse() {
        var request = new CreateHabitRequest("Read", "daily");
        when(fakeAuthService.getCurrentUserId("7")).thenReturn(7L);

        when(habitRepository.save(org.mockito.ArgumentMatchers.any(Habit.class)))
            .thenAnswer(invocation -> {
                Habit habit = invocation.getArgument(0);
                habit.setId(10L);
                return habit;
            });

        var response = habitService.createHabit("7", request);

        assertEquals(10L, response.id());
        assertEquals(7L, response.userId());
        assertEquals("Read", response.name());
        assertEquals("daily", response.frequency());

        var captor = ArgumentCaptor.forClass(Habit.class);
        verify(habitRepository).save(captor.capture());
        assertEquals(7L, captor.getValue().getUserId());
        assertEquals("Read", captor.getValue().getName());
        assertEquals("daily", captor.getValue().getFrequency());
    }

    @Test
    void getHabitListReturnsOnlyCurrentUsersMappedHabits() {
        when(fakeAuthService.getCurrentUserId("7")).thenReturn(7L);

        Habit first = new Habit(7L);
        first.setId(1L);
        first.setName("Read");
        first.setFrequency("daily");

        Habit second = new Habit(7L);
        second.setId(2L);
        second.setName("Exercise");
        second.setFrequency("weekly");

        when(habitRepository.findByUserId(7L)).thenReturn(List.of(first, second));

        var response = habitService.getHabitList("7");

        assertEquals(2, response.size());
        assertEquals("Read", response.get(0).name());
        assertEquals("Exercise", response.get(1).name());
        verify(habitRepository).findByUserId(7L);
    }

    @Test
    void getHabitListReturnsEmptyListWhenCurrentUserHasNoHabits() {
        when(fakeAuthService.getCurrentUserId("7")).thenReturn(7L);
        when(habitRepository.findByUserId(7L)).thenReturn(List.of());

        assertEquals(List.of(), habitService.getHabitList("7"));
    }
}