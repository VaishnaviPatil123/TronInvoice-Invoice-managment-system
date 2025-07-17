package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;


@Service
public class UserImpl implements UserService {

    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private JavaMailSender mailSender;

    @Override
    public String registerUser(UserEntity user) {
        // Check if user with the same email already exists
        Optional<UserEntity> existingUser = userRepository.findByEmail(user.getEmail());
        if (existingUser.isPresent()) {
            return "Email is already registered.";
        }

        // Directly save the user (without password encoding)
        userRepository.save(user);

        return "User registered successfully!";
    }

    @Override
    public Optional<UserEntity> loginUser(String email, String password) {
        // Find the user by email
        Optional<UserEntity> user = userRepository.findByEmail(email);

        // If the user exists, compare the password
        if (user.isPresent() && user.get().getPassword().equals(password)) {
            return user;
        }

        // If user doesn't exist or password doesn't match
        return Optional.empty();
    }
    
    
    @Override
    public boolean sendPasswordResetEmail(String email) {
        // Check if the user exists in the system
        Optional<UserEntity> user = userRepository.findByEmail(email);

        if (user.isPresent()) {
            // Generate a password reset token
            String resetToken = UUID.randomUUID().toString();

            // Save the reset token in the user's record (assuming your UserEntity has a resetToken field)
            UserEntity userEntity = user.get();
            userEntity.setResetToken(resetToken);
            userRepository.save(userEntity);

            // Send the password reset email
            String resetLink = "http://localhost:8080/reset-password?token=" + resetToken;
            sendEmail(userEntity.getEmail(), "Password Reset Request", "Click the following link to reset your password: " + resetLink);

            return true;
        }
        return false;  // User not found
    }

    private void sendEmail(String to, String subject, String message) {
        SimpleMailMessage email = new SimpleMailMessage();
        email.setTo(to);
        email.setSubject(subject);
        email.setText(message);

        // Send email
        mailSender.send(email);
    }
}
