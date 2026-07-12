package com.sparkapp.sparkapi.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.sparkapp.sparkapi.dto.CreateHabitRequest;
import com.sparkapp.sparkapi.dto.UpdateHabitRequest;
import com.sparkapp.sparkapi.exception.HabitNotFoundException;
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

    @Test
    void getHabitByIdReturnsHabitOwnedByCurrentUser() {
        Habit habit = habit(1L, 7L, "Read", "daily");
        when(fakeAuthService.getCurrentUserId("7")).thenReturn(7L);
        when(habitRepository.findByIdAndUserId(1L, 7L)).thenReturn(Optional.of(habit));

        var response = habitService.getHabitById("7", 1L);

        assertEquals(1L, response.id());
        assertEquals(7L, response.userId());
        assertEquals("Read", response.name());
        assertEquals("daily", response.frequency());
        verify(habitRepository).findByIdAndUserId(1L, 7L);
    }

    @Test
    void getHabitByIdThrowsWhenHabitDoesNotExist() {
        when(fakeAuthService.getCurrentUserId("7")).thenReturn(7L);
        when(habitRepository.findByIdAndUserId(99L, 7L)).thenReturn(Optional.empty());

        assertThrows(
            HabitNotFoundException.class,
            () -> habitService.getHabitById("7", 99L)
        );
    }

    @Test
    void getHabitByIdThrowsWhenHabitBelongsToAnotherUser() {
        when(fakeAuthService.getCurrentUserId("8")).thenReturn(8L);
        when(habitRepository.findByIdAndUserId(1L, 8L)).thenReturn(Optional.empty());

        assertThrows(
            HabitNotFoundException.class,
            () -> habitService.getHabitById("8", 1L)
        );

        verify(habitRepository).findByIdAndUserId(1L, 8L);
    }

    @Test
    void updateHabitUpdatesOwnedHabitAndReturnsResponse() {
        Habit habit = habit(1L, 7L, "Read", "daily");
        var request = new UpdateHabitRequest("Exercise", "weekly");
        when(fakeAuthService.getCurrentUserId("7")).thenReturn(7L);
        when(habitRepository.findByIdAndUserId(1L, 7L)).thenReturn(Optional.of(habit));
        when(habitRepository.save(habit)).thenReturn(habit);

        var response = habitService.updateHabit("7", 1L, request);

        assertEquals("Exercise", response.name());
        assertEquals("weekly", response.frequency());
        verify(habitRepository).save(habit);
    }

    @Test
    void updateHabitThrowsWhenHabitIsUnavailableToCurrentUser() {
        var request = new UpdateHabitRequest("Exercise", "weekly");
        when(fakeAuthService.getCurrentUserId("8")).thenReturn(8L);
        when(habitRepository.findByIdAndUserId(1L, 8L)).thenReturn(Optional.empty());

        assertThrows(
            HabitNotFoundException.class,
            () -> habitService.updateHabit("8", 1L, request)
        );

        verify(habitRepository, never()).save(org.mockito.ArgumentMatchers.any());
    }

    @Test
    void deleteHabitDeletesOwnedHabit() {
        Habit habit = habit(1L, 7L, "Read", "daily");
        when(fakeAuthService.getCurrentUserId("7")).thenReturn(7L);
        when(habitRepository.findByIdAndUserId(1L, 7L)).thenReturn(Optional.of(habit));

        habitService.deleteHabit("7", 1L);

        verify(habitRepository).delete(habit);
    }

    @Test
    void deleteHabitThrowsWhenHabitIsUnavailableToCurrentUser() {
        when(fakeAuthService.getCurrentUserId("8")).thenReturn(8L);
        when(habitRepository.findByIdAndUserId(1L, 8L)).thenReturn(Optional.empty());

        assertThrows(
            HabitNotFoundException.class,
            () -> habitService.deleteHabit("8", 1L)
        );

        verify(habitRepository, never()).delete(org.mockito.ArgumentMatchers.any());
    }

    private Habit habit(Long id, Long userId, String name, String frequency) {
        Habit habit = new Habit(userId);
        habit.setId(id);
        habit.setName(name);
        habit.setFrequency(frequency);
        return habit;
    }
}
