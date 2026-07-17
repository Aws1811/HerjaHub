package com.axsos.project.models;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "customers")
public class Customer {
	 @Id
	   @GeneratedValue(strategy = GenerationType.IDENTITY)
	   private Long id;
	   @NotNull(message = "First name is required")
	   @Size(min = 2, max = 100)
	   
	   private String firstName;
	   @NotNull(message = "Last name is required")
	   @Size(min = 2, max = 100)
	   
	   private String lastName;
	   @NotNull(message = "Email is required")
	   @Email(message = "Invalid email")
	   @Column(unique = true)
	   private String email;
	   @NotNull(message = "Password is required")
	   @Size(min = 8, max = 255)
	   private String password;
	   @CreationTimestamp
	   @Column(name = "created_at", updatable = false)
	   private LocalDateTime createdAt;
	   @UpdateTimestamp
	   @Column(name = "updated_at")
	   private LocalDateTime updatedAt;
	   @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL)
	   private List<Order> orders;
	   @OneToMany(mappedBy = "customer", cascade = CascadeType.ALL)
	   private List<Comment> comments;
	   
	   public Customer() {
		   
	   }
	   public Customer(@NotNull(message = "First name is required") @Size(min = 2, max = 100) String firstName,
			@NotNull(message = "Last name is required") @Size(min = 2, max = 100) String lastName,
			@NotNull(message = "Email is required") @Email(message = "Invalid email") String email,
			@NotNull(message = "Password is required") @Size(min = 8, max = 255) String password) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.password = password;
	   }
	   public Long getId() {
		   return id;
	   }
	   public void setId(Long id) {
		   this.id = id;
	   }
	   public String getFirstName() {
		   return firstName;
	   }
	   public void setFirstName(String firstName) {
		   this.firstName = firstName;
	   }
	   public String getLastName() {
		   return lastName;
	   }
	   public void setLastName(String lastName) {
		   this.lastName = lastName;
	   }
	   public String getEmail() {
		   return email;
	   }
	   public void setEmail(String email) {
		   this.email = email;
	   }
	   public String getPassword() {
		   return password;
	   }
	   public void setPassword(String password) {
		   this.password = password;
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
	   public List<Order> getOrders() {
		   return orders;
	   }
	   public void setOrders(List<Order> orders) {
		   this.orders = orders;
	   }
	   public List<Comment> getComments() {
		   return comments;
	   }
	   public void setComments(List<Comment> comments) {
		   this.comments = comments;
	   }
	   
	   
	   
}
