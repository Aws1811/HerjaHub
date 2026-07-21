package com.axsos.project.config;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// Guards /customer/** and /store/** in two ways:
//   1. Wrong role - logged in, just not as the kind of account this area is for
//      (e.g. a store owner clicking their way into a /customer/... link) -> 403.
//   2. Not logged in at all -> 401, so hitting a protected route directly (typed URL,
//      bookmark, expired session) shows the real error page instead of silently
//      redirecting to login.
// REST endpoints under /store/api/** are excluded (see WebConfig) since those already
// return their own JSON 401 responses for the JS/fetch calls that consume them - this
// interceptor rendering an HTML error page there would break that JS.
@Component
public class RoleAccessInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws IOException {

		String path = request.getRequestURI();
		String contextPath = request.getContextPath();
		HttpSession session = request.getSession(false);

		boolean isCustomerLoggedIn = session != null && session.getAttribute("loggedInCustomer") != null;
		boolean isStoreLoggedIn = session != null && session.getAttribute("loggedInStore") != null;

		boolean isStoreArea = path.startsWith(contextPath + "/store/");
		boolean isCustomerArea = path.startsWith(contextPath + "/customer/");

		// wrong role entirely
		if (isStoreArea && isCustomerLoggedIn && !isStoreLoggedIn) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "This area is for store owners only.");
			return false;
		}
		if (isCustomerArea && isStoreLoggedIn && !isCustomerLoggedIn) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "This area is for customers only.");
			return false;
		}

		// not logged in at all
		if ((isStoreArea && !isStoreLoggedIn) || (isCustomerArea && !isCustomerLoggedIn)) {
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "You need to be signed in to view this page.");
			return false;
		}

		return true;
	}
}
