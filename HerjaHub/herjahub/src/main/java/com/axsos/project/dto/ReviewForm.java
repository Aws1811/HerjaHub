package com.axsos.project.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

// used by the customer-facing "leave a review" form on the product detail page
public class ReviewForm {
	@NotNull(message = "Please choose a rating")
	@Min(value = 1, message = "Minimum rating is 1")
	@Max(value = 5, message = "Maximum rating is 5")
	private Integer rating;

	@Size(max = 1000, message = "Review cannot exceed 1000 characters")
	private String comment;

	public ReviewForm() {
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
}
