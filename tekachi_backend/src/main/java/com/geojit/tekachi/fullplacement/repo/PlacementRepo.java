package com.geojit.tekachi.fullplacement.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.geojit.tekachi.fullplacement.entity.Placement;

@Repository
public interface PlacementRepo extends JpaRepository<Placement, Integer> {
    @Query(value = "SELECT * FROM placementfulltest WHERE user_id = :userId", nativeQuery = true)
    List<Placement> findByUserId(@Param("userId") int userId);

}
