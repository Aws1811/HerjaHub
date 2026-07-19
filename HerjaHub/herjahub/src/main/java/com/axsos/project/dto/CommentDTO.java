package com.axsos.project.dto;

import java.time.LocalDateTime;

import com.axsos.project.models.Comment;

public class CommentDTO {
	private Long id;
	private String customerName;
	private Integer rating;
	private String comment;
	private LocalDateTime createdAt;
	private String productName; // only populated on the store-wide comments list

	public CommentDTO() {
	}

	public CommentDTO(Comment comment) {
		this.id = comment.getId();
		this.rating = comment.getRating();
		this.comment = comment.getComment();
		this.createdAt = comment.getCreatedAt();
		if (comment.getCustomer() != null) {
			this.customerName = comment.getCustomer().getFirstName() + " " + comment.getCustomer().getLastName();
		}
		if (comment.getProduct() != null) {
			this.productName = comment.getProduct().getProductName();
		}
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public Integer getRating() {
		return rating;
	}

	public void setRating(Integer rating) {
		this.rating = rating;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}
}
