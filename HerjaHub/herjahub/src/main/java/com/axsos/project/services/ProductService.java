package com.axsos.project.services;

import java.util.List;
import java.util.Optional;

import com.axsos.project.models.Store;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.models.Product;
import com.axsos.project.repositores.ProductRepository;

@Service
public class ProductService {
	@Autowired
	private ProductRepository productRepository;

	// all products, used to fill the Products page grid
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
	// all products belonging to one store, used on the Store Owner Dashboard
	public List<Product> getProductsByStore(Store store) {
		return productRepository.findByStore(store);
	}

	// copies the edited fields onto the real, already-saved product and
	// saves it - same "fetch, copy fields, save" pattern as CustomerService.updateProfile
	public Product updateProduct(Product existingProduct, Product formValues) {
		existingProduct.setProductName(formValues.getProductName());
		existingProduct.setDescription(formValues.getDescription());
		existingProduct.setPrice(formValues.getPrice());
		existingProduct.setImage(formValues.getImage());
		existingProduct.setQuantity(formValues.getQuantity());
		return productRepository.save(existingProduct);
	}

}
