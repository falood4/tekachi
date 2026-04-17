package com.geojit.tekachi.fullplacement.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.geojit.tekachi.fullplacement.dtos.PlacementAttemptDetails;
import com.geojit.tekachi.fullplacement.entity.Placement;

@Repository
public interface PlacementRepo extends JpaRepository<Placement, Integer> {
    @Query(value = "select pt.test_id as testId, \r\n" + //
            "       pt.user_id as userId, \r\n" + //
            "       pt.attempted_on as attemptedOn, \r\n" + //
            "       aa.attempt_id as attemptId, \r\n" + //
            "       aa.score as score, \r\n" + //
            "       c1.conversation_id as techConversationId, \r\n" + //
            "       c1.verdict as techVerdict, \r\n" + //
            "       c2.conversation_id as hrConversationId, \r\n" + //
            "       c2.verdict as hrVerdict \r\n" + //
            "from placementfulltest as pt\r\n" + //
            "left join aptitude_attempts as aa on aa.attempt_id = pt.apt_attempt_id\r\n" + //
            "left join conversations as c1 on c1.conversation_id = pt.tech_interview_id\r\n" + //
            "left join conversations as c2 on c2.conversation_id = pt.hr_interview_id\r\n" + //
            "where pt.user_id = :userId", nativeQuery = true)
    List<PlacementAttemptDetails> findByUserId(int userId);

    long deleteByUserId(int userId);
}
