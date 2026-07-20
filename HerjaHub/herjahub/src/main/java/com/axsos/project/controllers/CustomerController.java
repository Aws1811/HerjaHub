package com.axsos.project.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.axsos.project.dto.CartItem;
import com.axsos.project.dto.EditProfileForm;
import com.axsos.project.models.Customer;
import com.axsos.project.models.Order;
import com.axsos.project.models.Product;
import com.axsos.project.services.CustomerService;
import com.axsos.project.services.OrderService;
import com.axsos.project.services.ProductService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;


@Controller
public class CustomerController {

	@Autowired
	private CustomerService customerService;

	@Autowired
	private ProductService productService;

	@Autowired
	private OrderService orderService;

	@GetMapping("/customer/dashboard")
    public String dashboard(HttpSession session, Model model) {

        // check if a customer is logged in by looking at the session
        Customer customer = (Customer) session.getAttribute("loggedInCustomer");

        if (customer == null) {
            return "redirect:/auth";
        }

        model.addAttribute("customer", customer);
        return "/customer/products";
    }

	// adds one product to the logged-in customer's cart (the cart lives in the session for now)
	@PostMapping("/customer/cart/add/{productId}")
	public String addToCart(@PathVariable("productId") Long productId,
							 @RequestParam(value = "quantity", defaultValue = "1") int quantity,
							 HttpSession session) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		Optional<Product> productOpt = productService.getProductById(productId);
		if (productOpt.isEmpty()) {
			return "redirect:/customer/products";
		}

		List<CartItem> cart = getCartFromSession(session);

		// if it's already in the cart, just bump the quantity instead of adding a duplicate line
		boolean alreadyInCart = false;
		for (CartItem item : cart) {
			if (item.getProduct().getId().equals(productId)) {
				item.setQuantity(item.getQuantity() + quantity);
				alreadyInCart = true;
				break;
			}
		}
		if (!alreadyInCart) {
			cart.add(new CartItem(productOpt.get(), quantity));
		}

		session.setAttribute("cart", cart);
		return "redirect:/customer/cart";
	}

	// shows everything currently in the logged-in customer's cart
	@GetMapping("/customer/cart")
	public String viewCart(HttpSession session, Model model) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		model.addAttribute("cartItems", getCartFromSession(session));
		return "customer/cart";
	}

	// turns the cart into a real Order, empties the cart, and sends the customer to the confirmation page
	@PostMapping("/customer/cart/checkout")
	public String checkout(HttpSession session) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		List<CartItem> cart = getCartFromSession(session);
		if (cart.isEmpty()) {
			return "redirect:/customer/cart";
		}

		Order order = orderService.placeOrder(customer, cart);

		// empty the cart now that it has become a real order
		session.setAttribute("cart", new ArrayList<CartItem>());

		return "redirect:/customer/orders/" + order.getId() + "/confirmation";
	}

	// lists every past order for the logged-in customer
	@GetMapping("/customer/orders")
	public String myOrders(HttpSession session, Model model) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		model.addAttribute("orders", orderService.getOrdersForCustomer(customer));
		return "customer/orders";
	}

	// the "Order placed successfully" page shown right after checkout
	@GetMapping("/customer/orders/{id}/confirmation")
	public String orderConfirmation(@PathVariable("id") Long id, HttpSession session, Model model) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		Optional<Order> orderOpt = orderService.getOrderById(id);

		// make sure the order exists and actually belongs to this customer
		if (orderOpt.isEmpty() || !orderOpt.get().getCustomer().getId().equals(customer.getId())) {
			return "redirect:/customer/orders";
		}

		model.addAttribute("order", orderOpt.get());
		return "customer/order-confirmation";
	}

	// shows the Edit Profile form, pre-filled with the logged-in customer's current info
	@GetMapping("/customer/profile/edit")
	public String editProfilePage(HttpSession session, Model model) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		EditProfileForm form = new EditProfileForm();
		form.setFirstName(customer.getFirstName());
		form.setLastName(customer.getLastName());
		form.setEmail(customer.getEmail());

		model.addAttribute("editProfileForm", form);
		return "customer/edit-profile";
	}

	// handles the Edit Profile form submit
	@PostMapping("/customer/profile/edit")
	public String editProfile(@Valid @ModelAttribute("editProfileForm") EditProfileForm form,
							   BindingResult bindingResult,
							   HttpSession session,
							   Model model) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		if (bindingResult.hasErrors()) {
			return "customer/edit-profile";
		}

		Customer updated = customerService.updateProfile(customer, form);

		// keep the session copy in sync with the freshly saved info
		session.setAttribute("loggedInCustomer", updated);

		return "redirect:/customer/products";
	}

	// small helper so every cart route reads/writes the session the same way
	@SuppressWarnings("unchecked")
	private List<CartItem> getCartFromSession(HttpSession session) {
		List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
		if (cart == null) {
			cart = new ArrayList<>();
			session.setAttribute("cart", cart);
		}
		return cart;
	}
}
