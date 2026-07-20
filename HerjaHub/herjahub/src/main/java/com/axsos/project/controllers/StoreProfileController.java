package com.axsos.project.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.axsos.project.dto.MessageResponse;
import com.axsos.project.dto.StoreProfileDTO;
import com.axsos.project.dto.StoreProfileForm;
import com.axsos.project.models.Store;
import com.axsos.project.services.StoreService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/store/api/profile")
public class StoreProfileController {
	@Autowired
	private StoreService storeService;

	// GET /store/api/profile - the logged in store's own profile (never returns the password)
	@GetMapping
	public ResponseEntity<?> getProfile(HttpSession session) {
		Store store = getLoggedInStore(session);
		if (store == null) {
			return unauthorized();
		}
		return ResponseEntity.ok(new StoreProfileDTO(store));
	}

	// PUT /store/api/profile - update the editable profile fields
	@PutMapping
	public ResponseEntity<?> updateProfile(@Valid @RequestBody StoreProfileForm form, BindingResult bindingResult,
			HttpSession session) {
		Store store = getLoggedInStore(session);
		if (store == null) {
			return unauthorized();
		}
		if (bindingResult.hasErrors()) {
			return ResponseEntity.badRequest().body(new MessageResponse(firstError(bindingResult)));
		}

		// an optional password change can ride along with the profile update
		if (form.getNewPassword() != null && !form.getNewPassword().isBlank()) {
			if (form.getCurrentPassword() == null || form.getCurrentPassword().isBlank()) {
				return ResponseEntity.badRequest()
						.body(new MessageResponse("Enter your current password to set a new one"));
			}
			if (form.getNewPassword().length() < 8) {
				return ResponseEntity.badRequest()
						.body(new MessageResponse("New password must be at least 8 characters"));
			}
			boolean changed = storeService.changePassword(store, form.getCurrentPassword(), form.getNewPassword());
			if (!changed) {
				return ResponseEntity.badRequest().body(new MessageResponse("Current password is incorrect"));
			}
		}

		Store updated = storeService.updateProfile(store, form);
		session.setAttribute("loggedInStore", updated); // keep the session copy in sync
		return ResponseEntity.ok(new StoreProfileDTO(updated));
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
