package com.axsos.project.repositores;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.axsos.project.models.Comment;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
	// findAll() and findById() already come from JpaRepository
}
