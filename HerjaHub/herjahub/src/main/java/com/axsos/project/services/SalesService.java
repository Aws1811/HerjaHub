package com.axsos.project.services;

import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

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

	// builds the data the store-owner dashboard chart needs: one point per month with sales,
	// plus a few summary totals for the tiles above the chart
	public SalesSummaryDTO getSalesSummary(Long storeId) {
		List<Object[]> rows = orderItemRepository.findMonthlySalesByStoreId(storeId);

		List<SalesPointDTO> chart = rows.stream()
				.map(row -> {
					String yearMonth = (String) row[0];
					Double total = ((Number) row[1]).doubleValue();
					return new SalesPointDTO(formatMonthLabel(yearMonth), total);
				})
				.collect(Collectors.toList());

		Double totalRevenue = orderItemRepository.sumRevenueByStoreId(storeId);
		Long totalUnitsSold = orderItemRepository.sumQuantityByStoreId(storeId);
		long totalProducts = productRepository.findByStoreIdOrderByCreatedAtDesc(storeId).size();

		return new SalesSummaryDTO(chart, totalRevenue, totalUnitsSold, totalProducts);
	}

	// turns "2026-07" into "Jul 2026" for the chart x-axis
	private String formatMonthLabel(String yearMonth) {
		try {
			YearMonth ym = YearMonth.parse(yearMonth, DateTimeFormatter.ofPattern("yyyy-MM"));
			String month = ym.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
			return month + " " + ym.getYear();
		} catch (Exception e) {
			return yearMonth;
		}
	}
}
