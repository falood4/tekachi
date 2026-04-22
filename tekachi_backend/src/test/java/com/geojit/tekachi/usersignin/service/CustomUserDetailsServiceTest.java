package com.geojit.tekachi.usersignin.service;

import com.geojit.tekachi.usersignin.entity.User;
import com.geojit.tekachi.usersignin.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CustomUserDetailsServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private CustomUserDetailsService customUserDetailsService;

    @Test
    void loadUserByUsernameReturnsSpringSecurityUser() {
        User user = new User();
        user.setEmail("alice@example.com");
        user.setPassword("hashed");
        when(userRepository.findByEmail("alice@example.com")).thenReturn(user);

        UserDetails details = customUserDetailsService.loadUserByUsername("alice@example.com");

        assertEquals("alice@example.com", details.getUsername());
        assertEquals("hashed", details.getPassword());
        assertEquals(1, details.getAuthorities().size());
    }

    @Test
    void loadUserByUsernameThrowsWhenUserNotFound() {
        when(userRepository.findByEmail("missing@example.com")).thenReturn(null);

        assertThrows(UsernameNotFoundException.class,
                () -> customUserDetailsService.loadUserByUsername("missing@example.com"));
    }
}
