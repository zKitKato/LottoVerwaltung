package net.kato.lottospringboot.backend.config;

import net.kato.lottospringboot.backend.dao.UserRepository;
import net.kato.lottospringboot.backend.model.User;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner initUsers(UserRepository userRepository,
                                PasswordEncoder passwordEncoder) {
        return args -> {

            if (userRepository.findByUsername("test").isEmpty()) {

                User user = new User(
                        "test",
                        passwordEncoder.encode("1234")
                );

                userRepository.save(user);

                System.out.println("Testuser erstellt:");
                System.out.println("Username: test");
                System.out.println("Password: 1234");
            }
        };
    }
}