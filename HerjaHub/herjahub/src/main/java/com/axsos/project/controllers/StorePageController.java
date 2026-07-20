package com.axsos.project.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.axsos.project.dto.StorePageForm;
import com.axsos.project.models.Store;
import com.axsos.project.services.CommentService;
import com.axsos.project.services.FileStorageService;
import com.axsos.project.services.StoreService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
@RequestMapping("/store/edit")
public class StorePageController {

	@Autowired
	private StoreService storeService;

	@Autowired
	private CommentService commentService;

	@Autowired
	private FileStorageService fileStorageService;

	// GET /store/edit - "Edit Store" page: logo + store info + comments from all products
	@GetMapping
	public String showEditForm(HttpSession session, Model model) {
		Store store = requireStore(session);
		if (store == null) {
			return "redirect:/auth";
		}

		// the session copy of the store has a lazy "products" collection with no
		// active Hibernate session behind it - reload it here (with products
		// eagerly fetched) so the view can safely call fn:length(store.products)
		Store storeWithProducts = storeService.findByIdWithProducts(store.getId());

		StorePageForm form = new StorePageForm();
		form.setFirstName(storeWithProducts.getFirstName());
		form.setLastName(storeWithProducts.getLastName());
		form.setStoreName(storeWithProducts.getStoreName());
		form.setDescription(storeWithProducts.getDescription());
		form.setPhone(storeWithProducts.getPhone());
		form.setAddress(storeWithProducts.getAddress());

		model.addAttribute("store", storeWithProducts);
		model.addAttribute("storeForm", form);
		model.addAttribute("comments", commentService.getCommentsForStore(store.getId()));
		return "store/edit";
	}

	// POST /store/edit - saves the store profile (+ optional password change, + optional logo upload)
	@PostMapping
	public String updateStore(@Valid @ModelAttribute("storeForm") StorePageForm form, BindingResult bindingResult,
			HttpSession session, Model model) {
		Store store = requireStore(session);
		if (store == null) {
			return "redirect:/auth";
		}

		boolean changingPassword = form.getNewPassword() != null && !form.getNewPassword().isBlank();

		if (changingPassword && (form.getCurrentPassword() == null || form.getCurrentPassword().isBlank())) {
			bindingResult.rejectValue("currentPassword", "error", "Enter your current password to set a new one");
		}
		if (changingPassword && form.getNewPassword().length() < 8) {
			bindingResult.rejectValue("newPassword", "error", "New password must be at least 8 characters");
		}

		if (bindingResult.hasErrors()) {
			model.addAttribute("store", storeService.findByIdWithProducts(store.getId()));
			model.addAttribute("comments", commentService.getCommentsForStore(store.getId()));
			model.addAttribute("errorMessage", firstError(bindingResult));
			return "store/edit";
		}

		if (changingPassword) {
			boolean changed = storeService.changePassword(store, form.getCurrentPassword(), form.getNewPassword());
			if (!changed) {
				bindingResult.rejectValue("currentPassword", "error", "Current password is incorrect");
				model.addAttribute("store", storeService.findByIdWithProducts(store.getId()));
				model.addAttribute("comments", commentService.getCommentsForStore(store.getId()));
				model.addAttribute("errorMessage", "Current password is incorrect");
				return "store/edit";
			}
		}

		String imageUrl = fileStorageService.store(form.getLogoFile(), "stores"); // null if no new logo picked
		Store updated = storeService.updateProfileFromPage(store, form, imageUrl);
		session.setAttribute("loggedInStore", updated); // keep the session copy in sync

		return "redirect:/store/edit";
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
