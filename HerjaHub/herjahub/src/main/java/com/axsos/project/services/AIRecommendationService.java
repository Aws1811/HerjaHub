package com.axsos.project.services;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.dto.AIChatResponse;
import com.axsos.project.dto.AIProductRecommendation;
import com.axsos.project.models.Product;
import com.axsos.project.repositores.ProductRepository;

@Service
public class AIRecommendationService {

    @Autowired
    private ProductRepository productRepository;

    public AIChatResponse getRecommendations(String message) {

        // Get only products that are available.
        List<Product> availableProducts =
                productRepository.findByQuantityGreaterThan(0);

        if (availableProducts.isEmpty()) {
            return new AIChatResponse(
                    "Sorry, there are no available products right now.",
                    new ArrayList<>()
            );
        }

        Double budget = extractBudget(message);

        List<Product> matchingProducts = new ArrayList<>();

        for (Product product : availableProducts) {

            boolean isWithinBudget =
                    budget == null || product.getPrice() <= budget;

            boolean matchesMessage =
                    productMatchesMessage(product, message);

            if (isWithinBudget && matchesMessage) {
                matchingProducts.add(product);
            }
        }

        // If no keyword matched, recommend products based on budget.
        if (matchingProducts.isEmpty()) {
            for (Product product : availableProducts) {

                if (budget == null || product.getPrice() <= budget) {
                    matchingProducts.add(product);
                }
            }
        }

        // Show cheaper products first.
        matchingProducts.sort(
                Comparator.comparing(Product::getPrice)
        );

        List<AIProductRecommendation> recommendations =
                new ArrayList<>();

        // Return a maximum of four product cards.
        int numberOfProducts = Math.min(4, matchingProducts.size());

        for (int i = 0; i < numberOfProducts; i++) {
            Product product = matchingProducts.get(i);

            recommendations.add(
                    new AIProductRecommendation(
                            product.getId(),
                            product.getProductName(),
                            product.getDescription(),
                            product.getPrice(),
                            product.getImage()
                    )
            );
        }

        String reply;

        if (recommendations.isEmpty()) {
            reply = "I could not find an available product matching your budget.";
        } else if (budget != null) {
            reply = "Here are some available products within your budget of "
                    + budget + " shekels.";
        } else {
            reply = "Here are some available products that may be suitable for you.";
        }

        return new AIChatResponse(reply, recommendations);
    }

    private boolean productMatchesMessage(Product product, String message) {

        if (message == null || message.isBlank()) {
            return true;
        }

        String userMessage = message.toLowerCase();

        String productName = product.getProductName() == null
                ? ""
                : product.getProductName().toLowerCase();

        String description = product.getDescription() == null
                ? ""
                : product.getDescription().toLowerCase();

        String[] words = userMessage.split("\\s+");

        for (String word : words) {

            // Ignore very short common words.
            if (word.length() >= 3
                    && (productName.contains(word)
                    || description.contains(word))) {
                return true;
            }
        }

        return false;
    }

    private Double extractBudget(String message) {

        if (message == null) {
            return null;
        }

        // Finds a number such as 100 or 75.5 in the message.
        Pattern pattern = Pattern.compile("\\d+(\\.\\d+)?");
        Matcher matcher = pattern.matcher(message);

        if (matcher.find()) {
            return Double.parseDouble(matcher.group());
        }

        return null;
    }
}