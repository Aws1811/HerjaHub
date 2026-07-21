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
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;

import com.axsos.project.dto.CartItem;
import com.axsos.project.dto.EditProfileForm;
import com.axsos.project.models.Customer;
import com.axsos.project.models.Order;
import com.axsos.project.models.Product;
import com.axsos.project.models.Store;
import com.axsos.project.services.CustomerService;
import com.axsos.project.services.OrderService;
import com.axsos.project.services.ProductService;
import com.axsos.project.services.StoreService;

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

	@Autowired
	private StoreService storeService;

	// how many products/stores to preview on the dashboard before "Show more"
	private static final int DASHBOARD_PREVIEW_SIZE = 4;

	@GetMapping("/customer/dashboard")
	public String dashboard(HttpSession session, Model model) {

		// check if a customer is logged in by looking at the session
		Customer customer = (Customer) session.getAttribute("loggedInCustomer");

		if (customer == null) {
			return "redirect:/auth";
		}

		model.addAttribute("customer", customer);

		// a small preview row of products, newest first - same source list the
		// Products page uses, just capped to the first few for this page
		List<Product> allProducts = productService.getMarketplaceProducts();
		model.addAttribute("recentProducts", capList(allProducts, DASHBOARD_PREVIEW_SIZE));

		// a small preview row of stores
		List<Store> allStores = storeService.getAllStores();
		model.addAttribute("featuredStores", capList(allStores, DASHBOARD_PREVIEW_SIZE));

		return "customer/dashboard";
	}

	// shows every store on the platform - this is what the sidebar's "Stores"
	// link and the dashboard's "Show more" button both point to
	@GetMapping("/customer/stores")
	public String allStores(HttpSession session, Model model) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		model.addAttribute("customer", customer);
		model.addAttribute("stores", storeService.getAllStores());
		return "customer/stores";
	}

	// a single store's public page: its info + every product it sells -
	// linked from the Stores list, the dashboard's featured stores, and product detail
	@GetMapping("/customer/stores/{id}")
	public String showStore(@PathVariable("id") Long id, HttpSession session, Model model) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		Store store = storeService.findByIdWithProducts(id);
		if (store == null) {
			return "redirect:/customer/stores";
		}

		model.addAttribute("customer", customer);
		model.addAttribute("store", store);
		return "customer/showStore";
	}

	// small helper: returns the first "size" items of a list, or the whole
	// list if it's already smaller than that
	private <T> List<T> capList(List<T> list, int size) {
		return list.size() > size ? list.subList(0, size) : list;
	}

	// adds one product to the logged-in customer's cart (the cart lives in the session for now)
	@PostMapping("/customer/cart/add/{productId}")
	public String addToCart(@PathVariable("productId") Long productId,
	                        @RequestParam(value = "quantity", defaultValue = "1") int quantity,
	                        @RequestHeader(value = "Referer", required = false) String referer,
	                        HttpSession session) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		Optional<Product> productOpt = productService.getProductById(productId);
		if (productOpt.isEmpty()) {
			return "redirect:/customer/products";
		}

		Product product = productOpt.get();
		int available = product.getQuantity() == null ? 0 : product.getQuantity();

		// out of stock - nothing to add, send them back to the (now-hidden-button) product page
		if (available <= 0) {
			return "redirect:/customer/products/" + productId;
		}

		List<CartItem> cart = getCartFromSession(session);

		// if it's already in the cart, just bump the quantity instead of adding a duplicate line -
		// either way, never let the cart hold more of this product than is actually in stock
		boolean alreadyInCart = false;
		for (CartItem item : cart) {
			if (item.getProduct().getId().equals(productId)) {
				int newQuantity = Math.min(item.getQuantity() + quantity, available);
				item.setQuantity(newQuantity);
				alreadyInCart = true;
				break;
			}
		}
		if (!alreadyInCart) {
			cart.add(new CartItem(product, Math.min(quantity, available)));
		}

		session.setAttribute("cart", cart);

		// stay on whatever page the customer added from (product detail, etc.) -
		// only trust same-app customer URLs so a forged Referer can't redirect elsewhere
		if (referer != null && referer.contains("/customer/")) {
			return "redirect:" + referer;
		}
		return "redirect:/customer/products";
	}

	// shows everything currently in the logged-in customer's cart
	@GetMapping("/customer/cart")
	public String viewCart(HttpSession session, Model model) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		model.addAttribute("customer", customer);
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

		// every item in the cart went out of stock between being added and checking out -
		// nothing was ordered, so leave the cart alone and send them back to it
		if (order == null) {
			return "redirect:/customer/cart";
		}

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

		model.addAttribute("customer", customer);
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

		model.addAttribute("customer", customer);
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

		model.addAttribute("customer", customer);
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

		// if the email changed, it must not belong to another account
		if (!customer.getEmail().equalsIgnoreCase(form.getEmail()) && customerService.emailExists(form.getEmail())) {
			bindingResult.rejectValue("email", "error", "This email is already registered");
		}

		// changing the password requires the current one, verified, and the new one must be at least 8 chars
		boolean changingPassword = form.getNewPassword() != null && !form.getNewPassword().isBlank();
		if (changingPassword) {
			if (form.getCurrentPassword() == null || form.getCurrentPassword().isBlank()) {
				bindingResult.rejectValue("currentPassword", "error", "Enter your current password to set a new one");
			} else if (!customerService.checkPassword(customer, form.getCurrentPassword())) {
				bindingResult.rejectValue("currentPassword", "error", "Current password is incorrect");
			}
			if (form.getNewPassword().length() < 8) {
				bindingResult.rejectValue("newPassword", "error", "New password must be at least 8 characters");
			}
		}

		if (bindingResult.hasErrors()) {
			model.addAttribute("customer", customer); // topbar/hero read this; without it the re-render blanks them
			return "customer/edit-profile";
		}

		Customer updated = customerService.updateProfile(customer, form);

		// keep the session copy in sync with the freshly saved info
		session.setAttribute("loggedInCustomer", updated);

		return "redirect:/customer/dashboard";
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
