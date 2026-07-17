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

@Entity
@Table(name = "orders")
public class Order {
	 @Id
	   @GeneratedValue(strategy = GenerationType.IDENTITY)
	   private Long id;
	   @CreationTimestamp
	   @Column(name = "created_at", updatable = false)
	   private LocalDateTime createdAt;
	   @UpdateTimestamp
	   @Column(name = "updated_at")
	   private LocalDateTime updatedAt;
	   @ManyToOne(fetch = FetchType.LAZY)
	   @JoinColumn(name = "customer_id")
	   private Customer customer;
	   @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
	   private List<OrderItem> orderItems;
	   
	   public Order() {
		   
	   }
	   public Order(Customer customer) {
		this.customer = customer;
	   }
	   public Long getId() {
		   return id;
	   }
	   public void setId(Long id) {
		   this.id = id;
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
	   public Customer getCustomer() {
		   return customer;
	   }
	   public void setCustomer(Customer customer) {
		   this.customer = customer;
	   }
	   public List<OrderItem> getOrderItems() {
		   return orderItems;
	   }
	   public void setOrderItems(List<OrderItem> orderItems) {
		   this.orderItems = orderItems;
	   }
	   

}
