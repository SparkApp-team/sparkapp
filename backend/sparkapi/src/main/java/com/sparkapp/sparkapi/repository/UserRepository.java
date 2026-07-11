package com.sparkapp.sparkapi.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sparkapp.sparkapi.model.User;
import java.util.Optional;


public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
}
