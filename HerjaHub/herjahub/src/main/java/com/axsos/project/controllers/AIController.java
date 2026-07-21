package com.axsos.project.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.axsos.project.dto.AIChatResponse;
import com.axsos.project.dto.AiChatRequest;
import com.axsos.project.models.Customer;
import com.axsos.project.services.AIRecommendationService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AIController {

    @Autowired
    private AIRecommendationService aiRecommendationService;

    // Opens the AI chat JSP page.
    @GetMapping("/customer/ai")
    public String showAIPage(HttpSession session, Model model) {

        Customer customer =
                (Customer) session.getAttribute("loggedInCustomer");

        if (customer == null) {
            return "redirect:/auth";
        }

        model.addAttribute("customer", customer);

        return "customer/ai";
    }

    // Receives the customer's chat message from JavaScript.
    @PostMapping("/api/ai/chat")
    @ResponseBody
    public ResponseEntity<AIChatResponse> chat(
            @RequestBody AiChatRequest request,
            HttpSession session
    ) {

        Customer customer =
                (Customer) session.getAttribute("loggedInCustomer");

        if (customer == null) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .build();
        }

        if (request.getMessage() == null
                || request.getMessage().isBlank()) {

            AIChatResponse response = new AIChatResponse(
                    "Please enter a message.",
                    java.util.Collections.emptyList()
            );

            return ResponseEntity.badRequest().body(response);
        }

        AIChatResponse response =
                aiRecommendationService.getRecommendations(
                        request.getMessage()
                );

        return ResponseEntity.ok(response);
    }
}