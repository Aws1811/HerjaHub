package com.axsos.project.dto;

public class SalesPointDTO {
	private String label; // e.g. "Jan 2026"
	private Double total; // revenue for that period

	public SalesPointDTO() {
	}

	public SalesPointDTO(String label, Double total) {
		this.label = label;
		this.total = total;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public Double getTotal() {
		return total;
	}

	public void setTotal(Double total) {
		this.total = total;
	}
}
