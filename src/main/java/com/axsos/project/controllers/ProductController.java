package com.axsos.project.controllers;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.axsos.project.dto.MessageResponse;
import com.axsos.project.dto.ProductDTO;
import com.axsos.project.dto.ProductForm;
import com.axsos.project.models.Store;
import com.axsos.project.services.ProductService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/store/api/products")
public class ProductController {
	@Autowired
	private ProductService productService;

	// GET /store/api/products - list every product belonging to the logged in store,
	// each one annotated with its units-sold / revenue so the dashboard cards can show them
	@GetMapping
	public ResponseEntity<?> listProducts(HttpSession session) {
		Store store = getLoggedInStore(session);
		if (store == null) {
			return unauthorized();
		}
		List<ProductDTO> products = productService.getProductsForStore(store.getId());
		return ResponseEntity.ok(products);
	}

	// POST /store/api/products - create a new product for the logged in store
	@PostMapping
	public ResponseEntity<?> createProduct(@Valid @RequestBody ProductForm form, BindingResult bindingResult,
			HttpSession session) {
		Store store = getLoggedInStore(session);
		if (store == null) {
			return unauthorized();
		}
		if (bindingResult.hasErrors()) {
			return ResponseEntity.badRequest().body(new MessageResponse(firstError(bindingResult)));
		}
		ProductDTO created = productService.createProduct(form, store);
		return ResponseEntity.ok(created);
	}

	// PUT /store/api/products/{id} - update a product, but only if it belongs to this store
	@PutMapping("/{id}")
	public ResponseEntity<?> updateProduct(@PathVariable Long id, @Valid @RequestBody ProductForm form,
			BindingResult bindingResult, HttpSession session) {
		Store store = getLoggedInStore(session);
		if (store == null) {
			return unauthorized();
		}
		if (bindingResult.hasErrors()) {
			return ResponseEntity.badRequest().body(new MessageResponse(firstError(bindingResult)));
		}
		Optional<ProductDTO> updated = productService.updateProduct(id, form, store.getId());
		if (updated.isEmpty()) {
			return ResponseEntity.status(404).body(new MessageResponse("Product not found"));
		}
		return ResponseEntity.ok(updated.get());
	}

	// DELETE /store/api/products/{id} - delete a product, but only if it belongs to this store
	@DeleteMapping("/{id}")
	public ResponseEntity<?> deleteProduct(@PathVariable Long id, HttpSession session) {
		Store store = getLoggedInStore(session);
		if (store == null) {
			return unauthorized();
		}
		boolean deleted = productService.deleteProduct(id, store.getId());
		if (!deleted) {
			return ResponseEntity.status(404).body(new MessageResponse("Product not found"));
		}
		return ResponseEntity.ok(new MessageResponse("Product deleted"));
	}

	private Store getLoggedInStore(HttpSession session) {
		return (Store) session.getAttribute("loggedInStore");
	}

	private ResponseEntity<?> unauthorized() {
		return ResponseEntity.status(401).body(new MessageResponse("You must be logged in as a store owner"));
	}

	private String firstError(BindingResult bindingResult) {
		return bindingResult.getFieldErrors().stream()
				.findFirst()
				.map(e -> e.getDefaultMessage())
				.orElse("Invalid input");
	}
}
