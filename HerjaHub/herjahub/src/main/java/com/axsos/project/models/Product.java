package com.axsos.project.models;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "products")
public class Product {
	@Id
	   @GeneratedValue(strategy = GenerationType.IDENTITY)
	   private Long id;
	   @NotNull(message = "Product name is required")
	   @Size(min = 2, max = 150)
	   private String productName;
	   @Column(columnDefinition = "TEXT")
	   private String description;
	   @NotNull(message = "Price is required")
	   @Positive(message = "Price must be greater than 0")
	   private Double price;
	   private String image;
	   @NotNull(message = "Quantity is required")
	   @Min(value = 0, message = "Quantity cannot be negative")
	   private Integer quantity;
	   @CreationTimestamp
	   @Column(name = "created_at", updatable = false)
	   private LocalDateTime createdAt;
	   @UpdateTimestamp
	   @Column(name = "updated_at")
	   private LocalDateTime updatedAt;
	   @ManyToOne(fetch = FetchType.LAZY)
	   @JoinColumn(name = "store_id")
	   private Store store;
	   @OneToMany(mappedBy = "product", cascade = CascadeType.ALL)
	   private List<Comment> comments;
	   @OneToMany(mappedBy = "product", cascade = CascadeType.ALL)
	   private List<OrderItem> orderItems;
	   
	   public Product() {
		   
	   }
	   
	   public Product(@NotNull(message = "Product name is required") @Size(min = 2, max = 150) String productName,
			String description,
			@NotNull(message = "Price is required") @Positive(message = "Price must be greater than 0") Double price,
			String image,
			@NotNull(message = "Quantity is required") @Min(value = 0, message = "Quantity cannot be negative") Integer quantity,
			Store store) {
		this.productName = productName;
		this.description = description;
		this.price = price;
		this.image = image;
		this.quantity = quantity;
		this.store = store;
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

	   public LocalDateTime getUpdatedAt() {
		   return updatedAt;
	   }

	   public void setUpdatedAt(LocalDateTime updatedAt) {
		   this.updatedAt = updatedAt;
	   }

	   public Store getStore() {
		   return store;
	   }

	   public void setStore(Store store) {
		   this.store = store;
	   }

	   public List<Comment> getComments() {
		   return comments;
	   }

	   public void setComments(List<Comment> comments) {
		   this.comments = comments;
	   }

	   public List<OrderItem> getOrderItems() {
		   return orderItems;
	   }

	   public void setOrderItems(List<OrderItem> orderItems) {
		   this.orderItems = orderItems;
	   }
	   
	   
}

