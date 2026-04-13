package com.geojit.tekachi.fullplacement.dtos;

import java.time.LocalDateTime;

public interface PlacementAttemptView {
    Integer getPlacementTestId();

    LocalDateTime getAttemptedOn();

}