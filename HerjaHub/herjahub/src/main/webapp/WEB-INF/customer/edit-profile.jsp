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

<div class="profile-card">

    <%-- ===== Top brand bar, like the reference's dark header ===== --%>
    <div class="brand-bar">
        <span class="brand-name">HerjaHub</span>
        <span class="breadcrumb">Profile Overview</span>
        <span class="brand-bar-right">
            <c:out value="${editProfileForm.firstName} ${editProfileForm.lastName}" />
        </span>
    </div>

    <%-- ===== Cover banner - decorative pattern instead of a real cover photo ===== --%>
    <div class="cover-banner"></div>

    <%-- ===== Avatar + name row, overlapping the banner ===== --%>
    <div class="identity-row">
        <%-- Note: Customer has no "image" field yet, so this is a placeholder avatar for now --%>
        <div class="avatar-placeholder">
            <c:out value="${editProfileForm.firstName.substring(0,1)}" />
        </div>

        <div class="identity-text">
            <h1><c:out value="${editProfileForm.firstName} ${editProfileForm.lastName}" /></h1>
            <p class="identity-email"><c:out value="${editProfileForm.email}" /></p>
        </div>

        <%-- This button lives outside the <form> tag, but the "form" attribute
             ties it to the form below by id, so clicking it still submits those
             fields - that's how it can visually sit up here next to the name. --%>
        <input class="save-btn" type="submit" value="Save changes" form="editProfileForm" />
    </div>

    <%-- ===== Personal details form ===== --%>
    <form:form id="editProfileForm" cssClass="profile-form" action="/customer/profile/edit" method="post" modelAttribute="editProfileForm">

        <h2 class="section-title">Personal details</h2>

        <div class="field-grid">
            <div class="field">
                <form:label path="firstName">First name</form:label>
                <form:input path="firstName" />
                <form:errors path="firstName" cssClass="error-text" />
            </div>

            <div class="field">
                <form:label path="lastName">Last name</form:label>
                <form:input path="lastName" />
                <form:errors path="lastName" cssClass="error-text" />
            </div>

            <div class="field">
                <form:label path="email">Email</form:label>
                <form:input path="email" />
                <form:errors path="email" cssClass="error-text" />
            </div>

            <div class="field">
                <form:label path="newPassword">New password</form:label>
                <form:password path="newPassword" />
                <form:errors path="newPassword" cssClass="error-text" />
            </div>
        </div>

    </form:form>

</div>

</body>
</html>
