package com.unireserve.config;

import com.unireserve.model.*;
import com.unireserve.repository.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataInitializer {
    @Bean
    CommandLineRunner seed(UserRepository users, SpaceRepository spaces, PasswordEncoder encoder){
        return args -> {
            if(!users.existsByEmail("estudiante@unireserve.com"))
                users.save(new User("estudiante@unireserve.com",encoder.encode("123456"),
                        "Usuario Estudiante",Role.STUDENT));
            if(!users.existsByEmail("docente@unireserve.com"))
                users.save(new User("docente@unireserve.com",encoder.encode("123456"),
                        "Usuario Docente",Role.TEACHER));
            if(spaces.count()==0){
                spaces.save(new Space("Aula 101","Aula",30,"Aula para clases, tutorías y actividades académicas."));
                spaces.save(new Space("Laboratorio de Sistemas","Laboratorio",25,"Laboratorio para prácticas de programación y sistemas."));
                spaces.save(new Space("Sala de Estudio A","Sala de estudio",12,"Sala para trabajos grupales y sesiones de estudio."));
                spaces.save(new Space("Aula 203","Aula",40,"Aula amplia para clases y reuniones académicas."));
                spaces.save(new Space("Laboratorio de Redes","Laboratorio",20,"Espacio destinado a prácticas de redes y telecomunicaciones."));
            }
        };
    }
}
