package com.axsos.project.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.models.Comment;
import com.axsos.project.repositores.CommentRepository;

@Service
public class CommentService {
	@Autowired
	private CommentRepository commentRepository;

	// saves a new comment (rating + text) left by a customer on a product
	public Comment addComment(Comment comment) {
		return commentRepository.save(comment);
	}
}
