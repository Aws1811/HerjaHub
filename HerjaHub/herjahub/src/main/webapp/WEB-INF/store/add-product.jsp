<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Product</title>
</head>
<body>

<%-- ===== Testing nav: quick links between store pages ===== --%>
<div>
    <a href="${pageContext.request.contextPath}/store/dashboard">Dashboard</a> |
    <a href="${pageContext.request.contextPath}/store/products/add">Add Product</a>
</div>
<hr>

<h1>Add Product</h1>

<form:form action="/store/products/add" method="post" modelAttribute="product">

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
         image URL/path as text. Swap this for a real upload later. --%>
    <form:label path="image">Image (URL for now)</form:label>
    <form:input path="image" />
    <form:errors path="image" />

    <%-- The wireframe has no Quantity field yet, so we default it to 1 here.
         This can be changed later on an Edit Product page. --%>
    <form:hidden path="quantity" value="1" />

    <input type="submit" value="+ Add" />
</form:form>

</body>
</html>
