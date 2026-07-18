package com.axsos.project.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.axsos.project.models.Product;
import com.axsos.project.models.Store;
import com.axsos.project.services.ProductService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;


@Controller
public class StoreController {

	@Autowired
	private ProductService productService;
// route for render the dashboard page
	@GetMapping("/store/dashboard")
    public String dashboard(HttpSession session, Model model) {

        // check if a store owner is logged in by looking at the session
        Store store = (Store) session.getAttribute("loggedInStore");

        if (store == null) {
            return "redirect:/auth";
        }

        model.addAttribute("store", store);
        return "store/dashboard";
    }

	// shows the empty Add Product form
	@GetMapping("/store/products/add")
	public String addProductPage(HttpSession session, Model model) {

		Store store = (Store) session.getAttribute("loggedInStore");
		if (store == null) {
			return "redirect:/auth";
		}

		model.addAttribute("product", new Product());
		return "store/add-product";
	}

	// handles the Add Product form submits
	@PostMapping("/store/products/add")
	public String addProduct(@Valid @ModelAttribute("product") Product product,
							  BindingResult bindingResult,
							  HttpSession session,
							  Model model) {

		Store store = (Store) session.getAttribute("loggedInStore");
		if (store == null) {
			return "redirect:/auth";
		}

		if (bindingResult.hasErrors()) {
			return "store/add-product";
		}

		// attach the product to the logged-in store before saving
		product.setStore(store);
		productService.createProduct(product);

		return "redirect:/store/dashboard";
	}
}
