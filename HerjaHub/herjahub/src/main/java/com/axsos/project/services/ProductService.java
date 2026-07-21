package com.axsos.project.services;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.dto.ProductDTO;
import com.axsos.project.dto.ProductForm;
import com.axsos.project.dto.ProductPageForm;
import com.axsos.project.models.Product;
import com.axsos.project.models.Store;
import com.axsos.project.repositores.OrderItemRepository;
import com.axsos.project.repositores.ProductRepository;

@Service
public class ProductService {

	@Autowired
	private ProductRepository productRepository;

	@Autowired
	private OrderItemRepository orderItemRepository;

	// all products for a store, each with its units-sold / revenue attached
	public List<ProductDTO> getProductsForStore(Long storeId) {
		return productRepository.findByStoreIdOrderByCreatedAtDesc(storeId).stream()
				.map(this::toDTO)
				.collect(Collectors.toList());
	}

	// products that are in stock but at/below the low-stock threshold (same rule the
	// Products page badge uses: quantity > 0 and quantity <= 5), lowest quantity first,
	// used by the "Low Stock" widget on the dashboard
	public List<ProductDTO> getLowStockProducts(Long storeId) {
		return productRepository.findByStoreIdOrderByCreatedAtDesc(storeId).stream()
				.filter(p -> p.getQuantity() != null && p.getQuantity() > 0 && p.getQuantity() <= 5)
				.sorted((a, b) -> Integer.compare(a.getQuantity(), b.getQuantity()))
				.map(this::toDTO)
				.collect(Collectors.toList());
	}

	// every product from every store, newest first, in-stock items first -
	// the customer-facing marketplace listing
	public List<Product> getMarketplaceProducts() {
		return getMarketplaceProducts(null, null, null);
	}

	// same marketplace listing, but filtered by the search bar's "q" param -
	// blank/missing query just falls back to the full listing above
	public List<Product> getMarketplaceProducts(String query) {
		return getMarketplaceProducts(query, null, null);
	}

	// full marketplace listing used by both the page and its AJAX search/filter
	// endpoint: optional name search, optional min/max price range, and always
	// sorted with in-stock items first (out-of-stock ones sink to the bottom)
	// while keeping newest-first order within each group.
	public List<Product> getMarketplaceProducts(String query, Double minPrice, Double maxPrice) {
		List<Product> products = (query == null || query.isBlank())
				? productRepository.findAllWithStoreOrderByCreatedAtDesc()
				: productRepository.searchByNameWithStore(query.trim());

		return products.stream()
				.filter(p -> minPrice == null || (p.getPrice() != null && p.getPrice() >= minPrice))
				.filter(p -> maxPrice == null || (p.getPrice() != null && p.getPrice() <= maxPrice))
				.sorted(Comparator.comparing(this::isOutOfStock))
				.collect(Collectors.toList());
	}

	private boolean isOutOfStock(Product product) {
		return product.getQuantity() == null || product.getQuantity() <= 0;
	}

	// a single product with its store pre-loaded - used by the customer product detail page
	public Optional<Product> getProductWithStore(Long productId) {
		return productRepository.findByIdWithStore(productId);
	}

	// fetch a single product, but only if it belongs to this store (ownership check)
	public Optional<Product> getOwnedProduct(Long productId, Long storeId) {
		if (productRepository.countByIdAndStoreId(productId, storeId) == 0) {
			return Optional.empty();
		}
		return productRepository.findById(productId);
	}

	// simple "give me this one product" lookup - used by CustomerController when
	// adding a product to the cart. Kept as a thin passthrough so cart code
	// doesn't have to know about the "with store" variant above.
	public Optional<Product> getProductById(Long id) {
		return productRepository.findById(id);
	}

	// plain "give me every product" - kept for anywhere in the customer side
	// that just needs the raw list (older browse code, tests, etc.). New pages
	// should prefer getMarketplaceProducts() which pre-loads the store.
	public List<Product> getAllProducts() {
		return productRepository.findAll();
	}

	public ProductDTO createProduct(ProductForm form, Store store) {
		Product product = new Product();
		applyForm(product, form);
		product.setStore(store);
		Product saved = productRepository.save(product);
		return toDTO(saved);
	}

	public Optional<ProductDTO> updateProduct(Long productId, ProductForm form, Long storeId) {
		Optional<Product> ownedProduct = getOwnedProduct(productId, storeId);
		if (ownedProduct.isEmpty()) {
			return Optional.empty();
		}
		Product product = ownedProduct.get();
		applyForm(product, form);
		Product saved = productRepository.save(product);
		return Optional.of(toDTO(saved));
	}

	public boolean deleteProduct(Long productId, Long storeId) {
		Optional<Product> ownedProduct = getOwnedProduct(productId, storeId);
		if (ownedProduct.isEmpty()) {
			return false;
		}
		productRepository.delete(ownedProduct.get());
		return true;
	}

	// used by the Add Product page - imageUrl is whatever FileStorageService returned, or null if no file was picked
	public Product createProductFromPage(ProductPageForm form, Store store, String imageUrl) {
		Product product = new Product();
		product.setProductName(form.getProductName());
		product.setDescription(form.getDescription());
		product.setPrice(form.getPrice());
		product.setQuantity(form.getQuantity());
		product.setImage(imageUrl);
		product.setStore(store);
		return productRepository.save(product);
	}

	// used by the Edit Product page - pass imageUrl == null to keep the existing image
	public Optional<Product> updateProductFromPage(Long productId, ProductPageForm form, Long storeId,
			String imageUrl) {
		Optional<Product> ownedProduct = getOwnedProduct(productId, storeId);
		if (ownedProduct.isEmpty()) {
			return Optional.empty();
		}
		Product product = ownedProduct.get();
		product.setProductName(form.getProductName());
		product.setDescription(form.getDescription());
		product.setPrice(form.getPrice());
		product.setQuantity(form.getQuantity());
		if (imageUrl != null) {
			product.setImage(imageUrl);
		}
		return Optional.of(productRepository.save(product));
	}

	private void applyForm(Product product, ProductForm form) {
		product.setProductName(form.getProductName());
		product.setDescription(form.getDescription());
		product.setPrice(form.getPrice());
		product.setImage(form.getImage());
		product.setQuantity(form.getQuantity());
	}

	public ProductDTO toDTO(Product product) {
		Long unitsSold = orderItemRepository.sumQuantityByProductId(product.getId());
		Double revenue = orderItemRepository.sumRevenueByProductId(product.getId());
		return new ProductDTO(product.getId(), product.getProductName(), product.getDescription(),
				product.getPrice(), product.getImage(), product.getQuantity(), product.getCreatedAt(),
				unitsSold, revenue);
	}
}
