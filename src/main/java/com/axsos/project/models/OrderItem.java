package com.axsos.project.models;

import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

@Entity
@Table(name = "oreder_items")
public class OrderItem {
	@Id
	   @GeneratedValue(strategy = GenerationType.IDENTITY)
	   private Long id;
	   @NotNull
	   @Min(1)
	   private Integer quantity;
	   @NotNull
	   @Positive
	   private Double price;
	   @CreationTimestamp
	   @Column(name = "created_at", updatable = false)
	   private LocalDateTime createdAt;
	   @UpdateTimestamp
	   @Column(name = "updated_at")
	   private LocalDateTime updatedAt;
	   @ManyToOne(fetch = FetchType.LAZY)
	   @JoinColumn(name = "order_id")
	   private Order order;
	   @ManyToOne(fetch = FetchType.LAZY)
	   @JoinColumn(name = "product_id")
	   private Product product;
	   
	   public OrderItem() {
		   
	   }
	   public OrderItem(@NotNull @Min(1) Integer quantity, @NotNull @Positive Double price, Order order, Product product) {
		this.quantity = quantity;
		this.price = price;
		this.order = order;
		this.product = product;
	   }
	   public Long getId() {
		   return id;
	   }
	   public void setId(Long id) {
		   this.id = id;
	   }
	   public Integer getQuantity() {
		   return quantity;
	   }
	   public void setQuantity(Integer quantity) {
		   this.quantity = quantity;
	   }
	   public Double getPrice() {
		   return price;
	   }
	   public void setPrice(Double price) {
		   this.price = price;
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
	   public Order getOrder() {
		   return order;
	   }
	   public void setOrder(Order order) {
		   this.order = order;
	   }
	   public Product getProduct() {
		   return product;
	   }
	   public void setProduct(Product product) {
		   this.product = product;
	   }
	   
	   
}
