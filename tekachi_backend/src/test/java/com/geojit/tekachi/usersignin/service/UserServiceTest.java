package com.geojit.tekachi.usersignin.service;

import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private UserService userService;

    @Test
    void registerRejectsDuplicateEmail() {
        User user = new User();
        user.setEmail("alice@example.com");
        when(userRepository.existsByEmail("alice@example.com")).thenReturn(true);

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> userService.register(user));

        assertEquals(HttpStatus.CONFLICT, ex.getStatusCode());
    }

    @Test
    void registerEncodesPasswordAndSavesUser() {
        User user = new User();
        user.setEmail("alice@example.com");
        user.setPassword("plain");

        when(userRepository.existsByEmail("alice@example.com")).thenReturn(false);
        when(passwordEncoder.encode("plain")).thenReturn("hashed");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

        User saved = userService.register(user);

        assertEquals("hashed", saved.getPassword());
        verify(userRepository).save(user);
    }

    @Test
    void loginRejectsInvalidCredentials() {
        User user = new User();
        user.setEmail("alice@example.com");
        user.setPassword("hashed");
        when(userRepository.findByEmail("alice@example.com")).thenReturn(user);
        when(passwordEncoder.matches("wrong", "hashed")).thenReturn(false);

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> userService.login("alice@example.com", "wrong"));

        assertEquals(HttpStatus.UNAUTHORIZED, ex.getStatusCode());
    }

    @Test
    void loginReturnsUserForValidCredentials() {
        User user = new User();
        user.setEmail("alice@example.com");
        user.setPassword("hashed");
        when(userRepository.findByEmail("alice@example.com")).thenReturn(user);
        when(passwordEncoder.matches("secret", "hashed")).thenReturn(true);

        User actual = userService.login("alice@example.com", "secret");

        assertSame(user, actual);
    }

    @Test
    void changePasswordRejectsIncorrectOldPassword() {
        User user = new User();
        user.setId(1L);
        user.setPassword("hashed-old");
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("wrong", "hashed-old")).thenReturn(false);

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> userService.changePassword(1L, "wrong", "new-pass"));

        assertEquals(HttpStatus.UNAUTHORIZED, ex.getStatusCode());
    }

    @Test
    void changePasswordRejectsBlankNewPassword() {
        User user = new User();
        user.setId(1L);
        user.setPassword("hashed-old");
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("old", "hashed-old")).thenReturn(true);

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> userService.changePassword(1L, "old", ""));

        assertEquals(HttpStatus.BAD_REQUEST, ex.getStatusCode());
    }

    @Test
    void changePasswordSavesEncodedPassword() {
        User user = new User();
        user.setId(1L);
        user.setPassword("hashed-old");
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("old", "hashed-old")).thenReturn(true);
        when(passwordEncoder.encode("new-pass")).thenReturn("hashed-new");
        when(userRepository.save(user)).thenReturn(user);

        User updated = userService.changePassword(1L, "old", "new-pass");

        assertEquals("hashed-new", updated.getPassword());
        verify(userRepository).save(user);
    }
}
