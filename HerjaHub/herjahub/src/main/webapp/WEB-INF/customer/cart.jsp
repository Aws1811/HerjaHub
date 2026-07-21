<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cart — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --red:#CE1126; --green:#007A3D; --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF;
    --text-1:#1F2937; --text-2:#6B7280;
    --radius-lg:24px; --radius-md:18px; --radius-sm:12px;
    --shadow-sm:0 4px 16px rgba(31,41,55,0.06); --shadow-md:0 18px 40px -16px rgba(31,41,55,0.18);
    --ease:cubic-bezier(.4,0,.2,1); --sidebar-w:250px; --topbar-h:68px;
  }
  *{box-sizing:border-box;}
  html,body{ height:100%; }
  body{
    margin:0; font-family:'Inter',sans-serif; color:var(--text-1); background:var(--neutral-1);
    background-image:
      radial-gradient(700px 480px at -10% -10%, rgba(206,17,38,0.05), transparent 60%),
      radial-gradient(700px 480px at 110% 0%, rgba(0,122,61,0.06), transparent 60%);
    background-attachment:fixed;
  }
  a{ text-decoration:none; color:inherit; }
  @keyframes fadeInUp{ from{opacity:0; transform:translateY(10px);} to{opacity:1; transform:translateY(0);} }

  .sidebar{ position:fixed; top:0; left:0; bottom:0; width:var(--sidebar-w); z-index:30; background:rgba(255,255,255,0.7); backdrop-filter:blur(20px); -webkit-backdrop-filter:blur(20px); border-right:1px solid rgba(255,255,255,0.6); display:flex; flex-direction:column; padding:22px 16px; }
  .sidebar-brand{ display:flex; align-items:center; gap:10px; padding:6px 10px 26px; }
  .sidebar-brand .mark{ width:38px; height:38px; border-radius:12px; flex-shrink:0; overflow:hidden; background:linear-gradient(135deg, var(--red), var(--green)); display:flex; align-items:center; justify-content:center; color:var(--white); font-family:'Poppins',sans-serif; font-weight:800; }
  .sidebar-brand .mark img{ width:100%; height:100%; object-fit:cover; }
  .sidebar-brand .name{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; }
  .side-label{ font-size:10.5px; font-weight:700; text-transform:uppercase; letter-spacing:.08em; color:var(--text-2); padding:14px 12px 8px; }
  .side-link{ display:flex; align-items:center; gap:12px; padding:11px 12px; border-radius:var(--radius-sm); font-weight:600; font-size:14px; color:var(--text-1); margin-bottom:3px; transition:all .22s var(--ease); position:relative; }
  .side-link svg{ flex-shrink:0; opacity:.8; }
  .side-link:hover{ background:var(--neutral-2); }
  .side-link.active{ background:linear-gradient(90deg, rgba(206,17,38,0.1), rgba(0,122,61,0.1)); box-shadow:inset 0 0 0 1px rgba(0,122,61,0.15); }
  .side-link.active svg{ opacity:1; color:var(--green); }
  .side-link.active::before{ content:""; position:absolute; left:-16px; top:8px; bottom:8px; width:4px; border-radius:4px; background:linear-gradient(180deg, var(--red), var(--green)); }
  .sidebar-footer{ margin-top:auto; padding-top:14px; border-top:1px solid var(--neutral-2); }

  .main-area{ margin-left:var(--sidebar-w); min-height:100%; position:relative; z-index:1; }
  .topbar{ position:sticky; top:0; z-index:20; height:var(--topbar-h); display:flex; align-items:center; justify-content:space-between; gap:16px; padding:0 28px; background:rgba(255,255,255,0.65); backdrop-filter:blur(18px); -webkit-backdrop-filter:blur(18px); border-bottom:1px solid rgba(255,255,255,0.5); }
  .topbar-title{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; }
  .logout-btn{ display:flex; align-items:center; gap:6px; padding:9px 14px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); font-size:13px; font-weight:600; color:var(--text-2); transition:all .2s var(--ease); }
  .logout-btn:hover{ color:var(--red); border-color:var(--red); }

  .keffiyeh-corner-bg{ position:fixed; inset:0; z-index:0; pointer-events:none;
    background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
    background-repeat:no-repeat; background-position:bottom right; background-size:min(70vw, 900px); opacity:0.06;
    -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
    mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%); }

  .page{ max-width:1160px; padding:36px 32px 60px; }
  .page-title{ font-family:'Poppins',sans-serif; font-weight:800; font-size:28px; margin:0 0 6px; }
  .page-sub{ color:var(--text-2); font-size:14px; margin:0 0 30px; }

  /* ===================== SIGNATURE: item list + sticky itemized summary panel ===================== */
  .cart-layout{ display:grid; grid-template-columns:1fr 340px; gap:28px; align-items:start; }

  .cart-list{ display:flex; flex-direction:column; gap:12px; }
  .cart-line{ display:flex; align-items:center; gap:18px; background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-md); padding:16px 20px; transition:all .2s var(--ease); animation:fadeInUp .4s var(--ease) backwards; }
  .cart-line:hover{ box-shadow:var(--shadow-sm); }
  .cart-thumb{ width:68px; height:68px; border-radius:14px; background:var(--neutral-1); flex-shrink:0; display:flex; align-items:center; justify-content:center; overflow:hidden; color:var(--text-2); }
  .cart-thumb img{ width:100%; height:100%; object-fit:cover; }
  .cart-name{ flex:1; font-weight:700; font-size:14.5px; min-width:0; }
  .cart-qty{ font-size:12px; font-weight:700; color:var(--text-2); background:var(--neutral-1); padding:6px 12px; border-radius:999px; }
  .cart-subtotal{ font-weight:800; font-size:15px; background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; min-width:70px; text-align:right; }

  .summary-panel{ position:sticky; top:calc(var(--topbar-h) + 20px); background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-lg); padding:26px; box-shadow:var(--shadow-md); animation:fadeInUp .4s var(--ease) .1s backwards; }
  .summary-panel h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:17px; margin:0 0 18px; }
  .summary-line{ display:flex; justify-content:space-between; font-size:13px; color:var(--text-2); margin-bottom:10px; gap:12px; }
  .summary-line span:last-child{ font-weight:600; color:var(--text-1); flex-shrink:0; }
  .summary-total{ display:flex; justify-content:space-between; align-items:baseline; padding-top:16px; margin-top:6px; border-top:1px solid var(--neutral-2); font-weight:700; font-size:15px; }
  .summary-total span:last-child{ font-family:'Poppins',sans-serif; font-weight:800; font-size:21px; background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }
  .checkout-btn{ width:100%; margin-top:20px; padding:15px; border:none; border-radius:999px; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:14.5px; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:8px; transition:all .2s var(--ease); }
  .checkout-btn:hover{ transform:translateY(-2px); box-shadow:0 16px 30px -14px rgba(0,122,61,0.5); }

  .empty-state{ text-align:center; padding:80px 30px; background:var(--white); border:1px dashed var(--neutral-2); border-radius:var(--radius-lg); color:var(--text-2); }
  .empty-state .icon-circle{ width:70px; height:70px; border-radius:50%; background:var(--neutral-1); display:flex; align-items:center; justify-content:center; margin:0 auto 18px; color:var(--text-2); }
  .empty-state h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:20px; color:var(--text-1); margin:0 0 8px; }
  .empty-state p{ margin:0 0 22px; font-size:14px; }
  .browse-btn{ display:inline-flex; align-items:center; gap:8px; padding:13px 26px; border-radius:999px; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:14px; transition:all .2s var(--ease); }
  .browse-btn:hover{ transform:translateY(-2px); }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); }
    .main-area{ margin-left:0; }
    .cart-layout{ grid-template-columns:1fr; }
    .summary-panel{ position:static; }
  }
  .topbar-right{ display:flex; align-items:center; gap:12px; }
  .user-chip{ display:flex; align-items:center; gap:10px; padding:6px 14px 6px 6px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); }
  .user-avatar{ width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center; background:linear-gradient(135deg, var(--red), var(--green)); color:#fff; font-weight:700; font-size:13px; flex-shrink:0; }
  .u-name{ font-size:13px; font-weight:600; }
</style>
</head>
<body>

<div class="keffiyeh-corner-bg"></div>

<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
        <div class="mark"><img src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="HerjaHub" /></div><div class="name">HerjaHub</div>
    </a>
    <div class="side-label">Shop</div>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/dashboard"><i data-lucide="layout-dashboard" width="18" height="18"></i> Dashboard</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/products"><i data-lucide="shopping-bag" width="18" height="18"></i> Products</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/stores"><i data-lucide="store" width="18" height="18"></i> Stores</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/ai"><i data-lucide="sparkles" width="18" height="18"></i> AI Assistant</a>
    <a class="side-link active" href="${pageContext.request.contextPath}/customer/cart"><i data-lucide="shopping-cart" width="18" height="18"></i> Cart</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/orders"><i data-lucide="package" width="18" height="18"></i> My Orders</a>
    <div class="side-label">Account</div>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/profile/edit"><i data-lucide="user" width="18" height="18"></i> Edit Profile</a>
    <div class="sidebar-footer">
        <a class="side-link" href="${pageContext.request.contextPath}/logout" style="color:var(--red);"><i data-lucide="log-out" width="18" height="18"></i> Log out</a>
    </div>
</aside>

<div class="main-area">
    <div class="topbar">
        <div class="topbar-title">Cart</div>
<div class="topbar-right">
    <div class="user-chip">
        <div class="user-avatar"><c:out value="${fn:substring(customer.firstName, 0, 1)}" /></div>
        <span class="u-name"><c:out value="${customer.firstName}" /></span>
    </div>
</div>
    </div>

    <div class="page">
        <h1 class="page-title">Your Cart</h1>
        <p class="page-sub">Review your items and check out when you're ready.</p>

        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="empty-state">
                    <div class="icon-circle"><i data-lucide="shopping-cart" width="30" height="30"></i></div>
                    <h3>Your cart is empty</h3>
                    <p>Browse our collection of authentic Palestinian crafts.</p>
                    <a class="browse-btn" href="${pageContext.request.contextPath}/customer/products">
                        <i data-lucide="shopping-bag" width="16" height="16"></i> Start Shopping
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:set var="cartTotal" value="0" />
                <div class="cart-layout">
                    <div class="cart-list">
                        <c:forEach var="item" items="${cartItems}" varStatus="i">
                            <c:set var="cartTotal" value="${cartTotal + item.subtotal}" />
                            <div class="cart-line" style="animation-delay:${i.index * 0.04}s">
                                <div class="cart-thumb">
                                    <c:choose>
                                        <c:when test="${not empty item.product.image}">
                                            <img src="${pageContext.request.contextPath}${item.product.image}" alt="${item.product.productName}"
                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                                            <img src="${pageContext.request.contextPath}/resources/images/product-placeholder.jpg" alt="No image available" style="display:none;" />
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/resources/images/product-placeholder.jpg" alt="No image available" />
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="cart-name"><c:out value="${item.product.productName}" /></div>
                                <span class="cart-qty">Qty: <c:out value="${item.quantity}" /></span>
                                <span class="cart-subtotal">$<c:out value="${item.subtotal}" /></span>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="summary-panel">
                        <h3>Order Summary</h3>
                        <c:forEach var="item" items="${cartItems}">
                            <div class="summary-line">
                                <span><c:out value="${item.product.productName}" /></span>
                                <span>$<c:out value="${item.subtotal}" /></span>
                            </div>
                        </c:forEach>
                        <div class="summary-total">
                            <span>Total</span>
                            <span>$<c:out value="${cartTotal}" /></span>
                        </div>
                        <form action="${pageContext.request.contextPath}/customer/cart/checkout" method="post">
                            <button type="submit" class="checkout-btn">
                                <i data-lucide="check-circle-2" width="17" height="17"></i> Proceed to Checkout
                            </button>
                        </form>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>lucide.createIcons();</script>
</body>
</html>
