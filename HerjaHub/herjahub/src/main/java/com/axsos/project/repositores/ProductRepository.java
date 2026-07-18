package com.axsos.project.repositores;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.axsos.project.models.Product;

@Repository
public interface ProductRepository extends CrudRepository<Product, Long> {
    List<Product> findAll();
    // Get products that are still available.
    List<Product> findByQuantityGreaterThan(Integer quantity);
}