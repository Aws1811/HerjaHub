package com.axsos.project.services;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientResponseException;

import com.fasterxml.jackson.databind.JsonNode;

@Service
public class GeminiService {

    private final RestClient restClient;
    private final String apiUrl;

    public GeminiService(
            @Value("${gemini.api.url}") String apiUrl,
            @Value("${gemini.api.key}") String apiKey
    ) {
        this.apiUrl = apiUrl;

        // Add the Gemini API key to every request.
        this.restClient = RestClient.builder()
                .defaultHeader("x-goog-api-key", apiKey)
                .build();
    }

    public String generateReply(String prompt) {

        // Create the JSON body required by Gemini.
        Map<String, Object> requestBody = Map.of(
                "contents",
                List.of(
                        Map.of(
                                "parts",
                                List.of(
                                        Map.of("text", prompt)
                                )
                        )
                )
        );

        try {

            // Send the prompt to Gemini.
            JsonNode response = restClient.post()
                    .uri(apiUrl)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(requestBody)
                    .retrieve()
                    .body(JsonNode.class);

            if (response == null) {
                return fallbackReply();
            }

            // Read Gemini's generated text.
            JsonNode textNode = response
                    .path("candidates")
                    .path(0)
                    .path("content")
                    .path("parts")
                    .path(0)
                    .path("text");

            if (textNode.isMissingNode()
                    || textNode.asText().isBlank()) {
                return fallbackReply();
            }

            return textNode.asText().trim();

        } catch (RestClientResponseException exception) {

            // Keep the website working if Gemini rejects the request.
            System.err.println(
                    "Gemini API error: "
                            + exception.getStatusCode()
            );

            return fallbackReply();

        } catch (Exception exception) {

            // Keep the website working if Gemini is unavailable.
            System.err.println(
                    "Gemini connection error: "
                            + exception.getMessage()
            );

            return fallbackReply();
        }
    }

    private String fallbackReply() {
        return "I found some available HerjaHub products for you.";
    }
}