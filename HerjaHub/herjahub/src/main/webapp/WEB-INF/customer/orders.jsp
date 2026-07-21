<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Orders — HerjaHub</title>
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
  .sidebar-brand .mark{ width:38px; height:38px; border-radius:12px; flex-shrink:0; background:linear-gradient(135deg, var(--red), var(--green)); display:flex; align-items:center; justify-content:center; color:var(--white); font-family:'Poppins',sans-serif; font-weight:800; }
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

  .page{ max-width:900px; padding:36px 32px 60px; }
  .page-title{ font-family:'Poppins',sans-serif; font-weight:800; font-size:28px; margin:0 0 6px; }
  .page-sub{ color:var(--text-2); font-size:14px; margin:0 0 34px; }

  /* ===================== SIGNATURE: vertical timeline of order receipts ===================== */
  .timeline{ position:relative; padding-left:34px; }
  .timeline::before{ content:""; position:absolute; left:9px; top:8px; bottom:8px; width:2px; background:linear-gradient(180deg, var(--red), var(--green)); opacity:.25; }

  .timeline-item{ position:relative; margin-bottom:20px; animation:fadeInUp .4s var(--ease) backwards; }
  .timeline-dot{ position:absolute; left:-34px; top:22px; width:20px; height:20px; border-radius:50%; background:var(--white); border:3px solid var(--green); box-shadow:0 0 0 4px var(--neutral-1); }

  .order-card{ background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-lg); padding:22px 26px; transition:all .22s var(--ease); }
  .order-card:hover{ box-shadow:var(--shadow-md); transform:translateX(3px); }
  .order-top{ display:flex; align-items:center; gap:12px; margin-bottom:6px; flex-wrap:wrap; }
  .order-top h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; margin:0; }
  .status-badge{ padding:5px 13px; border-radius:999px; font-size:11px; font-weight:700; background:#FDF3E2; color:#8A6D13; }
  .order-date{ color:var(--text-2); font-size:13px; margin:0 0 16px; }
  .order-bottom{ display:flex; align-items:center; justify-content:space-between; gap:16px; padding-top:14px; border-top:1px solid var(--neutral-2); }
  .order-total{ font-family:'Poppins',sans-serif; font-weight:800; font-size:19px; background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }
  .order-total-label{ font-size:11px; color:var(--text-2); font-weight:600; display:block; margin-bottom:2px; }
  .view-btn{ display:inline-flex; align-items:center; gap:6px; padding:10px 20px; border-radius:999px; border:1.5px solid var(--green); color:var(--green); font-weight:700; font-size:13px; transition:all .2s var(--ease); }
  .view-btn:hover{ background:var(--green); color:#fff; }

  .empty-state{ text-align:center; padding:80px 30px; background:var(--white); border:1px dashed var(--neutral-2); border-radius:var(--radius-lg); color:var(--text-2); }
  .empty-state .icon-circle{ width:70px; height:70px; border-radius:50%; background:var(--neutral-1); display:flex; align-items:center; justify-content:center; margin:0 auto 18px; color:var(--text-2); }
  .empty-state h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:20px; color:var(--text-1); margin:0 0 8px; }
  .empty-state p{ margin:0 0 22px; font-size:14px; }
  .browse-btn{ display:inline-flex; align-items:center; gap:8px; padding:13px 26px; border-radius:999px; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:14px; transition:all .2s var(--ease); }
  .browse-btn:hover{ transform:translateY(-2px); }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); }
    .main-area{ margin-left:0; }
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
        <div class="mark">ه</div><div class="name">HerjaHub</div>
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

<div class="main-area">
    <div class="topbar">
        <div class="topbar-title">My Orders</div>
<div class="topbar-right">
    <div class="user-chip">
        <div class="user-avatar"><c:out value="${fn:substring(customer.firstName, 0, 1)}" /></div>
        <span class="u-name"><c:out value="${customer.firstName}" /></span>
    </div>
</div>
    </div>

    <div class="page">
        <h1 class="page-title">My Orders</h1>
        <p class="page-sub">Track and review everything you've purchased.</p>

        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty-state">
                    <div class="icon-circle"><i data-lucide="package" width="30" height="30"></i></div>
                    <h3>No orders yet</h3>
                    <p>Start shopping to see your orders here.</p>
                    <a class="browse-btn" href="${pageContext.request.contextPath}/customer/products">
                        <i data-lucide="shopping-bag" width="16" height="16"></i> Browse Products
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="timeline">
                    <c:forEach var="order" items="${orders}" varStatus="i">
                        <c:set var="orderTotal" value="0" />
                        <c:forEach var="item" items="${order.orderItems}">
                            <c:set var="orderTotal" value="${orderTotal + (item.price * item.quantity)}" />
                        </c:forEach>

                        <div class="timeline-item" style="animation-delay:${i.index * 0.05}s">
                            <div class="timeline-dot"></div>
                            <div class="order-card">
                                <div class="order-top">
                                    <h3>Order #<c:out value="${order.id}" /></h3>
                                    <span class="status-badge">Pending</span>
                                </div>
                                <p class="order-date">Placed on <c:out value="${order.createdAt}" /></p>
                                <div class="order-bottom">
                                    <div>
                                        <span class="order-total-label">Total</span>
                                        <span class="order-total">$<c:out value="${orderTotal}" /></span>
                                    </div>
                                    <a class="view-btn" href="${pageContext.request.contextPath}/customer/orders/${order.id}/confirmation">
                                        View <i data-lucide="arrow-right" width="14" height="14"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>lucide.createIcons();</script>
</body>
</html>
