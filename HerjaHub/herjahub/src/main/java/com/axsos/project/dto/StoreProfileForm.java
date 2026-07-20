package com.axsos.project.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class StoreProfileForm {
	@NotNull(message = "First name is required")
	@Size(min = 2, max = 100, message = "First name must be between 2 and 100 characters")
	private String firstName;

	@NotNull(message = "Last name is required")
	@Size(min = 2, max = 100, message = "Last name must be between 2 and 100 characters")
	private String lastName;

	@NotNull(message = "Store name is required")
	@Size(min = 2, max = 150, message = "Store name must be between 2 and 150 characters")
	private String storeName;

	@Size(max = 2000, message = "Description cannot exceed 2000 characters")
	private String description;

	@Pattern(regexp = "^[0-9]{10}$", message = "Phone number must be exactly 10 digits")
	private String phone;

	@Size(max = 255, message = "Address cannot exceed 255 characters")
	private String address;

	private String image;

	// optional password change - only applied when both fields are provided
	private String currentPassword;

	// not annotated with @Size here on purpose: an untouched field submits as ""
	// (not null), so a blanket @Size(min=8) would fail on every save even when
	// the person isn't changing their password. Length is checked in the
	// controller, only when this is actually non-blank.
	private String newPassword;

	public StoreProfileForm() {
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

	public String getCurrentPassword() {
		return currentPassword;
	}

	public void setCurrentPassword(String currentPassword) {
		this.currentPassword = currentPassword;
	}

	public String getNewPassword() {
		return newPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}
}
