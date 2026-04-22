package com.geojit.tekachi.fullplacement.controlller;

import com.geojit.tekachi.fullplacement.dtos.PlacementAttemptDetails;
import com.geojit.tekachi.fullplacement.entity.Placement;
import com.geojit.tekachi.fullplacement.service.PlacementService;
import com.geojit.tekachi.quizhistory.services.AnswerService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PlacementControllerTest {

    @Mock
    private PlacementService placementService;

    @Mock
    private AnswerService answerService;

    @Test
    void saveAttemptStoresThreeStepAttempt() {
        PlacementController controller = new PlacementController(placementService, answerService);

        Placement saved = new Placement();
        saved.setTestId(11);
        when(placementService.savePlacement(org.mockito.ArgumentMatchers.any(Placement.class))).thenReturn(saved);

        Map<String, Object> response = controller.saveAttempt(Map.of(
                "userId", 1,
                "aptAttemptId", 22,
                "techInterviewId", 33,
                "hrInterviewId", 44));

        ArgumentCaptor<Placement> captor = ArgumentCaptor.forClass(Placement.class);
        verify(placementService).savePlacement(captor.capture());
        Placement sent = captor.getValue();

        assertEquals(1, sent.getUserId());
        assertEquals(22, sent.getAptAttemptId());
        assertEquals(33, sent.getTechInterviewId());
        assertEquals(44, sent.getHrInterviewId());
        assertNotNull(sent.getAttemptedOn());

        assertEquals("3step attempt saved", response.get("message"));
        assertSame(saved, response.get("placement"));
    }

    @Test
    void getAttemptsReturnsReverseChronologicalOrder() {
        PlacementController controller = new PlacementController(placementService, answerService);

        PlacementAttemptDetails older = org.mockito.Mockito.mock(PlacementAttemptDetails.class);
        PlacementAttemptDetails newer = org.mockito.Mockito.mock(PlacementAttemptDetails.class);
        when(placementService.getPlacementsByUserId(5)).thenReturn(List.of(older, newer));

        List<PlacementAttemptDetails> response = controller.getAttempts(5);

        assertEquals(2, response.size());
        assertSame(newer, response.get(0));
        assertSame(older, response.get(1));
    }

    @Test
    void deleteAttemptsDelegatesToService() {
        PlacementController controller = new PlacementController(placementService, answerService);

        Map<String, String> response = controller.deleteAttempts(7);

        verify(placementService).deletePlacementsByUserId(7);
        assertEquals("All attempts deleted for user id: 7", response.get("message"));
    }
}
