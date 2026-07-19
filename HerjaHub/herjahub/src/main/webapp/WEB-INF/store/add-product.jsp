<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Product</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/add-product.css">
</head>
<body>

<%-- ===== Testing nav: quick links between store pages ===== --%>
<div class="test-nav">
    <a href="${pageContext.request.contextPath}/store/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/store/products/add">Add Product</a>
</div>

<div class="form-box">

    <h1>Add new Product to the store</h1>

    <form:form cssClass="add-product-form" action="${pageContext.request.contextPath}/store/products/add" method="post" modelAttribute="product">

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
             image URL/path as text. Swap this for a real upload later. --%>
        <form:label path="image">Image (URL for now)</form:label>
        <form:input path="image" />
        <form:errors path="image" cssClass="error-text" />

        <%-- The wireframe has no Quantity field yet, so we default it to 1 here.
             This can be changed later on an Edit Product page. --%>
        <form:hidden path="quantity" value="1" />

        <input type="submit" value="+ Add" />
    </form:form>

</div>

</body>
</html>
