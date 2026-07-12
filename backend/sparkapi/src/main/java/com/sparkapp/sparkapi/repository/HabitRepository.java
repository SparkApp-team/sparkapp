package com.sparkapp.sparkapi.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sparkapp.sparkapi.model.Habit;

public interface HabitRepository extends JpaRepository<Habit, Long>{
    List<Habit> findByUserId(Long userId);
    Optional<Habit> findByIdAndUserId(Long id, Long userId);
}
