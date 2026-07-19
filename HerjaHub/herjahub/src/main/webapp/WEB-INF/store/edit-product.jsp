<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/edit-product.css">
</head>
<body>

<%-- ===== Testing nav ===== --%>
<div class="test-nav">
    <a href="${pageContext.request.contextPath}/store/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/store/products/add">Add Product</a>
</div>

<div class="form-box">

    <h1>Edit Product</h1>

    <%-- Note: since "product" here already has real values loaded from the
         database (see StoreController.editProductPage), every field below
         is automatically pre-filled - no extra work needed. --%>
    <form:form action="${pageContext.request.contextPath}/store/products/${product.id}/edit" method="post" modelAttribute="product">

        <form:label path="productName">Name</form:label>
        <form:input path="productName" />
        <form:errors path="productName" cssClass="error-text" />

        <form:label path="description">Description</form:label>
        <form:textarea path="description" />
        <form:errors path="description" cssClass="error-text" />

        <form:label path="price">Price</form:label>
        <form:input path="price" />
        <form:errors path="price" cssClass="error-text" />

        <%-- Note: real file upload isn't wired up yet - for now this just takes an
             image URL/path as text, same as the Add Product page. --%>
        <form:label path="image">Image (URL for now)</form:label>
        <form:input path="image" />
        <form:errors path="image" cssClass="error-text" />

        <form:label path="quantity">Quantity in Stock</form:label>
        <form:input path="quantity" />
        <form:errors path="quantity" cssClass="error-text" />

        <input type="submit" value="Save Changes" />
    </form:form>

</div>

</body>
</html>
