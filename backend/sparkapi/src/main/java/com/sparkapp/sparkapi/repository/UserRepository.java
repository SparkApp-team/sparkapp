package com.sparkapp.sparkapi.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sparkapp.sparkapi.model.User;

public interface UserRepository extends JpaRepository<User, Long> {

}
