<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Confirmation — HerjaHub</title>
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
  @keyframes popIn{ from{opacity:0; transform:scale(.85);} to{opacity:1; transform:scale(1);} }

  .sidebar{ position:fixed; top:0; left:0; bottom:0; width:var(--sidebar-w); z-index:30; background:rgba(255,255,255,0.7); backdrop-filter:blur(20px); -webkit-backdrop-filter:blur(20px); border-right:1px solid rgba(255,255,255,0.6); display:flex; flex-direction:column; padding:22px 16px; }
  .sidebar-brand{ display:flex; align-items:center; gap:10px; padding:6px 10px 26px; }
  .sidebar-brand .mark{ width:38px; height:38px; border-radius:12px; flex-shrink:0; overflow:hidden; background:linear-gradient(135deg, var(--red), var(--green)); display:flex; align-items:center; justify-content:center; color:var(--white); font-family:'Poppins',sans-serif; font-weight:800; }
  .sidebar-brand .mark img{ width:100%; height:100%; object-fit:cover; }
  .sidebar-brand .name{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; }
  .sidebar-brand .name .hub-accent{ background:linear-gradient(90deg, #CE1126, #007A3D); -webkit-background-clip:text; background-clip:text; color:transparent; }
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
  .user-chip{ display:flex; align-items:center; gap:10px; padding:6px 14px 6px 6px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); }
  .user-avatar{ width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center; background:linear-gradient(135deg, var(--red), var(--green)); color:#fff; font-weight:700; font-size:13px; flex-shrink:0; }
  .u-name{ font-size:13px; font-weight:600; }

  .keffiyeh-corner-bg{ position:fixed; inset:0; z-index:0; pointer-events:none;
    background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
    background-repeat:no-repeat; background-position:bottom right; background-size:min(70vw, 900px); opacity:0.06;
    -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
    mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%); }

  /* ===================== SIGNATURE: centered celebratory receipt, no sidebar-width page shell ===================== */
  .stage{ min-height:calc(100% - var(--topbar-h)); display:flex; align-items:center; justify-content:center; padding:40px 24px; }

  .receipt-card{
    width:100%; max-width:480px; background:var(--white); border:1px solid var(--neutral-2);
    border-radius:var(--radius-lg); padding:40px 34px 34px; text-align:center;
    box-shadow:var(--shadow-md); animation:fadeInUp .5s var(--ease);
  }
  .success-orb{
    width:76px; height:76px; margin:0 auto 20px; border-radius:50%;
    background:linear-gradient(135deg,var(--red),var(--green)); color:#fff;
    display:flex; align-items:center; justify-content:center;
    box-shadow:0 16px 30px -12px rgba(0,122,61,0.45);
    animation:popIn .4s var(--ease) .1s backwards;
  }
  .receipt-card h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:24px; margin:0 0 8px; }
  .receipt-card .sub{ color:var(--text-2); font-size:14px; margin:0 0 28px; }

  .receipt-box{ background:var(--neutral-1); border-radius:var(--radius-md); padding:20px 22px; text-align:left; margin-bottom:26px; }
  .receipt-line{ display:flex; justify-content:space-between; align-items:center; font-size:13.5px; padding:7px 0; }
  .receipt-line span:first-child{ color:var(--text-2); }
  .receipt-line span:last-child{ font-weight:700; }
  .receipt-total{ border-top:1px solid var(--neutral-2); margin-top:6px; padding-top:14px; }
  .receipt-total span:last-child{ font-family:'Poppins',sans-serif; font-weight:800; font-size:19px; background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }

  .receipt-actions{ display:flex; flex-direction:column; gap:10px; }
  .btn-primary{ display:flex; align-items:center; justify-content:center; gap:8px; padding:14px; border:none; border-radius:999px; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:14px; transition:all .2s var(--ease); }
  .btn-primary:hover{ transform:translateY(-2px); box-shadow:0 16px 30px -14px rgba(0,122,61,0.5); }
  .btn-secondary{ display:flex; align-items:center; justify-content:center; gap:8px; padding:14px; border-radius:999px; border:1.5px solid var(--neutral-2); font-weight:700; font-size:14px; color:var(--text-1); transition:all .2s var(--ease); }
  .btn-secondary:hover{ background:var(--neutral-1); }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); transition:transform .3s ease; }
    .sidebar.open{ transform:translateX(0); }
    .menu-btn{ display:flex; }
    .sidebar-overlay.show{ display:block; }
    .main-area{ margin-left:0; }
  }

  .menu-btn{ display:none; width:40px; height:40px; border-radius:12px; border:1px solid var(--neutral-2); background:var(--white); color:var(--text-1); align-items:center; justify-content:center; cursor:pointer; flex-shrink:0; }
  .sidebar-overlay{ display:none; position:fixed; inset:0; z-index:25; background:rgba(17,17,17,0.35); }
</style>
</head>
<body>

<div class="keffiyeh-corner-bg"></div>

<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
        <div class="mark"><img src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="HerjaHub" /></div>
        <div class="name">Herja<span class="hub-accent">Hub</span></div>
    </a>
    <div class="side-label">Shop</div>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/dashboard"><i data-lucide="layout-dashboard" width="18" height="18"></i> Dashboard</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/products"><i data-lucide="shopping-bag" width="18" height="18"></i> Products</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/stores"><i data-lucide="store" width="18" height="18"></i> Stores</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/ai"><i data-lucide="sparkles" width="18" height="18"></i> AI Assistant</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/cart"><i data-lucide="shopping-cart" width="18" height="18"></i> Cart</a>
    <a class="side-link active" href="${pageContext.request.contextPath}/customer/orders"><i data-lucide="package" width="18" height="18"></i> My Orders</a>
    <div class="side-label">Account</div>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/profile/edit"><i data-lucide="user" width="18" height="18"></i> Edit Profile</a>
    <div class="sidebar-footer">
        <a class="side-link" href="${pageContext.request.contextPath}/logout" style="color:var(--red);"><i data-lucide="log-out" width="18" height="18"></i> Log out</a>
    </div>
</aside>

<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="main-area">
    <div class="topbar">
        <button class="menu-btn" id="menuBtn" type="button" aria-label="Open menu"><i data-lucide="menu" width="20" height="20"></i></button>
        <div class="topbar-title">Order Confirmation</div>
        <div class="user-chip">
            <div class="user-avatar"><c:out value="${fn:substring(customer.firstName, 0, 1)}" /></div>
            <span class="u-name"><c:out value="${customer.firstName}" /></span>
        </div>
    </div>

    <div class="stage">
        <div class="receipt-card">
            <div class="success-orb">
                <i data-lucide="check" width="34" height="34"></i>
            </div>
            <h1>Order placed successfully!</h1>
            <p class="sub">Thank you for supporting Palestinian artisans.</p>

            <c:set var="orderTotal" value="0" />
            <c:forEach var="item" items="${order.orderItems}">
                <c:set var="orderTotal" value="${orderTotal + (item.price * item.quantity)}" />
            </c:forEach>

            <div class="receipt-box">
                <div class="receipt-line"><span>Order #</span><span>#<c:out value="${order.id}" /></span></div>
                <div class="receipt-line"><span>Date</span><span><c:out value="${order.createdAt}" /></span></div>
                <div class="receipt-line receipt-total"><span>Total</span><span>$<fmt:formatNumber value="${orderTotal}" minFractionDigits="2" maxFractionDigits="2" /></span></div>
            </div>

            <div class="receipt-actions">
                <a class="btn-primary" href="${pageContext.request.contextPath}/customer/orders">
                    <i data-lucide="package" width="16" height="16"></i> View My Orders
                </a>
                <a class="btn-secondary" href="${pageContext.request.contextPath}/customer/products">
                    <i data-lucide="shopping-bag" width="16" height="16"></i> Continue Shopping
                </a>
            </div>
        </div>
    </div>
</div>

<script>lucide.createIcons();</script>

<script>
  (function(){
    var b=document.getElementById('menuBtn'), s=document.querySelector('.sidebar'), o=document.getElementById('sidebarOverlay');
    if(!b||!s||!o) return;
    b.addEventListener('click', function(){ s.classList.add('open'); o.classList.add('show'); });
    o.addEventListener('click', function(){ s.classList.remove('open'); o.classList.remove('show'); });
  })();
</script>
</body>
</html>
