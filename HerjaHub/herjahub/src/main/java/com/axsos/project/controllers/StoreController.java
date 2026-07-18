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

import com.axsos.project.dto.EditStoreForm;
import com.axsos.project.models.Product;
import com.axsos.project.models.Store;
import com.axsos.project.services.ProductService;
import com.axsos.project.services.StoreService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;


@Controller
public class StoreController {

	@Autowired
	private ProductService productService;

	@Autowired
	private StoreService storeService;

	@GetMapping("/store/dashboard")
	public String dashboard(HttpSession session, Model model) {

		// check if a store owner is logged in by looking at the session
		Store store = (Store) session.getAttribute("loggedInStore");

		if (store == null) {
			return "redirect:/auth";
		}

		model.addAttribute("store", store);

		// this store's own products, shown on the dashboard
		model.addAttribute("products", productService.getProductsByStore(store));

		return "store/store-dashboard";
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

	// handles the Add Product form submit
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

	// shows one product's summary, with comments and an "Edit" button -
	// this is the read-only view the store owner sees before editing
	@GetMapping("/store/products/{id}")
	public String viewProduct(@PathVariable("id") Long id, HttpSession session, Model model) {

		Store store = (Store) session.getAttribute("loggedInStore");
		if (store == null) {
			return "redirect:/auth";
		}

		Optional<Product> productOpt = productService.getProductById(id);

		// make sure the product exists and actually belongs to this store,
		// so a store owner can't view/edit someone else's product by guessing the URL
		if (productOpt.isEmpty() || !productOpt.get().getStore().getId().equals(store.getId())) {
			return "redirect:/store/dashboard";
		}

		model.addAttribute("product", productOpt.get());
		return "store/product-view";
	}

	// shows the Edit Product form, pre-filled with the product's current values
	@GetMapping("/store/products/{id}/edit")
	public String editProductPage(@PathVariable("id") Long id, HttpSession session, Model model) {

		Store store = (Store) session.getAttribute("loggedInStore");
		if (store == null) {
			return "redirect:/auth";
		}

		Optional<Product> productOpt = productService.getProductById(id);

		if (productOpt.isEmpty() || !productOpt.get().getStore().getId().equals(store.getId())) {
			return "redirect:/store/dashboard";
		}

		model.addAttribute("product", productOpt.get());
		return "store/edit-product";
	}

	// handles the Edit Product form submit
	@PostMapping("/store/products/{id}/edit")
	public String editProduct(@PathVariable("id") Long id,
	                          @Valid @ModelAttribute("product") Product formValues,
	                          BindingResult bindingResult,
	                          HttpSession session,
	                          Model model) {

		Store store = (Store) session.getAttribute("loggedInStore");
		if (store == null) {
			return "redirect:/auth";
		}

		Optional<Product> existingOpt = productService.getProductById(id);

		if (existingOpt.isEmpty() || !existingOpt.get().getStore().getId().equals(store.getId())) {
			return "redirect:/store/dashboard";
		}

		if (bindingResult.hasErrors()) {
			return "store/edit-product";
		}

		// copy the submitted values onto the real, already-saved product
		// (see ProductService.updateProduct) instead of saving formValues
		// directly - that keeps the product's store/id/comments untouched
		productService.updateProduct(existingOpt.get(), formValues);

		return "redirect:/store/dashboard";
	}

	// shows the Edit Store form, pre-filled with the store's current info
	@GetMapping("/store/profile/edit")
	public String editStorePage(HttpSession session, Model model) {

		Store sessionStore = (Store) session.getAttribute("loggedInStore");
		if (sessionStore == null) {
			return "redirect:/auth";
		}

		// re-fetch a fresh copy so the "products" collection can be lazily
		// loaded in the JSP - the copy in the session is from an earlier
		// request whose Hibernate session is already closed
		Optional<Store> storeOpt = storeService.getStoreById(sessionStore.getId());
		if (storeOpt.isEmpty()) {
			return "redirect:/auth";
		}
		Store store = storeOpt.get();

		EditStoreForm form = new EditStoreForm();
		form.setStoreName(store.getStoreName());
		form.setDescription(store.getDescription());
		form.setPhone(store.getPhone());
		form.setAddress(store.getAddress());

		model.addAttribute("editStoreForm", form);

		// needed so the JSP can loop through this store's products and show
		// each product's comments - see Product.comments in the model
		model.addAttribute("store", store);

		return "store/edit-store";
	}

	// handles the Edit Store form submit
	@PostMapping("/store/profile/edit")
	public String editStore(@Valid @ModelAttribute("editStoreForm") EditStoreForm form,
	                        BindingResult bindingResult,
	                        HttpSession session,
	                        Model model) {

		Store store = (Store) session.getAttribute("loggedInStore");
		if (store == null) {
			return "redirect:/auth";
		}

		if (bindingResult.hasErrors()) {
			model.addAttribute("store", store);
			return "store/edit-store";
		}

		Store updated = storeService.updateStoreProfile(store, form);

		// keep the session copy in sync with the freshly saved info
		session.setAttribute("loggedInStore", updated);

		return "redirect:/store/dashboard";
	}
}