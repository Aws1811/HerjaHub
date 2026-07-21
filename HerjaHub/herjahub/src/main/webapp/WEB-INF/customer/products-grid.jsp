<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%-- ===== Product grid fragment =====
     Rendered both as part of the full /customer/products page and, standalone,
     by GET /customer/products/grid for the AJAX search/price-filter to swap in. --%>
<c:choose>
    <c:when test="${empty products}">
        <div class="empty-state">
            <c:choose>
                <c:when test="${not empty q}">
                    <h3>No products found</h3>
                    <p class="muted">No results for "<c:out value="${q}" />" - try a different search.</p>
                </c:when>
                <c:otherwise>
                    <h3>No products yet</h3>
                    <p class="muted">Check back soon - artisans are adding their catalog.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </c:when>
    <c:otherwise>
        <div class="product-grid">
            <c:forEach var="product" items="${products}" varStatus="i">
                <div class="product-card ${product.quantity == null || product.quantity <= 0 ? 'is-out-of-stock' : ''}" style="animation-delay:${i.index * 0.04}s">
                    <a href="${pageContext.request.contextPath}/customer/products/${product.id}">
                        <div class="product-image-wrap">
                            <c:if test="${product.quantity == null || product.quantity <= 0}">
                                <span class="out-of-stock-badge">Not Available</span>
                            </c:if>
                            <div class="corner-accent"></div>
                            <c:choose>
                                <c:when test="${empty product.image}">
                                    <img src="${pageContext.request.contextPath}/resources/images/product-placeholder.jpg" alt="No image available" />
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}${product.image}"
                                         alt="${product.productName}"
                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                                    <img src="${pageContext.request.contextPath}/resources/images/product-placeholder.jpg" alt="No image available" style="display:none;" />
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="product-body">
                            <p class="product-name"><c:out value="${product.productName}" /></p>
                            <p class="product-price">$<c:out value="${product.price}" /></p>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>
