package com.axsos.project.repositores;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.axsos.project.models.Comment;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {

	// comments left on a single product (shown on the Edit Product page)
	List<Comment> findByProductIdOrderByCreatedAtDesc(Long productId);

	// every comment across all of a store's products (shown on the Edit Store page)
	List<Comment> findByProduct_Store_IdOrderByCreatedAtDesc(Long storeId);

	// average star rating for a product (0 if it has no reviews yet) - used on the product detail page
	@Query("SELECT COALESCE(AVG(c.rating), 0.0) FROM Comment c WHERE c.product.id = :productId")
	Double avgRatingByProductId(@Param("productId") Long productId);

	long countByProductId(Long productId);
}
