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
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "stores")
public class Store {
	
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
	   @NotBlank(message = "Store name is required")
	   @Size(min = 2, max = 150)
	   @Column(name = "store_name")
	   private String storeName;
	   @Column(columnDefinition = "TEXT")
	   private String description;
	   
	   @NotEmpty(message = "Phone number is required!")
	   @Pattern(regexp = "^[0-9]{10}$", message = "Phone number must be exactly 10 digits!")
	   private String phone;
	   @Size(max = 255)
	   private String address;
	   private String image;
	   @CreationTimestamp
	   @Column(name = "created_at", updatable = false)
	   private LocalDateTime createdAt;
	   @UpdateTimestamp
	   @Column(name = "updated_at")
	   private LocalDateTime updatedAt;
	   @OneToMany(mappedBy = "store", cascade = CascadeType.ALL)
	   private List<Product> products;
	   public Store() {
	   }
	   public Store(@NotNull(message = "First name is required") @Size(min = 2, max = 100) String firstName,
			@NotNull(message = "Last name is required") @Size(min = 2, max = 100) String lastName,
			@NotNull(message = "Email is required") @Email(message = "Invalid email") String email,
			@NotNull(message = "Password is required") @Size(min = 8, max = 255) String password,
			@NotBlank(message = "Store name is required") @Size(min = 2, max = 150) String storeName,
			String description,
			@Pattern(regexp = "^[0-9+\\-\\s]{7,20}$", message = "Invalid phone number") String phone,
			@Size(max = 255) String address, String image) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.password = password;
		this.storeName = storeName;
		this.description = description;
		this.phone = phone;
		this.address = address;
		this.image = image;
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
	   public String getStoreName() {
		   return storeName;
	   }
	   public void setStoreName(String storeName) {
		   this.storeName = storeName;
	   }
	   public String getDescription() {
		   return description;
	   }
	   public void setDescription(String description) {
		   this.description = description;
	   }
	   public String getPhone() {
		   return phone;
	   }
	   public void setPhone(String phone) {
		   this.phone = phone;
	   }
	   public String getAddress() {
		   return address;
	   }
	   public void setAddress(String address) {
		   this.address = address;
	   }
	   public String getImage() {
		   return image;
	   }
	   public void setImage(String image) {
		   this.image = image;
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
	   public List<Product> getProducts() {
		   return products;
	   }
	   public void setProducts(List<Product> products) {
		   this.products = products;
	   }
	   
	   
	}

