package com.axsos.project.dto;

import com.axsos.project.models.Store;

public class StoreProfileDTO {
	private Long id;
	private String firstName;
	private String lastName;
	private String email;
	private String storeName;
	private String description;
	private String phone;
	private String address;
	private String image;

	public StoreProfileDTO() {
	}

	public StoreProfileDTO(Store store) {
		this.id = store.getId();
		this.firstName = store.getFirstName();
		this.lastName = store.getLastName();
		this.email = store.getEmail();
		this.storeName = store.getStoreName();
		this.description = store.getDescription();
		this.phone = store.getPhone();
		this.address = store.getAddress();
		this.image = store.getImage();
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
}
