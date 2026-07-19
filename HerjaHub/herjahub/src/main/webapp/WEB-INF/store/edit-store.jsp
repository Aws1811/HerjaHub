<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/edit-store.css">
</head>
<body>

<%-- ===== Testing nav ===== --%>
<div class="test-nav">
    <a href="${pageContext.request.contextPath}/store/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/store/products/add">Add Product</a> |
    <a href="${pageContext.request.contextPath}/store/profile/edit">Edit Store</a>
</div>

<div class="page-card">

    <h1>Edit Store</h1>

    <div class="top-row">
        <%-- store logo --%>
        <c:choose>
            <c:when test="${empty store.image}">
                <div class="logo-placeholder">store logo</div>
            </c:when>
            <c:otherwise>
                <img class="logo-image" src="${store.image}" alt="${store.storeName}" />
            </c:otherwise>
        </c:choose>

        <form:form cssClass="store-form" action="${pageContext.request.contextPath}/store/profile/edit" method="post" modelAttribute="editStoreForm">

            <h2 class="section-title">Store Info</h2>

            <form:label path="storeName">Store Name</form:label>
            <form:input path="storeName" />
            <form:errors path="storeName" cssClass="error-text" />

            <form:label path="description">Description</form:label>
            <form:textarea path="description" />
            <form:errors path="description" cssClass="error-text" />

            <form:label path="phone">Phone Number</form:label>
            <form:input path="phone" />
            <form:errors path="phone" cssClass="error-text" />

            <form:label path="address">Address</form:label>
            <form:input path="address" />
            <form:errors path="address" cssClass="error-text" />

            <input class="save-btn" type="submit" value="Update" />
        </form:form>
    </div>

    <%-- ===== Comments from all of this store's products, reusing the
         Store.products -> Product.comments relationship (no new query) ===== --%>
    <div class="comments-section">
        <h2 class="section-title">Comments (from Product Details)</h2>

        <c:set var="hasAnyComments" value="false" />
        <c:forEach var="product" items="${store.products}">
            <c:forEach var="comment" items="${product.comments}">
                <c:set var="hasAnyComments" value="true" />
                <p class="comment-line">
                    <strong><c:out value="${comment.customer.firstName}" /></strong>
                    on <em><c:out value="${product.productName}" /></em> -
                    <c:out value="${comment.comment}" />
                </p>
            </c:forEach>
        </c:forEach>

        <c:if test="${!hasAnyComments}">
            <p class="muted">No comments yet on any of your products.</p>
        </c:if>
    </div>

</div>

</body>
</html>
