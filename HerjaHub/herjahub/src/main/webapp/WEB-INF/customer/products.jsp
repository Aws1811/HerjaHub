<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/products_style.css">
</head>
<body>

<%-- ===== Testing nav: quick links to every customer page ===== --%>
<div class="test-nav">
    <a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/customer/products">Products</a> |
    <a href="${pageContext.request.contextPath}/customer/products/1">Product Details</a> |
    <a href="${pageContext.request.contextPath}/customer/cart">Cart</a> |
    <a href="${pageContext.request.contextPath}/customer/orders">My Orders</a> |
    <a href="${pageContext.request.contextPath}/customer/orders/1/confirmation">Order Confirmation</a> |
    <a href="${pageContext.request.contextPath}/customer/profile/edit">Edit Profile</a>
</div>
<hr>


<%-- ===== Nav bar ===== --%>
<div class="navbar">
    <a href="/customer/dashboard">HerjaHub</a>
    <a href="/customer/dashboard">Home</a>
    <a href="/customer/products">Products</a>
    <a href="/stores">Stores</a>
    <a href="/ai">AI</a>
    <a href="/customer/cart">Cart</a>
    <a href="/customer/profile/edit">Profile</a>
</div>

<hr>

<%-- ===== Filter sidebar ===== --%>
<div class="sidebar">
    <h3>Filter</h3>

    <%-- Store filter: loop over stores passed from the controller --%>
    <p>Store</p>
    <c:choose>
        <c:when test="${empty stores}">
            <p class="muted">(no stores to filter by yet)</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="store" items="${stores}">
                <div class="filter-option">
                    <input type="checkbox" name="storeId" value="${store.id}" />
                    <c:out value="${store.storeName}" />
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <%-- Category filter: placeholder, since there is no Category model yet --%>
    <p>Category</p>
    <p class="muted">(category filter placeholder - no Category model yet)</p>
</div>

<hr>

<%-- ===== Product grid ===== --%>
<h1>All Products</h1>

<c:choose>
    <c:when test="${empty products}">
        <p>There are no products yet.</p>
    </c:when>
    <c:otherwise>
        <c:forEach var="product" items="${products}">
            <div class="product-card" style="display:inline-block;">
                <a href="/customer/products/${product.id}">
                    <%-- placeholder for product image --%>
                    <c:choose>
                        <c:when test="${empty product.image}">
                            <p class="image-placeholder">(image placeholder)</p>
                        </c:when>
                        <c:otherwise>
                            <img src="${product.image}" alt="${product.productName}" width="150" />
                        </c:otherwise>
                    </c:choose>

                    <p class="product-name"><c:out value="${product.productName}" /></p>
                    <p class="product-price">$<c:out value="${product.price}" /></p>
                </a>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>

</body>
</html>
