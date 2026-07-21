package com.axsos.project.controllers;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;

// Spring Boot's built-in "error/<status>" auto-detection only checks template engines
// (Thymeleaf, FreeMarker, etc.) and static HTML files - it never looks at WEB-INF JSPs.
// So for a JSP-only app like this one, that convention silently does nothing, and every
// error (404, 403, 401, ...) was falling through to the generic Whitelabel Error Page.
//
// This controller replaces that: Spring Boot only auto-creates its default
// BasicErrorController when no other ErrorController bean exists, so this one bean
// takes over entirely, and returns the exact same JSP view names ("error/404" etc.)
// used everywhere else in the app - resolved by the same
// spring.mvc.view.prefix/suffix as every other page, no extra config needed.
@Controller
public class ErrorPageController implements ErrorController {

	@RequestMapping("/error")
	public String handleError(HttpServletRequest request, Model model) {

		Object statusAttr = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
		int status = (statusAttr != null) ? Integer.parseInt(statusAttr.toString()) : 500;

		Object pathAttr = request.getAttribute(RequestDispatcher.ERROR_REQUEST_URI);
		model.addAttribute("path", pathAttr != null ? pathAttr.toString() : "");

		if (status == 401) {
			return "error/401";
		}
		if (status == 403) {
			return "error/403";
		}
		if (status == 404) {
			return "error/404";
		}

		// anything else (500, etc.) - no dedicated page yet, the 404 page's
		// "something's not right" framing still reads fine as a generic fallback
		return "error/404";
	}
}
