<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/edit_profile_style.css">
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


<h1>Edit Profile</h1>

<div class="form-box">

    <%-- Note: Customer has no "image" field yet, so this is just a placeholder for now --%>
    <p class="photo-placeholder">(profile photo placeholder)</p>

    <form:form cssClass="profile-form" action="/customer/profile/edit" method="post" modelAttribute="editProfileForm">

        <form:label path="firstName">First Name</form:label>
        <form:input path="firstName" />
        <form:errors path="firstName" cssClass="error-text" />

        <form:label path="lastName">Last Name</form:label>
        <form:input path="lastName" />
        <form:errors path="lastName" cssClass="error-text" />

        <form:label path="email">Email</form:label>
        <form:input path="email" />
        <form:errors path="email" cssClass="error-text" />

        <form:label path="newPassword">New Password</form:label>
        <form:password path="newPassword" />
        <form:errors path="newPassword" cssClass="error-text" />

        <input type="submit" value="Save Changes" />
    </form:form>

</div>

</body>
</html>
