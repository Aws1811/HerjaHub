package com.axsos.project.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.dto.CartItem;
import com.axsos.project.models.Customer;
import com.axsos.project.models.Order;
import com.axsos.project.models.OrderItem;
import com.axsos.project.repositores.OrderRepository;

@Service
public class OrderService {
	@Autowired
	private OrderRepository orderRepository;

	// all past orders for this customer, used on the "My Orders" page
	public List<Order> getOrdersForCustomer(Customer customer) {
		return orderRepository.findByCustomerOrderByCreatedAtDesc(customer);
	}

	// one order by id, used on the Order Confirmation page
	public Optional<Order> getOrderById(Long id) {
		return orderRepository.findById(id);
	}

	// turns the session cart into a real Order + OrderItems and saves it
	public Order placeOrder(Customer customer, List<CartItem> cartItems) {

		Order order = new Order(customer);

		List<OrderItem> orderItems = cartItems.stream()
				.map(item -> new OrderItem(item.getQuantity(), item.getProduct().getPrice(), order, item.getProduct()))
				.toList();

		order.setOrderItems(orderItems);

		// Order.orderItems has cascade = ALL, so saving the order also saves each OrderItem
		return orderRepository.save(order);
	}
}
