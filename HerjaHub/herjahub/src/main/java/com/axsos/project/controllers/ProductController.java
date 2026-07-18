package com.axsos.project.controllers;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.axsos.project.models.Product;
import com.axsos.project.services.ProductService;
import com.axsos.project.services.StoreService;

@Controller
public class ProductController {
// here are for using the services with final
	@Autowired
	private ProductService productService;

	@Autowired
	private StoreService storeService;

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
		return "customer/product-details";
	}
}
