package com.axsos.project.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.axsos.project.models.Customer;

import jakarta.servlet.http.HttpSession;


@Controller
public class CustomerController {
	@GetMapping("/customer/dashboard")
    public String dashboard(HttpSession session, Model model) {

        // check if a customer is logged in by looking at the session
        Customer customer = (Customer) session.getAttribute("loggedInCustomer");

        if (customer == null) {
            return "redirect:/auth";
        }

        model.addAttribute("customer", customer);
        return "customer/dashboard";
    }
}
