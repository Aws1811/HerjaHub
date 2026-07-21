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

    @Autowired
    private GeminiService geminiService;

    public AIChatResponse getRecommendations(String message) {

        // Get only products that are currently available.
        List<Product> availableProducts =
                productRepository.findByQuantityGreaterThan(0);

        if (availableProducts.isEmpty()) {
            return new AIChatResponse(
                    "Sorry, there are no available products right now.",
                    new ArrayList<>()
            );
        }

        // Read the customer's budget from the message.
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

        // If keywords did not match, use products within the budget.
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

        List<Product> selectedProducts = new ArrayList<>();

        List<AIProductRecommendation> recommendations =
                new ArrayList<>();

        // Return a maximum of four real database products.
        int numberOfProducts =
                Math.min(4, matchingProducts.size());

        for (int i = 0; i < numberOfProducts; i++) {

            Product product = matchingProducts.get(i);

            selectedProducts.add(product);

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

        if (recommendations.isEmpty()) {
            return new AIChatResponse(
                    "I could not find an available product matching your budget.",
                    recommendations
            );
        }

        // Give Gemini only the selected real HerjaHub products.
        String prompt = buildGeminiPrompt(
                message,
                budget,
                selectedProducts
        );

        String reply = geminiService.generateReply(prompt);

        return new AIChatResponse(reply, recommendations);
    }

    private String buildGeminiPrompt(
            String customerMessage,
            Double budget,
            List<Product> products
    ) {

        StringBuilder prompt = new StringBuilder();

        prompt.append("""
                You are the HerjaHub gift assistant.

                HerjaHub is an online marketplace that supports Palestinian
                artisans and sells Palestinian handmade products.

                Follow these rules:
                - Write like a friendly human shop assistant.
                - Answer directly in one to three short sentences.
                - Use plain text only.
                - Do not use Markdown, asterisks, headings, bullet points or labels.
                - Do not welcome the customer or introduce HerjaHub repeatedly.
                - Mention the product name and price naturally.
                - Explain briefly why it suits the customer.
                - Use dollars and the $ symbol when mentioning prices.
                - Recommend only products from the provided list.
                - Never invent products, prices or product information.
                - Do not add unnecessary closing sentences.
                - Do not mention that you are Gemini.

                Customer request:
                """);

        prompt.append(customerMessage).append("\n\n");

        if (budget != null) {
            prompt.append("Customer budget: $")
                    .append(budget)
                    .append(".\n\n");
        }

        prompt.append("Available HerjaHub products:\n");

        for (Product product : products) {

            prompt.append("- Product name: ")
                    .append(product.getProductName())
                    .append("\n");

            prompt.append("  Description: ")
                    .append(
                            product.getDescription() == null
                                    ? "No description available"
                                    : product.getDescription()
                    )
                    .append("\n");

            prompt.append("  Price: $")
                    .append(product.getPrice())
                    .append("\n");
        }

        return prompt.toString();
    }

    private boolean productMatchesMessage(
            Product product,
            String message
    ) {

        if (message == null || message.isBlank()) {
            return true;
        }

        String userMessage = message.toLowerCase();

        String productName =
                product.getProductName() == null
                        ? ""
                        : product.getProductName().toLowerCase();

        String description =
                product.getDescription() == null
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

        // Find a number such as 100 or 75.5.
        Pattern pattern =
                Pattern.compile("\\d+(\\.\\d+)?");

        Matcher matcher = pattern.matcher(message);

        if (matcher.find()) {
            return Double.parseDouble(matcher.group());
        }

        return null;
    }
}