package com.axsos.project.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.axsos.project.dto.MessageResponse;
import com.axsos.project.dto.SalesSummaryDTO;
import com.axsos.project.models.Store;
import com.axsos.project.services.SalesService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/store/api/sales")
public class SalesController {
	@Autowired
	private SalesService salesService;

	// GET /store/api/sales - daily revenue points for the chart, plus summary totals for the tiles
	@GetMapping
	public ResponseEntity<?> getSales(HttpSession session) {
		Store store = (Store) session.getAttribute("loggedInStore");
		if (store == null) {
			return ResponseEntity.status(401).body(new MessageResponse("You must be logged in as a store owner"));
		}
		SalesSummaryDTO summary = salesService.getSalesSummary(store.getId());
		return ResponseEntity.ok(summary);
	}
}
