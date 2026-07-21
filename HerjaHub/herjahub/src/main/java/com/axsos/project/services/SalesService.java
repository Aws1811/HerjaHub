package com.axsos.project.services;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.dto.SalesPointDTO;
import com.axsos.project.dto.SalesSummaryDTO;
import com.axsos.project.repositores.OrderItemRepository;
import com.axsos.project.repositores.ProductRepository;


@Service
public class SalesService {
	@Autowired
	private OrderItemRepository orderItemRepository;

	@Autowired
	private ProductRepository productRepository;

	// how many trailing days the dashboard chart shows
	private static final int CHART_DAYS = 30;

	// builds the data the store-owner dashboard chart needs: one point per day
	// (today and the 29 days before it) with sales, plus a few summary totals
	// for the tiles above the chart. Days with no orders still get a point with
	// $0 revenue so the line doesn't just skip over quiet days.
	public SalesSummaryDTO getSalesSummary(Long storeId) {
		LocalDate today = LocalDate.now();
		LocalDate firstDay = today.minusDays(CHART_DAYS - 1);
		LocalDateTime since = firstDay.atStartOfDay();

		List<Object[]> rows = orderItemRepository.findDailySalesByStoreId(storeId, since);

		Map<String, Double> revenueByDay = new HashMap<>();
		for (Object[] row : rows) {
			String day = (String) row[0];
			Double total = ((Number) row[1]).doubleValue();
			revenueByDay.put(day, total);
		}

		DateTimeFormatter dbFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		List<SalesPointDTO> chart = new ArrayList<>();
		for (int i = 0; i < CHART_DAYS; i++) {
			LocalDate day = firstDay.plusDays(i);
			String key = day.format(dbFormat);
			Double total = revenueByDay.getOrDefault(key, 0.0);
			chart.add(new SalesPointDTO(formatDayLabel(day), total));
		}

		Double totalRevenue = orderItemRepository.sumRevenueByStoreId(storeId);
		Long totalUnitsSold = orderItemRepository.sumQuantityByStoreId(storeId);
		long totalProducts = productRepository.findByStoreIdOrderByCreatedAtDesc(storeId).size();

		return new SalesSummaryDTO(chart, totalRevenue, totalUnitsSold, totalProducts);
	}

	// turns a LocalDate into "Jul 21" for the chart x-axis
	private String formatDayLabel(LocalDate day) {
		return day.format(DateTimeFormatter.ofPattern("MMM d"));
	}
}
