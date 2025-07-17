package com.example.demo;

import java.util.Optional;

public interface UserService {
    String registerUser(UserEntity user);
    Optional<UserEntity> loginUser(String email, String password);
    boolean sendPasswordResetEmail(String email);
}
