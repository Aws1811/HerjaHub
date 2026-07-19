package com.axsos.project.dto;

import java.util.List;

public class SalesSummaryDTO {
	private List<SalesPointDTO> chart;
	private Double totalRevenue;
	private Long totalUnitsSold;
	private long totalProducts;

	public SalesSummaryDTO() {
	}

	public SalesSummaryDTO(List<SalesPointDTO> chart, Double totalRevenue, Long totalUnitsSold,
			long totalProducts) {
		this.chart = chart;
		this.totalRevenue = totalRevenue;
		this.totalUnitsSold = totalUnitsSold;
		this.totalProducts = totalProducts;
	}

	public List<SalesPointDTO> getChart() {
		return chart;
	}

	public void setChart(List<SalesPointDTO> chart) {
		this.chart = chart;
	}

	public Double getTotalRevenue() {
		return totalRevenue;
	}

	public void setTotalRevenue(Double totalRevenue) {
		this.totalRevenue = totalRevenue;
	}

	public Long getTotalUnitsSold() {
		return totalUnitsSold;
	}

	public void setTotalUnitsSold(Long totalUnitsSold) {
		this.totalUnitsSold = totalUnitsSold;
	}

	public long getTotalProducts() {
		return totalProducts;
	}

	public void setTotalProducts(long totalProducts) {
		this.totalProducts = totalProducts;
	}
}
