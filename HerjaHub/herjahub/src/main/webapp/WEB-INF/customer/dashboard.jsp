<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customer Dashboard — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;1,6..72,500&family=Inter:wght@400;500;600;700&family=Tajawal:wght@400;500;700&display=swap" rel="stylesheet">
<style>
  :root{ --white:#FFFFFF; --light-gray:#F8F9FA; --charcoal:#1F2937; --green:#198754; --green-dark:#146c43; }
  *{box-sizing:border-box;}
  body{ margin:0; font-family:'Inter',sans-serif; background:var(--light-gray); color:var(--charcoal); }
  .topbar{ display:flex; align-items:center; justify-content:space-between; padding:18px 32px; background:#fff; border-bottom:1px solid rgba(31,41,55,0.08); }
  .brand{ display:flex; align-items:center; gap:10px; font-weight:700; font-size:18px; }
  .logo-mark{ width:32px; height:32px; border-radius:9px; background:linear-gradient(135deg,var(--green),var(--green-dark)); color:#fff; display:flex; align-items:center; justify-content:center; font-family:'Newsreader',serif; font-weight:600; }
  .logout-link{ color:var(--charcoal); text-decoration:none; font-weight:600; font-size:14px; padding:8px 16px; border:1px solid rgba(31,41,55,0.15); border-radius:10px; }
  .logout-link:hover{ background:var(--light-gray); }
  .content{ max-width:960px; margin:0 auto; padding:48px 24px; }
  .welcome-card{ background:#fff; border-radius:20px; padding:32px; box-shadow:0 20px 40px -30px rgba(17,17,17,0.25); }
  .welcome-card h1{ font-family:'Newsreader',serif; font-weight:500; margin:0 0 8px; font-size:28px; }
  .welcome-card p{ color:#6b7280; margin:0; }
  .test-nav{ background:#fff; border-radius:20px; padding:24px 32px; margin-top:24px; box-shadow:0 20px 40px -30px rgba(17,17,17,0.25); }
  .test-nav h2{ font-family:'Newsreader',serif; font-weight:500; margin:0 0 4px; font-size:18px; }
  .test-nav p{ color:#6b7280; margin:0 0 16px; font-size:13px; }
  .test-nav .links{ display:flex; flex-wrap:wrap; gap:10px; }
  .test-nav a{ color:var(--charcoal); text-decoration:none; font-weight:600; font-size:13px; padding:8px 14px; border:1px solid rgba(31,41,55,0.15); border-radius:10px; }
  .test-nav a:hover{ background:var(--light-gray); }
</style>
</head>
<body>
  <div class="topbar">
    <div class="brand"><div class="logo-mark">ه</div> HerjaHub</div>
    <a class="logout-link" href="${pageContext.request.contextPath}/logout">Log out</a>
  </div>
  <div class="content">
    <div class="welcome-card">
      <h1 class="font-display">Welcome, ${customer.firstName}!</h1>
      <p>You're logged in as a customer. Browse the marketplace and support local artisans.</p>
    </div>

    <%-- ===== Testing nav: quick links to every customer page ===== --%>
    <div class="test-nav">
      <h2>Testing Navigation</h2>
      <p>Temporary links for going through every customer page during development.</p>
      <div class="links">
        <a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/customer/products">Products</a>
        <a href="${pageContext.request.contextPath}/customer/products/1">Product Details (id=1)</a>
        <a href="${pageContext.request.contextPath}/customer/cart">Cart</a>
        <a href="${pageContext.request.contextPath}/customer/orders">My Orders</a>
        <a href="${pageContext.request.contextPath}/customer/orders/1/confirmation">Order Confirmation (id=1)</a>
        <a href="${pageContext.request.contextPath}/customer/profile/edit">Edit Profile</a>
      </div>
    </div>
  </div>
</body>
</html>
