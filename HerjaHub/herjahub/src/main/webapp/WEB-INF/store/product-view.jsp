<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product-view.css">
</head>
<body>

<%-- ===== Testing nav ===== --%>
<div class="test-nav">
    <a href="${pageContext.request.contextPath}/store/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/store/products/add">Add Product</a>
</div>

<div class="page-card">

    <h1>Edit Product</h1>

    <div class="top-row">
        <%-- product image --%>
        <c:choose>
            <c:when test="${empty product.image}">
                <div class="image-placeholder">image</div>
            </c:when>
            <c:otherwise>
                <img class="product-image" src="${product.image}" alt="${product.productName}" />
            </c:otherwise>
        </c:choose>

        <div class="product-summary">
            <p class="product-name"><c:out value="${product.productName}" /></p>
            <p class="product-description"><c:out value="${product.description}" /></p>
            <p class="product-price">$<c:out value="${product.price}" /></p>

            <a class="edit-link" href="${pageContext.request.contextPath}/store/products/${product.id}/edit">Edit</a>
        </div>
    </div>

    <div class="comments-section">
        <h2 class="section-title">Comments</h2>

        <c:choose>
            <c:when test="${empty product.comments}">
                <p class="muted">No comments yet.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="comment" items="${product.comments}">
                    <p class="comment-line">
                        <strong><c:out value="${comment.customer.firstName}" /></strong> -
                        <c:out value="${comment.comment}" />
                    </p>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

</div>

</body>
</html>
