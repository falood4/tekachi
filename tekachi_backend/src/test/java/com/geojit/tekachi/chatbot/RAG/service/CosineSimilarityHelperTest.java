package com.geojit.tekachi.chatbot.RAG.service;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CosineSimilarityHelperTest {

    @Test
    void cosineSimilarityIsOneForIdenticalVectors() {
        double similarity = CosineSimilarityHelper.cosineSimilarity(
                List.of(1.0, 2.0, 3.0),
                List.of(1.0, 2.0, 3.0));

        assertEquals(1.0, similarity, 1e-9);
    }

    @Test
    void cosineSimilarityIsZeroForOrthogonalVectors() {
        double similarity = CosineSimilarityHelper.cosineSimilarity(
                List.of(1.0, 0.0),
                List.of(0.0, 2.0));

        assertEquals(0.0, similarity, 1e-9);
    }
}
