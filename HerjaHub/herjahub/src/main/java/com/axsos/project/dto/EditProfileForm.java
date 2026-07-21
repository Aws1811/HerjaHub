package com.axsos.project.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

// Used only by the "Edit Profile" page. Lighter than RegistrationForm since
// a customer editing their profile doesn't need account type / store fields,
// and the new password is optional - leaving it blank keeps the old password.
public class EditProfileForm {

	@NotBlank(message = "First name is required")
	@Size(min = 2, max = 100, message = "First name must be between 2 and 100 characters")
	private String firstName;

	@NotBlank(message = "Last name is required")
	@Size(min = 2, max = 100, message = "Last name must be between 2 and 100 characters")
	private String lastName;

	@NotBlank(message = "Email is required")
	@Email(message = "Please enter a valid email address")
	private String email;

	// required only when setting a new password - must match the customer's existing password
	private String currentPassword;

	// optional - only hashed and saved if the customer actually typed a new one
	private String newPassword;

	public EditProfileForm() {
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
