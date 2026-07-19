package com.axsos.project.dto;

import java.time.LocalDateTime;

public class ProductDTO {
	private Long id;
	private String productName;
	private String description;
	private Double price;
	private String image;
	private Integer quantity;
	private LocalDateTime createdAt;
	private Long unitsSold;
	private Double revenue;

	public ProductDTO() {
	}

	public ProductDTO(Long id, String productName, String description, Double price, String image,
			Integer quantity, LocalDateTime createdAt, Long unitsSold, Double revenue) {
		this.id = id;
		this.productName = productName;
		this.description = description;
		this.price = price;
		this.image = image;
		this.quantity = quantity;
		this.createdAt = createdAt;
		this.unitsSold = unitsSold;
		this.revenue = revenue;
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

	public Integer getQuantity() {
		return quantity;
	}

	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public Long getUnitsSold() {
		return unitsSold;
	}

	public void setUnitsSold(Long unitsSold) {
		this.unitsSold = unitsSold;
	}

	public Double getRevenue() {
		return revenue;
	}

	public void setRevenue(Double revenue) {
		this.revenue = revenue;
	}
}
