package com.unireserve.repository;
import com.unireserve.model.Space;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface SpaceRepository extends JpaRepository<Space,Long> {
    List<Space> findByActiveTrueOrderByNameAsc();
}
