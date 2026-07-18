<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
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

<%-- Note: since "product" here already has real values loaded from the
     database (see StoreController.editProductPage), every field below
     is automatically pre-filled - no extra work needed. --%>
<form:form action="${pageContext.request.contextPath}/store/products/${product.id}/edit" method="post" modelAttribute="product">

    <form:label path="productName">Name</form:label>
    <form:input path="productName" />
    <form:errors path="productName" />

    <form:label path="description">Description</form:label>
    <form:textarea path="description" />
    <form:errors path="description" />

    <form:label path="price">Price</form:label>
    <form:input path="price" />
    <form:errors path="price" />

    <%-- Note: real file upload isn't wired up yet - for now this just takes an
         image URL/path as text, same as the Add Product page. --%>
    <form:label path="image">Image (URL for now)</form:label>
    <form:input path="image" />
    <form:errors path="image" />

    <form:label path="quantity">Quantity in Stock</form:label>
    <form:input path="quantity" />
    <form:errors path="quantity" />

    <input type="submit" value="Save Changes" />
</form:form>

</body>
</html>
