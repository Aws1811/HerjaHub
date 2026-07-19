package com.axsos.project.services;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.dto.CommentDTO;
import com.axsos.project.models.Comment;
import com.axsos.project.models.Customer;
import com.axsos.project.models.Product;
import com.axsos.project.repositores.CommentRepository;
import com.axsos.project.repositores.ProductRepository;


@Service
public class CommentService {
	@Autowired
	private CommentRepository commentRepository;

	@Autowired
	private ProductRepository productRepository;

	// comments for a single product - shown on the Edit Product page
	public List<CommentDTO> getCommentsForProduct(Long productId) {
		return commentRepository.findByProductIdOrderByCreatedAtDesc(productId).stream()
				.map(CommentDTO::new)
				.collect(Collectors.toList());
	}

	// every comment across all of a store's products - shown on the Edit Store page
	public List<CommentDTO> getCommentsForStore(Long storeId) {
		return commentRepository.findByProduct_Store_IdOrderByCreatedAtDesc(storeId).stream()
				.map(CommentDTO::new)
				.collect(Collectors.toList());
	}

	// most recent reviews across all of a store's products, capped to "limit" -
	// shown in the "Recent Reviews" widget on the store dashboard
	public List<CommentDTO> getRecentReviewsForStore(Long storeId, int limit) {
		return commentRepository.findByProduct_Store_IdOrderByCreatedAtDesc(storeId).stream()
				.limit(limit)
				.map(CommentDTO::new)
				.collect(Collectors.toList());
	}

	// lets a logged-in customer leave a rating + review on a product
	public Optional<CommentDTO> addComment(Long productId, Customer customer, Integer rating, String text) {
		Optional<Product> productOpt = productRepository.findById(productId);
		if (productOpt.isEmpty()) {
			return Optional.empty();
		}
		Comment comment = new Comment(rating, text, customer, productOpt.get());
		Comment saved = commentRepository.save(comment);
		return Optional.of(new CommentDTO(saved));
	}

	// average rating (0 if none yet) and review count for a single product - shown on the product detail page
	public Double getAverageRating(Long productId) {
		return commentRepository.avgRatingByProductId(productId);
	}

	public long getReviewCount(Long productId) {
		return commentRepository.countByProductId(productId);
	}
}
