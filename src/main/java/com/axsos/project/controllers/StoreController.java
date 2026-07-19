package com.axsos.project.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.axsos.project.dto.SalesSummaryDTO;
import com.axsos.project.models.Store;
import com.axsos.project.services.CommentService;
import com.axsos.project.services.ProductService;
import com.axsos.project.services.SalesService;

import jakarta.servlet.http.HttpSession;


@Controller
public class StoreController {
	@Autowired
	private SalesService salesService;

	@Autowired
	private ProductService productService;

	@Autowired
	private CommentService commentService;

	@GetMapping("/store/dashboard")
    public String dashboard(HttpSession session, Model model) {

        // check if a store owner is logged in by looking at the session
        Store store = (Store) session.getAttribute("loggedInStore");

        if (store == null) {
            return "redirect:/auth";
        }

        SalesSummaryDTO sales = salesService.getSalesSummary(store.getId());

        model.addAttribute("store", store);
        model.addAttribute("sales", sales);
        // these two were previously never added to the model, so the "Low Stock"
        // and "Recent Reviews" panels always rendered their empty state
        model.addAttribute("lowStockProducts", productService.getLowStockProducts(store.getId()));
        model.addAttribute("recentReviews", commentService.getRecentReviewsForStore(store.getId(), 5));
        return "store/dashboard";
    }
}
