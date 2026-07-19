package com.axsos.project.repositores;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.axsos.project.models.Store;

@Repository
public interface StoreRepository extends JpaRepository<Store, Long> {
	 Optional<Store> findByEmail(String email);

	    boolean existsByEmail(String email);

	    // loads the store together with its products already initialized, so views
	    // (e.g. the Edit Store page's fn:length(store.products)) never hit a
	    // LazyInitializationException, even though "products" is lazy-fetched.
	    @Query("SELECT DISTINCT s FROM Store s LEFT JOIN FETCH s.products WHERE s.id = :id")
	    Optional<Store> findByIdWithProducts(@Param("id") Long id);
}
