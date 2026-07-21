<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products</title>
</head>
<body>

<%-- ===== Nav bar ===== --%>
<div>
    <a href="/home">HerjaHub</a>
    <a href="/home">Home</a>
    <a href="/products">Products</a>
    <a href="/stores">Stores</a>
    <a href="${pageContext.request.contextPath}/customer/ai">AI</a>
    <a href="/cart">Cart</a>
    <a href="/profile">Profile</a>
</div>

<hr>

<%-- ===== Filter sidebar ===== --%>
<div>
    <h3>Filter</h3>

    <%-- Store filter: loop over stores passed from the controller --%>
    <p>Store</p>
    <c:choose>
        <c:when test="${empty stores}">
            <p>(no stores to filter by yet)</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="store" items="${stores}">
                <div>
                    <input type="checkbox" name="storeId" value="${store.id}" />
                    <c:out value="${store.storeName}" />
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <%-- Category filter: placeholder, since there is no Category model yet --%>
    <p>Category</p>
    <p>(category filter placeholder - no Category model yet)</p>
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
            <div style="display:inline-block;">
                <a href="/products/${product.id}">
                    <%-- placeholder for product image --%>
                    <c:choose>
                        <c:when test="${empty product.image}">
                            <p>(image placeholder)</p>
                        </c:when>
                        <c:otherwise>
                            <img src="${product.image}" alt="${product.productName}" width="150" />
                        </c:otherwise>
                    </c:choose>

                    <p><c:out value="${product.productName}" /></p>
                    <p>$<c:out value="${product.price}" /></p>
                </a>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>

</body>
</html>
