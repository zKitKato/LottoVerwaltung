package net.kato.lottospringboot.backend.dao;

import net.kato.lottospringboot.backend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // Findet User nach Username (exakt)
    Optional<User> findByUsername(String username);

    // Optional: weitere Queries
    // boolean existsByUsername(String username);
}
