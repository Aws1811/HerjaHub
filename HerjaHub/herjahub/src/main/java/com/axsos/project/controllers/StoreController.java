package com.axsos.project.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.axsos.project.models.Store;

import jakarta.servlet.http.HttpSession;


@Controller
public class StoreController {
	
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
}
