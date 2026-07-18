package com.axsos.project.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.models.Product;
import com.axsos.project.repositores.ProductRepository;

@Service
public class ProductService {
	@Autowired
	private ProductRepository productRepository;

	// all products, used to fill the Products page grids
	public List<Product> getAllProducts() {
		return productRepository.findAll();
	}

	// one product by id, used on the Product Details page
	public Optional<Product> getProductById(Long id) {
		return productRepository.findById(id);
	}

	// saves a new product for a store owner (used by the Add Product page)
	public Product createProduct(Product product) {
		return productRepository.save(product);
	}
}
