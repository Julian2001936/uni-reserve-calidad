package com.unireserve.dto;
import com.unireserve.model.Role;
import jakarta.validation.constraints.*;
public record RegisterRequest(
    @NotBlank String fullName,
    @Email @NotBlank String email,
    @Size(min=6) String password,
    @NotNull Role role
) {}
