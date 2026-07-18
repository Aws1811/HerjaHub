package com.axsos.project.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

// Used only by the "Edit Store" page. Lighter than the full Store entity -
// firstName/lastName/email/password belong to the account itself, not the
// store's public info, so they're left out of this form on purpose.
public class EditStoreForm {

	@NotBlank(message = "Store name is required")
	@Size(min = 2, max = 150, message = "Store name must be between 2 and 150 characters")
	private String storeName;

	private String description;

	@Pattern(regexp = "^$|^[0-9]{10}$", message = "Phone number must be exactly 10 digits")
	private String phone;

	@Size(max = 255, message = "Address cannot exceed 255 characters")
	private String address;

	public EditStoreForm() {
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
}
