package com.axsos.project.dto;

import java.util.List;

public class AIChatResponse {

    private String reply;
    private List<AIProductRecommendation> recommendations;

    public AIChatResponse() {
    }

    public AIChatResponse(
            String reply,
            List<AIProductRecommendation> recommendations
    ) {
        this.reply = reply;
        this.recommendations = recommendations;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public List<AIProductRecommendation> getRecommendations() {
        return recommendations;
    }

    public void setRecommendations(
            List<AIProductRecommendation> recommendations
    ) {
        this.recommendations = recommendations;
    }
}