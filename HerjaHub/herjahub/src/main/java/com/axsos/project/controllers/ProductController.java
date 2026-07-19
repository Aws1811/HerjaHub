package com.axsos.project.controllers;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.axsos.project.models.Comment;
import com.axsos.project.models.Customer;
import com.axsos.project.models.Product;
import com.axsos.project.services.CommentService;
import com.axsos.project.services.ProductService;
import com.axsos.project.services.StoreService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class ProductController {

	@Autowired
	private ProductService productService;

	@Autowired
	private StoreService storeService;

	@Autowired
	private CommentService commentService;

	// shows the product grid with the store filter sidebar
	@GetMapping("/customer/products")
	public String showProducts(Model model) {
		model.addAttribute("products", productService.getAllProducts());
		model.addAttribute("stores", storeService.getAllStores());
		return "customer/products";
	}

	// shows one product's details, along with any existing comments on it
	@GetMapping("/customer/products/{id}")
	public String productDetails(@PathVariable("id") Long id, Model model) {

		Optional<Product> productOpt = productService.getProductById(id);

		if (productOpt.isEmpty()) {
			return "redirect:/customer/products";
		}

		model.addAttribute("product", productOpt.get());

		// an empty Comment for the "leave a comment" form on this page to bind to.
		// Named "newComment" rather than "comment" on purpose - Comment has a field
		// that's also called "comment", and if the model attribute shared that exact
		// name, Spring would try to resolve the whole object from a single request
		// parameter (via its JPA id) instead of binding each field individually.
		model.addAttribute("newComment", new Comment());

		return "customer/product-details";
	}

	// handles a customer submitting a new comment (with a rating) on a product
	@PostMapping("/customer/products/{id}/comments")
	public String addComment(@PathVariable("id") Long id,
	                         @Valid @ModelAttribute("newComment") Comment comment,
	                         BindingResult bindingResult,
	                         HttpSession session,
	                         Model model) {

		Customer customer = (Customer) session.getAttribute("loggedInCustomer");
		if (customer == null) {
			return "redirect:/auth";
		}

		Optional<Product> productOpt = productService.getProductById(id);
		if (productOpt.isEmpty()) {
			return "redirect:/customer/products";
		}

		if (bindingResult.hasErrors()) {
			// re-show the product page with the validation errors
			model.addAttribute("product", productOpt.get());
			return "customer/product-details";
		}

		// Always clear the id before saving. This form only ever creates a NEW
		// comment, but if a non-null id ever ends up on this object (e.g. a
		// stale cached page resubmitting an old form), Hibernate would treat
		// it as an UPDATE to an existing row instead of an INSERT of a new
		// one - which fails loudly (StaleObjectStateException) since that
		// row doesn't actually match. Clearing it here guarantees this is
		// always treated as a brand new comment.
		comment.setId(null);

		// attach the comment to the logged-in customer and this product before saving
		comment.setCustomer(customer);
		comment.setProduct(productOpt.get());
		commentService.addComment(comment);

		return "redirect:/customer/products/" + id;
	}
}