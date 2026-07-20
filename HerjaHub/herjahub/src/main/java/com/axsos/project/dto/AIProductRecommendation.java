package com.axsos.project.dto;

public class AIProductRecommendation {

    private Long id;
    private String productName;
    private String description;
    private Double price;
    private String image;

    public AIProductRecommendation() {
    }

    public AIProductRecommendation(
            Long id,
            String productName,
            String description,
            Double price,
            String image
    ) {
        this.id = id;
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.image = image;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}