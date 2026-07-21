package com.axsos.project.config;

import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.FlashMapManager;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class UploadSizeExceptionResolver implements HandlerExceptionResolver{
	@Override
	public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler,
			Exception ex) {
		if (!(ex instanceof MaxUploadSizeExceededException)) {
			return null; // not ours - let the next resolver in the chain handle it
		}

		String targetPath = request.getRequestURI();

		FlashMap flashMap = new FlashMap();
		flashMap.put("errorMessage",
				"That image is too large to upload (max 15MB). Please choose a smaller file and try again.");

		FlashMapManager flashMapManager = RequestContextUtils.getFlashMapManager(request);
		if (flashMapManager != null) {
			flashMapManager.saveOutputFlashMap(flashMap, request, response);
		}

		return new ModelAndView("redirect:" + targetPath);
	}
}
