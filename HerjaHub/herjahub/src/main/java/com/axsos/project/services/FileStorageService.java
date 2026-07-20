package com.axsos.project.services;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class FileStorageService {

	// files are written next to where the app runs (./uploads/...) and served back
	// via the resource handler registered in WebConfig at /uploads/**
	private static final String UPLOAD_ROOT = "uploads";

	/**
	 * Saves the file under uploads/{subfolder}/ with a random name (keeps the
	 * original extension) and returns the public path to store on the entity,
	 * e.g. "/uploads/products/3f9c2b-photo.jpg".
	 */
	public String store(MultipartFile file, String subfolder) {
		if (file == null || file.isEmpty()) {
			return null;
		}
		try {
			Path dir = Paths.get(UPLOAD_ROOT, subfolder);
			Files.createDirectories(dir);

			String original = file.getOriginalFilename() != null ? file.getOriginalFilename() : "upload";
			String safeName = original.replaceAll("[^a-zA-Z0-9._-]", "_");
			String fileName = UUID.randomUUID().toString().substring(0, 8) + "-" + safeName;

			Path target = dir.resolve(fileName);
			Files.copy(file.getInputStream(), target);

			return "/" + UPLOAD_ROOT + "/" + subfolder + "/" + fileName;
		} catch (IOException e) {
			throw new RuntimeException("Failed to store uploaded file", e);
		}
	}
}
