<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
</head>
<body>

<%-- ===== Testing nav ===== --%>
<div>
    <a href="${pageContext.request.contextPath}/store/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/store/products/add">Add Product</a>
</div>
<hr>

<h1>Edit Product</h1>

<%-- product image --%>
<c:choose>
    <c:when test="${empty product.image}">
        <p>(image placeholder)</p>
    </c:when>
    <c:otherwise>
        <img src="${product.image}" alt="${product.productName}" width="200" />
    </c:otherwise>
</c:choose>

<p><c:out value="${product.productName}" /></p>
<p><c:out value="${product.description}" /></p>
<p>$<c:out value="${product.price}" /></p>

<a href="${pageContext.request.contextPath}/store/products/${product.id}/edit">Edit</a>

<hr>

<h2>Comments</h2>

<c:choose>
    <c:when test="${empty product.comments}">
        <p>No comments yet.</p>
    </c:when>
    <c:otherwise>
        <c:forEach var="comment" items="${product.comments}">
            <p>
                <strong><c:out value="${comment.customer.firstName}" /></strong> -
                <c:out value="${comment.comment}" />
            </p>
        </c:forEach>
    </c:otherwise>
</c:choose>

</body>
</html>
