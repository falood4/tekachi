package com.geojit.tekachi.usersignin.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;

import com.geojit.tekachi.usersignin.repository.UserRepository;
import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.service.UserService;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@CrossOrigin
public class UserController {

    private final UserRepository repository;
    private final UserService userService;

    public UserController(UserRepository repository, UserService userService) {
        this.repository = repository;
        this.userService = userService;
    }

    @PostMapping
    public User create(@RequestBody User user) {
        return userService.register(user);
    }

    @GetMapping
    public List<User> getAll() {
        return repository.findAll();
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> request) {

        String email = request.get("email");
        String password = request.get("password");

        User user = userService.login(email, password);

        return ResponseEntity.ok(
                Map.of(
                        "id", user.getId(),
                        "email", user.getEmail(),
                        "message", "Login successful"));
    }

}
