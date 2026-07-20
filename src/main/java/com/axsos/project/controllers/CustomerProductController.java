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
import org.springframework.web.bind.annotation.RequestMapping;

import com.axsos.project.dto.ReviewForm;
import com.axsos.project.models.Customer;
import com.axsos.project.models.Product;
import com.axsos.project.services.CommentService;
import com.axsos.project.services.ProductService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

// customer-facing marketplace: browse every store's products and leave reviews.
// this is what actually feeds the "Comments" panels the store owner sees on
// the Edit Store / Edit Product pages - previously there was no page anywhere
// in the app that let a customer create a comment in the first place.
@Controller
@RequestMapping("/customer/products")
public class CustomerProductController {

	@Autowired
	private ProductService productService;

	@Autowired
	private CommentService commentService;

	// GET /customer/products - grid of every product from every store
	@GetMapping
	public String list(HttpSession session, Model model) {
		Customer customer = requireCustomer(session);
		if (customer == null) {
			return "redirect:/auth";
		}
		model.addAttribute("customer", customer);
		model.addAttribute("products", productService.getMarketplaceProducts());
		return "customer/products";
	}

	// GET /customer/products/{id} - product detail + existing reviews + review form
	@GetMapping("/{id}")
	public String detail(@PathVariable Long id, HttpSession session, Model model) {
		Customer customer = requireCustomer(session);
		if (customer == null) {
			return "redirect:/auth";
		}
		Optional<Product> productOpt = productService.getProductWithStore(id);
		if (productOpt.isEmpty()) {
			return "redirect:/customer/products";
		}
		addDetailAttributes(model, customer, productOpt.get(), id);
		model.addAttribute("reviewForm", new ReviewForm());
		return "customer/product-detail";
	}

	// POST /customer/products/{id}/reviews - saves the rating + review, then re-shows the product
	@PostMapping("/{id}/reviews")
	public String addReview(@PathVariable Long id, @Valid @ModelAttribute("reviewForm") ReviewForm form,
			BindingResult bindingResult, HttpSession session, Model model) {
		Customer customer = requireCustomer(session);
		if (customer == null) {
			return "redirect:/auth";
		}
		Optional<Product> productOpt = productService.getProductWithStore(id);
		if (productOpt.isEmpty()) {
			return "redirect:/customer/products";
		}

		if (bindingResult.hasErrors()) {
			addDetailAttributes(model, customer, productOpt.get(), id);
			model.addAttribute("errorMessage", firstError(bindingResult));
			return "customer/product-detail";
		}

		commentService.addComment(id, customer, form.getRating(), form.getComment());
		return "redirect:/customer/products/" + id;
	}

	private void addDetailAttributes(Model model, Customer customer, Product product, Long productId) {
		model.addAttribute("customer", customer);
		model.addAttribute("product", product);
		model.addAttribute("comments", commentService.getCommentsForProduct(productId));
		model.addAttribute("avgRating", commentService.getAverageRating(productId));
		model.addAttribute("reviewCount", commentService.getReviewCount(productId));
	}

	private String firstError(BindingResult bindingResult) {
		return bindingResult.getFieldErrors().stream()
				.findFirst()
				.map(e -> e.getDefaultMessage())
				.orElse("Please check the form and try again");
	}

	private Customer requireCustomer(HttpSession session) {
		return (Customer) session.getAttribute("loggedInCustomer");
	}
}
