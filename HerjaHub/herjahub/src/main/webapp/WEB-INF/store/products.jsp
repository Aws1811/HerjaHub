<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Products — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
<style>
  :root{
    --red:#CE1126; --green:#007A3D; --black:#111111;
    --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF;
    --text-1:#1F2937; --text-2:#6B7280;
    --radius-lg:24px; --radius-md:18px; --radius-sm:12px;
    --shadow-sm:0 4px 16px rgba(31,41,55,0.06);
    --shadow-md:0 18px 40px -16px rgba(31,41,55,0.18);
    --ease:cubic-bezier(.4,0,.2,1);
  }
  *{box-sizing:border-box;}
  body{
    margin:0; font-family:'Inter',sans-serif; color:var(--text-1);
    background:var(--neutral-1);
    background-image:
      radial-gradient(600px 400px at -10% -10%, rgba(206,17,38,0.06), transparent 60%),
      radial-gradient(600px 400px at 110% 10%, rgba(0,122,61,0.07), transparent 60%),
      radial-gradient(500px 350px at 50% 120%, rgba(0,0,0,0.03), transparent 60%);
    background-attachment:fixed;
  }
  a{ text-decoration:none; color:inherit; }
  @keyframes fadeInUp{ from{opacity:0; transform:translateY(10px);} to{opacity:1; transform:translateY(0);} }

  .topbar{
    display:flex; align-items:center; gap:8px; flex-wrap:wrap;
    max-width:1200px; margin:20px auto 0; padding:12px 20px;
    background:rgba(255,255,255,0.72); backdrop-filter:blur(16px); -webkit-backdrop-filter:blur(16px);
    border:1px solid rgba(255,255,255,0.5); border-radius:999px; box-shadow:var(--shadow-sm);
  }
  .brand{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; margin-right:auto; padding:6px 10px;
    background:linear-gradient(90deg, var(--red), var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }
  .topbar a.nav-item{ padding:9px 16px; border-radius:999px; font-weight:600; font-size:13.5px; color:var(--text-2); transition:all .25s var(--ease); }
  .topbar a.nav-item:hover{ background:var(--neutral-2); color:var(--text-1); }
  .topbar a.nav-item.active{ background:var(--text-1); color:var(--white); }

  .test-nav{ max-width:1200px; margin:10px auto 0; padding:10px 20px; font-size:12px; color:var(--text-2); }
  .test-nav a{ color:var(--text-2); }
  .test-nav a:hover{ color:var(--red); }

  .page{ max-width:1200px; margin:22px auto 60px; padding:0 20px; }

  .hero{
    position:relative; overflow:hidden; border-radius:var(--radius-lg);
    padding:46px 40px 60px; margin-bottom:-34px;
    box-shadow:var(--shadow-md);
    animation:fadeInUp .5s var(--ease);
  }
  .hero::before{
    content:""; position:absolute; inset:-40px; z-index:0;
    background:
      linear-gradient(120deg, rgba(206,17,38,0.9) 0%, rgba(255,255,255,0.85) 28%, rgba(0,122,61,0.85) 55%, rgba(255,255,255,0.8) 78%, rgba(17,17,17,0.55) 100%),
      var(--keffiyeh-pattern);
    background-size:cover, 140px 140px;
    background-blend-mode:overlay;
    filter:blur(22px);
    opacity:0.92;
  }
  .hero::after{
    content:""; position:absolute; inset:0; z-index:1;
    background:linear-gradient(180deg, rgba(0,0,0,0.12), rgba(0,0,0,0.28));
  }
  .hero-content{ position:relative; z-index:2; }
  .hero-eyebrow{ color:rgba(255,255,255,0.85); font-weight:700; font-size:12.5px; letter-spacing:.08em; text-transform:uppercase; margin:0 0 8px; }
  .hero h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:34px; color:var(--white); margin:0; text-shadow:0 2px 12px rgba(0,0,0,0.25); }
  .hero p{ color:rgba(255,255,255,0.88); margin:8px 0 0; font-size:14.5px; max-width:480px; }

  .filter-bar{
    position:relative; z-index:3;
    background:rgba(255,255,255,0.78); backdrop-filter:blur(20px); -webkit-backdrop-filter:blur(20px);
    border:1px solid rgba(255,255,255,0.6); border-radius:var(--radius-md);
    padding:22px 26px; margin:0 20px 30px; box-shadow:var(--shadow-md);
    animation:fadeInUp .5s var(--ease) .1s backwards;
  }
  .filter-title{ font-family:'Poppins',sans-serif; font-weight:700; font-size:15px; margin:0 0 14px; display:flex; align-items:center; gap:8px; }
  .filter-title::before{ content:""; width:8px; height:8px; border-radius:50%; background:linear-gradient(90deg,var(--red),var(--green)); }
  .filter-group{ margin-bottom:14px; }
  .filter-group:last-child{ margin-bottom:0; }
  .filter-label{ font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.06em; color:var(--text-2); margin-bottom:8px; }
  .filter-chips{ display:flex; flex-wrap:wrap; gap:8px; }
  .filter-chip{ display:inline-flex; align-items:center; gap:7px; padding:8px 14px; background:var(--neutral-1); border:1px solid var(--neutral-2); border-radius:999px; font-size:13px; font-weight:600; cursor:pointer; transition:all .22s var(--ease); }
  .filter-chip:hover{ border-color:var(--green); background:var(--white); transform:translateY(-1px); }
  .filter-chip input{ accent-color:var(--green); margin:0; }
  .muted{ color:var(--text-2); font-size:13px; margin:0; }

  .product-grid{ display:grid; grid-template-columns:repeat(auto-fill, minmax(230px, 1fr)); gap:22px; }
  .product-card{
    background:rgba(255,255,255,0.85); backdrop-filter:blur(10px); -webkit-backdrop-filter:blur(10px);
    border:1px solid rgba(255,255,255,0.6); border-radius:var(--radius-md); overflow:hidden;
    box-shadow:var(--shadow-sm); transition:transform .3s var(--ease), box-shadow .3s var(--ease);
    animation:fadeInUp .45s var(--ease) backwards;
  }
  .product-card:hover{ transform:translateY(-6px) scale(1.015); box-shadow:var(--shadow-md); }
  .product-card a{ display:flex; flex-direction:column; height:100%; }
  .product-image-wrap{ aspect-ratio:1/1; background:var(--neutral-2); display:flex; align-items:center; justify-content:center; overflow:hidden; }
  .product-image-wrap img{ width:100%; height:100%; object-fit:cover; transition:transform .4s var(--ease); }
  .product-card:hover .product-image-wrap img{ transform:scale(1.06); }
  .image-placeholder{ color:var(--text-2); font-size:12.5px; margin:0; }
  .product-body{ padding:16px 18px; display:flex; flex-direction:column; gap:6px; flex:1; }
  .product-name{ font-weight:700; font-size:15px; margin:0; color:var(--text-1); }
  .product-price{ margin:0; font-weight:800; font-size:15px; background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }

  .empty-state{ text-align:center; padding:70px 30px; background:rgba(255,255,255,0.7); backdrop-filter:blur(10px); border:1px dashed var(--neutral-2); border-radius:var(--radius-lg); color:var(--text-2); }
  .empty-state h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:19px; color:var(--text-1); margin:0 0 6px; }

  @media (max-width:640px){
    .hero{ padding:36px 24px 50px; }
    .hero h1{ font-size:26px; }
    .filter-bar{ margin-left:12px; margin-right:12px; }
    .page{ padding:0 12px; }
  }
</style>
</head>
<body style="--keffiyeh-pattern: url('data:image/svg+xml;utf8,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%22140%22 height=%22140%22><g fill=%22none%22 stroke=%22%23ffffff%22 stroke-width=%222%22 opacity=%220.5%22><path d=%22M0 70 L70 0 L140 70 L70 140 Z%22/><path d=%22M70 0 L70 140%22/><path d=%22M0 70 L140 70%22/></g></svg>')">

<%-- ===== Glass topbar ===== --%>
<div class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/customer/dashboard">HerjaHub</a>
    <a class="nav-item" href="${pageContext.request.contextPath}/customer/dashboard">Home</a>
    <a class="nav-item active" href="${pageContext.request.contextPath}/customer/products">Products</a>
    <%-- Note: no confirmed customer-facing "all stores" route yet - pointing here for now, update if the real route differs --%>
    <a class="nav-item" href="${pageContext.request.contextPath}/customer/stores">Stores</a>
    <a class="nav-item" href="${pageContext.request.contextPath}/customer/ai">AI</a>
    <a class="nav-item" href="${pageContext.request.contextPath}/customer/cart">Cart</a>
    <a class="nav-item" href="${pageContext.request.contextPath}/customer/profile/edit">Profile</a>
</div>

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

<div class="page">

    <%-- ===== Keffiyeh gradient hero ===== --%>
    <div class="hero">
        <div class="hero-content">
            <p class="hero-eyebrow">Marketplace</p>
            <h1>All Products</h1>
            <p>Handmade goods from every artisan on HerjaHub.</p>
        </div>
    </div>

    <%-- ===== Filter bar (glass card, overlapping the hero) ===== --%>
    <div class="filter-bar">
        <div class="filter-title">Filter</div>

        <div class="filter-group">
            <div class="filter-label">Store</div>
            <c:choose>
                <c:when test="${empty stores}">
                    <p class="muted">(no stores to filter by yet)</p>
                </c:when>
                <c:otherwise>
                    <div class="filter-chips">
                        <c:forEach var="store" items="${stores}">
                            <label class="filter-chip">
                                <input type="checkbox" name="storeId" value="${store.id}" />
                                <c:out value="${store.storeName}" />
                            </label>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="filter-group">
            <div class="filter-label">Category</div>
            <p class="muted">(category filter placeholder - no Category model yet)</p>
        </div>
    </div>

    <%-- ===== Product grid ===== --%>
    <c:choose>
        <c:when test="${empty products}">
            <div class="empty-state">
                <h3>No products yet</h3>
                <p class="muted">Check back soon - artisans are adding their catalog.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="product-grid">
                <c:forEach var="product" items="${products}" varStatus="i">
                    <div class="product-card" style="animation-delay:${i.index * 0.04}s">
                        <a href="${pageContext.request.contextPath}/customer/products/${product.id}">
                            <div class="product-image-wrap">
                                <c:choose>
                                    <c:when test="${empty product.image}">
                                        <p class="image-placeholder">(image placeholder)</p>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${product.image}" alt="${product.productName}" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="product-body">
                                <p class="product-name"><c:out value="${product.productName}" /></p>
                                <p class="product-price">$<c:out value="${product.price}" /></p>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
