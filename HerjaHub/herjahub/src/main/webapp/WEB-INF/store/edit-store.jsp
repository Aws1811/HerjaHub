<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Store</title>
</head>
<body>

<%-- ===== Testing nav ===== --%>
<div>
    <a href="${pageContext.request.contextPath}/store/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/store/products/add">Add Product</a> |
    <a href="${pageContext.request.contextPath}/store/profile/edit">Edit Store</a>
</div>
<hr>

<h1>Edit Store</h1>

<%-- store logo --%>
<c:choose>
    <c:when test="${empty store.image}">
        <p>(store logo placeholder)</p>
    </c:when>
    <c:otherwise>
        <img src="${store.image}" alt="${store.storeName}" width="150" />
    </c:otherwise>
</c:choose>

<h2>Store Info</h2>

<form:form action="${pageContext.request.contextPath}/store/profile/edit" method="post" modelAttribute="editStoreForm">

    <form:label path="storeName">Store Name</form:label>
    <form:input path="storeName" />
    <form:errors path="storeName" />

    <form:label path="description">Description</form:label>
    <form:textarea path="description" />
    <form:errors path="description" />

    <form:label path="phone">Phone Number</form:label>
    <form:input path="phone" />
    <form:errors path="phone" />

    <form:label path="address">Address</form:label>
    <form:input path="address" />
    <form:errors path="address" />

    <input type="submit" value="Update" />
</form:form>

<hr>

<%-- ===== Comments from all of this store's products, reusing the
     Store.products -> Product.comments relationship (no new query) ===== --%>
<h2>Comments (from Product Details)</h2>

<c:set var="hasAnyComments" value="false" />
<c:forEach var="product" items="${store.products}">
    <c:forEach var="comment" items="${product.comments}">
        <c:set var="hasAnyComments" value="true" />
        <p>
            <strong><c:out value="${comment.customer.firstName}" /></strong>
            on <em><c:out value="${product.productName}" /></em> -
            <c:out value="${comment.comment}" />
        </p>
    </c:forEach>
</c:forEach>

<c:if test="${!hasAnyComments}">
    <p>No comments yet on any of your products.</p>
</c:if>

</body>
</html>
