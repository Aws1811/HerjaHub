package com.axsos.project.repositores;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.axsos.project.models.Product;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
	List<Product> findByStoreIdOrderByCreatedAtDesc(Long storeId);

	// used for ownership checks (product must belong to the logged in store)
	long countByIdAndStoreId(Long id, Long storeId);

	// customer-facing marketplace listing - store is fetched eagerly so the
	// product cards can show the store name without a LazyInitializationException
	@Query("SELECT p FROM Product p JOIN FETCH p.store ORDER BY p.createdAt DESC")
	List<Product> findAllWithStoreOrderByCreatedAtDesc();

	// single product with its store already loaded - used by the product detail page
	@Query("SELECT p FROM Product p JOIN FETCH p.store WHERE p.id = :id")
	Optional<Product> findByIdWithStore(@Param("id") Long id);
}
