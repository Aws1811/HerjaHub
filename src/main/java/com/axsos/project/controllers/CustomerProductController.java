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
import org.springframework.web.bind.annotation.RequestMapping;

import com.axsos.project.dto.ReviewForm;
import com.axsos.project.models.Customer;
import com.axsos.project.models.Product;
import com.axsos.project.services.CommentService;
import com.axsos.project.services.ProductService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

// customer-facing marketplace: browse every store's products and leave reviews.
// this is what actually feeds the "Comments" panels the store owner sees on
// the Edit Store / Edit Product pages - previously there was no page anywhere
// in the app that let a customer create a comment in the first place.
@Controller
@RequestMapping("/customer/products")
public class CustomerProductController {

}
