package com.axsos.project.controllers;


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
import org.springframework.web.bind.annotation.RequestMapping;

import com.axsos.project.dto.ProductDTO;
import com.axsos.project.dto.ProductPageForm;
import com.axsos.project.models.Product;
import com.axsos.project.models.Store;
import com.axsos.project.services.CommentService;
import com.axsos.project.services.FileStorageService;
import com.axsos.project.services.ProductService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
@RequestMapping("/store/products")
public class ProductPageController {
	@Autowired
	private ProductService productService;

	@Autowired
	private CommentService commentService;

	@Autowired
	private FileStorageService fileStorageService;

	// GET /store/products - "Products (Store Owner)" grid: thumbnails + "+ Add" tile
	@GetMapping
	public String listProducts(HttpSession session, Model model) {
		Store store = requireStore(session);
		if (store == null) {
			return "redirect:/auth";
		}
		List<ProductDTO> products = productService.getProductsForStore(store.getId());
		model.addAttribute("store", store);
		model.addAttribute("products", products);
		return "store/products";
	}

	// GET /store/products/add - blank "Add Product" form
	@GetMapping("/add")
	public String showAddForm(HttpSession session, Model model) {
		if (requireStore(session) == null) {
			return "redirect:/auth";
		}
		model.addAttribute("productForm", new ProductPageForm());
		return "store/product-add";
	}

	// POST /store/products/add - creates the product, then goes back to the products grid
	@PostMapping("/add")
	public String createProduct(@Valid @ModelAttribute("productForm") ProductPageForm form,
			BindingResult bindingResult, HttpSession session, Model model) {
		Store store = requireStore(session);
		if (store == null) {
			return "redirect:/auth";
		}
		if (bindingResult.hasErrors()) {
			model.addAttribute("errorMessage", firstError(bindingResult));
			return "store/product-add";
		}
		String imageUrl = fileStorageService.store(form.getImageFile(), "products");
		productService.createProductFromPage(form, store, imageUrl);
		return "redirect:/store/products";
	}

	// GET /store/products/{id}/edit - "Edit Product" page: current image/info + this product's comments
	@GetMapping("/{id}/edit")
	public String showEditForm(@PathVariable Long id, HttpSession session, Model model) {
		Store store = requireStore(session);
		if (store == null) {
			return "redirect:/auth";
		}
		Optional<Product> ownedProduct = productService.getOwnedProduct(id, store.getId());
		if (ownedProduct.isEmpty()) {
			return "redirect:/store/products";
		}
		Product product = ownedProduct.get();

		ProductPageForm form = new ProductPageForm();
		form.setProductName(product.getProductName());
		form.setDescription(product.getDescription());
		form.setPrice(product.getPrice());
		form.setQuantity(product.getQuantity());

		model.addAttribute("product", product);
		model.addAttribute("productForm", form);
		model.addAttribute("comments", commentService.getCommentsForProduct(id));
		return "store/product-edit";
	}

	// POST /store/products/{id}/edit - saves the changes
	@PostMapping("/{id}/edit")
	public String updateProduct(@PathVariable Long id, @Valid @ModelAttribute("productForm") ProductPageForm form,
			BindingResult bindingResult, HttpSession session, Model model) {
		Store store = requireStore(session);
		if (store == null) {
			return "redirect:/auth";
		}
		if (bindingResult.hasErrors()) {
			// need the product + comments again to re-render the page
			Optional<Product> ownedProduct = productService.getOwnedProduct(id, store.getId());
			if (ownedProduct.isEmpty()) {
				return "redirect:/store/products";
			}
			model.addAttribute("product", ownedProduct.get());
			model.addAttribute("comments", commentService.getCommentsForProduct(id));
			model.addAttribute("errorMessage", firstError(bindingResult));
			return "store/product-edit";
		}

		String imageUrl = fileStorageService.store(form.getImageFile(), "products"); // null if no new file picked
		Optional<Product> updated = productService.updateProductFromPage(id, form, store.getId(), imageUrl);
		if (updated.isEmpty()) {
			return "redirect:/store/products";
		}
		return "redirect:/store/products";
	}

	// POST /store/products/{id}/delete - simple delete action from the edit page
	@PostMapping("/{id}/delete")
	public String deleteProduct(@PathVariable Long id, HttpSession session) {
		Store store = requireStore(session);
		if (store == null) {
			return "redirect:/auth";
		}
		productService.deleteProduct(id, store.getId());
		return "redirect:/store/products";
	}

	private String firstError(BindingResult bindingResult) {
		return bindingResult.getFieldErrors().stream()
				.findFirst()
				.map(e -> e.getDefaultMessage())
				.orElse("Please check the form and try again");
	}

	private Store requireStore(HttpSession session) {
		return (Store) session.getAttribute("loggedInStore");
	}
}
