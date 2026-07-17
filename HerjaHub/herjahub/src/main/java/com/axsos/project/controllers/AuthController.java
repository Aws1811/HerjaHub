package com.axsos.project.controllers;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.axsos.project.dto.LoginForm;
import com.axsos.project.dto.RegistrationForm;
import com.axsos.project.models.Customer;
import com.axsos.project.models.Store;
import com.axsos.project.services.CustomerService;
import com.axsos.project.services.StoreService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class AuthController {
    @Autowired
    private CustomerService customerService;

    @Autowired
    private StoreService storeService;

    // Shows the login/register page
    @GetMapping({"/", "/auth"})
    public String showAuthPage(Model model) {
        model.addAttribute("loginForm", new LoginForm());
        model.addAttribute("registrationForm", new RegistrationForm());
        model.addAttribute("showRegister", false);
        return "auth";
    }

    // Handles the login form submit
    @PostMapping("/login")
    public String login(@Valid @ModelAttribute("loginForm") LoginForm loginForm,
                        BindingResult bindingResult,
                        HttpSession session,
                        Model model) {

        // if the basic fields (email/password not blank) already failed, just show the page again
        if (bindingResult.hasErrors()) {
            model.addAttribute("registrationForm", new RegistrationForm());
            model.addAttribute("showRegister", false);
            return "auth";
        }

        // check which account type was selected and log in against the right table
        if (loginForm.getLoginType().equals("store")) {

            Optional<Store> storeOpt = storeService.login(loginForm.getEmail(), loginForm.getPassword());

            if (storeOpt.isPresent()) {
                session.setAttribute("loggedInStore", storeOpt.get());
                return "redirect:/store/dashboard";
            } else {
                model.addAttribute("loginError", "Invalid email or password");
            }

        } else {

            Optional<Customer> customerOpt = customerService.login(loginForm.getEmail(), loginForm.getPassword());

            if (customerOpt.isPresent()) {
                session.setAttribute("loggedInCustomer", customerOpt.get());
                return "redirect:/customer/dashboard";
            } else {
                model.addAttribute("loginError", "Invalid email or password");
            }
        }

        // login failed - show the page again with the error message
        model.addAttribute("registrationForm", new RegistrationForm());
        model.addAttribute("showRegister", false);
        return "auth";
    }

    // Handles the register form submit
    @PostMapping("/register")
    public String register(@Valid @ModelAttribute("registrationForm") RegistrationForm form,
                           BindingResult bindingResult,
                           HttpSession session,
                           Model model) {

        boolean isStoreOwner = form.getAccountType().equals("store");

        // passwords must match
        if (!form.getPassword().equals(form.getConfirmPassword())) {
            bindingResult.rejectValue("confirmPassword", "error", "Passwords do not match");
        }

        // store owners must also fill in store name, phone and address
        if (isStoreOwner) {
            if (form.getStoreName() == null || form.getStoreName().isBlank()) {
                bindingResult.rejectValue("storeName", "error", "Store name is required");
            }
            if (form.getPhone() == null || form.getPhone().isBlank()) {
                bindingResult.rejectValue("phone", "error", "Phone number is required");
            }
            if (form.getAddress() == null || form.getAddress().isBlank()) {
                bindingResult.rejectValue("address", "error", "Address is required");
            }
        }

        // email must not already be used
        if (isStoreOwner && storeService.emailExists(form.getEmail())) {
            bindingResult.rejectValue("email", "error", "This email is already registered");
        }
        if (!isStoreOwner && customerService.emailExists(form.getEmail())) {
            bindingResult.rejectValue("email", "error", "This email is already registered");
        }

        // if anything failed, show the register page again with the errors
        if (bindingResult.hasErrors()) {
            model.addAttribute("loginForm", new LoginForm());
            model.addAttribute("showRegister", true);
            return "auth";
        }

        // everything is valid - save the new account and log them straight in
        if (isStoreOwner) {
            Store store = storeService.registerStore(form);
            session.setAttribute("loggedInStore", store);
            return "redirect:/store/dashboard";
        } else {
            Customer customer = customerService.registerCustomer(form);
            session.setAttribute("loggedInCustomer", customer);
            return "redirect:/customer/dashboard";
        }
    }

    // Logs the user out
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}