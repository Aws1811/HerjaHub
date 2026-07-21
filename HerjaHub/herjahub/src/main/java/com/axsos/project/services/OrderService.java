package com.axsos.project.services;

import java.util.List;
import java.util.Optional;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.axsos.project.dto.CartItem;
import com.axsos.project.models.Customer;
import com.axsos.project.models.Order;
import com.axsos.project.models.OrderItem;
import com.axsos.project.models.Product;
import com.axsos.project.repositores.OrderRepository;
import com.axsos.project.repositores.ProductRepository;

@Service
public class OrderService {
	@Autowired
	private OrderRepository orderRepository;

	@Autowired
	private ProductRepository productRepository;

	// all past orders for this customer, used on the "My Orders" page
	public List<Order> getOrdersForCustomer(Customer customer) {
		return orderRepository.findByCustomerOrderByCreatedAtDesc(customer);
	}

	// one order by id, used on the Order Confirmation page
	public Optional<Order> getOrderById(Long id) {
		return orderRepository.findById(id);
	}

	// turns the session cart into a real Order + OrderItems, decrementing each
	// product's stock as it goes. Re-reads each product's live quantity (rather
	// than trusting the session's cached copy) in case stock changed after the
	// item was added to the cart, and caps/skips items accordingly so the store
	// never oversells.
	@Transactional
	public Order placeOrder(Customer customer, List<CartItem> cartItems) {

		Order order = new Order(customer);
		List<OrderItem> orderItems = new ArrayList<>();

		for (CartItem item : cartItems) {
			Long productId = item.getProduct().getId();
			Product product = productRepository.findById(productId).orElse(null);
			if (product == null) {
				continue; // product was deleted since being added to the cart
			}

			int available = product.getQuantity() == null ? 0 : product.getQuantity();
			if (available <= 0) {
				continue; // out of stock - drop this line from the order entirely
			}

			int orderedQuantity = Math.min(item.getQuantity(), available);
			orderItems.add(new OrderItem(orderedQuantity, product.getPrice(), order, product));

			product.setQuantity(available - orderedQuantity);
			productRepository.save(product);
		}

		// everything in the cart went out of stock between adding it and checking out -
		// nothing to save, let the controller know so it can send the customer back to the cart
		if (orderItems.isEmpty()) {
			return null;
		}

		order.setOrderItems(orderItems);

		// Order.orderItems has cascade = ALL, so saving the order also saves each OrderItem
		return orderRepository.save(order);
	}
}
