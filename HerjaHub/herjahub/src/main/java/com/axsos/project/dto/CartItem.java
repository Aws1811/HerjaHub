package com.axsos.project.dto;

import com.axsos.project.models.Product;

// Holds one line of the shopping cart while it lives in the session.
// This is NOT a database table - once the customer checks out, each
// CartItem gets turned into a real OrderItem attached to a new Order.
public class CartItem {

	private Product product;
	private int quantity;

	public CartItem() {
	}

	public CartItem(Product product, int quantity) {
		this.product = product;
		this.quantity = quantity;
	}

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	// price * quantity for this one line, used by the Cart page
	public double getSubtotal() {
		return product.getPrice() * quantity;
	}
}
