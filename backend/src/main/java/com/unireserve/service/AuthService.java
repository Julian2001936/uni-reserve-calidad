package com.unireserve.service;

import com.unireserve.dto.*;
import com.unireserve.model.User;
import com.unireserve.repository.UserRepository;
import com.unireserve.security.JwtService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    private final UserRepository users;
    private final PasswordEncoder encoder;
    private final JwtService jwt;

    public AuthService(UserRepository users, PasswordEncoder encoder, JwtService jwt){
        this.users=users; this.encoder=encoder; this.jwt=jwt;
    }

    public AuthResponse register(RegisterRequest r){
        if(users.existsByEmail(r.email().toLowerCase()))
            throw new IllegalArgumentException("El correo ya está registrado.");
        User u=new User(r.email().toLowerCase(), encoder.encode(r.password()), r.fullName(), r.role());
        users.save(u);
        return response(u);
    }

    public AuthResponse login(LoginRequest r){
        User u=users.findByEmail(r.email().toLowerCase())
                .orElseThrow(()->new IllegalArgumentException("Correo o contraseña incorrectos."));
        if(!encoder.matches(r.password(),u.getPassword()))
            throw new IllegalArgumentException("Correo o contraseña incorrectos.");
        return response(u);
    }

    private AuthResponse response(User u){
        return new AuthResponse(jwt.generate(u.getId(),u.getEmail(),u.getRole().name()),
                u.getId(),u.getFullName(),u.getEmail(),u.getRole().name());
    }
}
