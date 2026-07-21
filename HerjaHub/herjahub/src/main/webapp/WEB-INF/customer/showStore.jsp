<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${store.storeName}" /> — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --red:#CE1126; --green:#007A3D; --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF;
    --text-1:#1F2937; --text-2:#6B7280; --amber:#B45309; --amber-bg:#FEF3E2;
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
  .cart-btn{ position:relative; margin-left:auto; width:40px; height:40px; border-radius:50%; background:var(--white); border:1px solid var(--neutral-2); display:flex; align-items:center; justify-content:center; color:var(--text-1); transition:all .2s ease; flex-shrink:0; }
  .cart-btn:hover{ border-color:var(--green); color:var(--green); }
  .cart-count{ position:absolute; top:-4px; right:-4px; min-width:17px; height:17px; padding:0 4px; border-radius:999px; background:var(--red); color:#fff; font-size:10px; font-weight:700; display:flex; align-items:center; justify-content:center; }
  .menu-btn{ display:flex; width:40px; height:40px; border-radius:12px; border:1px solid var(--neutral-2); background:var(--white); color:var(--text-1); align-items:center; justify-content:center; cursor:pointer; flex-shrink:0; }
  .sidebar-overlay{ display:none; position:fixed; inset:0; z-index:25; background:rgba(17,17,17,0.35); }

  .keffiyeh-corner-bg{ position:fixed; inset:0; z-index:0; pointer-events:none;
    background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
    background-repeat:no-repeat; background-position:bottom right; background-size:min(70vw, 900px); opacity:0.06;
    -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
    mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%); }

  .page{ max-width:1100px; margin:0 auto; padding:32px 32px 60px; }

  .back-row{ margin-bottom:18px; animation:fadeInUp .4s var(--ease); }
  .back-btn{ display:inline-flex; align-items:center; gap:8px; padding:10px 18px; border-radius:999px; border:1px solid var(--neutral-2); background:var(--white); font-weight:600; font-size:13px; color:var(--text-2); transition:all .2s var(--ease); }
  .back-btn:hover{ border-color:var(--green); color:var(--green); }

  /* ===================== SIGNATURE: public store hero (banner + logo + meta) over its product grid ===================== */
  .store-hero{ position:relative; border-radius:var(--radius-lg); overflow:hidden; box-shadow:var(--shadow-md); margin-bottom:26px; animation:fadeInUp .4s var(--ease) .05s backwards; background:var(--white); }
  .store-banner{ height:120px; background:linear-gradient(120deg,var(--red),var(--green)); position:relative; }
  .store-banner::after{ content:""; position:absolute; inset:0; background:radial-gradient(circle at 85% 20%, rgba(255,255,255,0.18), transparent 55%); }
  .store-identity{ display:flex; align-items:flex-end; gap:18px; padding:0 28px 20px; margin-top:-40px; position:relative; z-index:2; flex-wrap:wrap; }
  .store-logo{ width:88px; height:88px; border-radius:22px; border:5px solid var(--white); box-shadow:var(--shadow-sm); flex-shrink:0; overflow:hidden; background:linear-gradient(135deg,var(--red),var(--green)); display:flex; align-items:center; justify-content:center; color:#fff; font-family:'Poppins',sans-serif; font-weight:800; font-size:32px; }
  .store-logo img{ width:100%; height:100%; object-fit:cover; }
  .store-title h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:23px; margin:0 0 14px; }
  .store-body{ padding:0 28px 22px; }
  .store-desc{ color:var(--text-2); font-size:14px; line-height:1.7; margin:0 0 16px; max-width:640px; }
  .store-desc.empty{ font-style:italic; opacity:.7; }
  .store-meta{ display:flex; gap:22px; flex-wrap:wrap; }
  .meta-item{ display:flex; align-items:center; gap:7px; font-size:13px; color:var(--text-2); }
  .meta-item svg{ color:var(--green); flex-shrink:0; }

  .section-head{ display:flex; align-items:baseline; gap:10px; margin-bottom:18px; animation:fadeInUp .4s var(--ease) .1s backwards; }
  .section-head h2{ font-family:'Poppins',sans-serif; font-weight:800; font-size:20px; margin:0; }
  .count-pill{ display:inline-flex; align-items:center; gap:6px; padding:3px 11px; border-radius:999px; background:rgba(0,122,61,0.1); color:var(--green); font-size:12px; font-weight:700; }

  .product-grid{ display:grid; grid-template-columns:repeat(auto-fill, minmax(220px, 1fr)); gap:20px; }
  .product-card{
    background:rgba(255,255,255,0.85); backdrop-filter:blur(10px); -webkit-backdrop-filter:blur(10px);
    border:1px solid rgba(255,255,255,0.6); border-radius:var(--radius-md); overflow:hidden;
    box-shadow:var(--shadow-sm); transition:transform .3s var(--ease), box-shadow .3s var(--ease);
    animation:fadeInUp .45s var(--ease) backwards; display:flex; flex-direction:column;
  }
  .product-card:hover{ transform:translateY(-6px) scale(1.015); box-shadow:var(--shadow-md); }
  .product-image-wrap{ position:relative; aspect-ratio:1/1; background:var(--neutral-2); display:flex; align-items:center; justify-content:center; overflow:hidden; }
  .product-image-wrap img{ width:100%; height:100%; object-fit:cover; transition:transform .4s var(--ease); }
  .product-card:hover .product-image-wrap img{ transform:scale(1.06); }
  .stock-badge{ position:absolute; top:10px; right:10px; padding:4px 10px; border-radius:999px; font-size:11px; font-weight:700; }
  .stock-badge.out{ background:#FBEAEA; color:var(--red); }
  .product-body{ padding:14px 16px 16px; display:flex; flex-direction:column; gap:5px; flex:1; }
  .product-name{ font-weight:700; font-size:14.5px; margin:0; color:var(--text-1); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .product-price{ margin:0; font-weight:800; font-size:15px; background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }

  .empty-state{ text-align:center; padding:60px 30px; background:rgba(255,255,255,0.7); backdrop-filter:blur(10px); border:1px dashed var(--neutral-2); border-radius:var(--radius-lg); color:var(--text-2); animation:fadeInUp .4s var(--ease); }
  .empty-state h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:18px; color:var(--text-1); margin:0 0 6px; }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); transition:transform .3s ease; }
    .sidebar.open{ transform:translateX(0); }
    .menu-btn{ display:flex; }
    .sidebar-overlay.show{ display:block; }
    .main-area{ margin-left:0; }
  }

  /* ===== Sidebar toggle - works at any screen size, higher specificity beats the responsive defaults above ===== */
  .sidebar, .main-area{ transition:transform .28s ease, margin-left .28s ease; }
  body.sidebar-hidden .sidebar{ transform:translateX(-100%); }
  body.sidebar-hidden .main-area{ margin-left:0; }
  body:not(.sidebar-hidden) .sidebar{ transform:translateX(0); }
  @media (min-width:901px){
    body:not(.sidebar-hidden) .main-area{ margin-left:var(--sidebar-w); }
  }
  @media (max-width:900px){
    body:not(.sidebar-hidden) .sidebar-overlay{ display:block; }
  }
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
    <a class="side-link" href="${pageContext.request.contextPath}/customer/dashboard">
        <i data-lucide="layout-dashboard" width="18" height="18"></i> Dashboard
    </a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/products">
        <i data-lucide="shopping-bag" width="18" height="18"></i> Products
    </a>
    <a class="side-link active" href="${pageContext.request.contextPath}/customer/stores">
        <i data-lucide="store" width="18" height="18"></i> Stores
    </a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/ai">
        <i data-lucide="sparkles" width="18" height="18"></i> AI Assistant
    </a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/cart">
        <i data-lucide="shopping-cart" width="18" height="18"></i> Cart
    </a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/orders">
        <i data-lucide="package" width="18" height="18"></i> My Orders
    </a>

    <div class="side-label">Account</div>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/profile/edit">
        <i data-lucide="user" width="18" height="18"></i> Edit Profile
    </a>

    <div class="sidebar-footer">
        <a class="side-link" href="${pageContext.request.contextPath}/logout" style="color:var(--red);">
            <i data-lucide="log-out" width="18" height="18"></i> Log out
        </a>
    </div>
</aside>

<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="main-area">
    <div class="topbar">
        <button class="menu-btn" id="menuBtn" type="button" aria-label="Toggle sidebar"><i data-lucide="menu" width="20" height="20"></i></button>
        <div class="topbar-title"><c:out value="${store.storeName}" /></div>
        <a class="cart-btn" href="${pageContext.request.contextPath}/customer/cart" title="View cart"><i data-lucide="shopping-cart" width="18" height="18"></i><c:if test="${not empty sessionScope.cart}"><span class="cart-count">${fn:length(sessionScope.cart)}</span></c:if></a>
        <div class="user-chip">
            <div class="user-avatar"><c:out value="${fn:substring(customer.firstName, 0, 1)}" /></div>
            <span class="u-name"><c:out value="${customer.firstName}" /></span>
        </div>
    </div>

    <div class="page">

        <div class="back-row">
            <a class="back-btn" href="${pageContext.request.contextPath}/customer/stores">
                <i data-lucide="arrow-left" width="15" height="15"></i> All Stores
            </a>
        </div>

        <%-- ===== Store hero ===== --%>
        <div class="store-hero">
            <div class="store-banner"></div>
            <div class="store-identity">
                <div class="store-logo">
                    <c:choose>
                        <c:when test="${not empty store.image}">
                            <img src="${pageContext.request.contextPath}${store.image}" alt="${store.storeName}"
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='inline';" />
                            <span style="display:none;"><c:out value="${fn:substring(store.storeName, 0, 1)}" /></span>
                        </c:when>
                        <c:otherwise>
                            <c:out value="${fn:substring(store.storeName, 0, 1)}" />
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="store-title">
                    <h1><c:out value="${store.storeName}" /></h1>
                </div>
            </div>
            <div class="store-body">
                <c:choose>
                    <c:when test="${not empty store.description}">
                        <p class="store-desc"><c:out value="${store.description}" /></p>
                    </c:when>
                    <c:otherwise>
                        <p class="store-desc empty">This store hasn't added a description yet.</p>
                    </c:otherwise>
                </c:choose>
                <div class="store-meta">
                    <c:if test="${not empty store.address}">
                        <div class="meta-item"><i data-lucide="map-pin" width="14" height="14"></i> <c:out value="${store.address}" /></div>
                    </c:if>
                    <c:if test="${not empty store.phone}">
                        <div class="meta-item"><i data-lucide="phone" width="14" height="14"></i> <c:out value="${store.phone}" /></div>
                    </c:if>
                    <c:if test="${not empty store.createdAt}">
                        <c:set var="mn" value="${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']}"/>
                        <div class="meta-item"><i data-lucide="calendar" width="14" height="14"></i> Joined ${mn[store.createdAt.monthValue - 1]} ${store.createdAt.year}</div>
                    </c:if>
                </div>
            </div>
        </div>

        <%-- ===== The store's products ===== --%>
        <div class="section-head">
            <h2>Products</h2>
            <span class="count-pill"><i data-lucide="package" width="12" height="12"></i> ${fn:length(store.products)}</span>
        </div>

        <c:choose>
            <c:when test="${empty store.products}">
                <div class="empty-state">
                    <h3>No products yet</h3>
                    <p style="margin:0;">This store hasn't listed anything so far - check back soon.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="product" items="${store.products}" varStatus="i">
                        <a class="product-card" href="${pageContext.request.contextPath}/customer/products/${product.id}"
                           style="animation-delay:${i.index * 0.04}s">
                            <div class="product-image-wrap">
                                <c:choose>
                                    <c:when test="${not empty product.image}">
                                        <img src="${pageContext.request.contextPath}${product.image}" alt="${product.productName}"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                                        <img src="${pageContext.request.contextPath}/resources/images/product-placeholder.jpg" alt="No image available" style="display:none;" />
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/resources/images/product-placeholder.jpg" alt="No image available" />
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${product.quantity == null || product.quantity <= 0}">
                                    <span class="stock-badge out">Out of stock</span>
                                </c:if>
                            </div>
                            <div class="product-body">
                                <p class="product-name"><c:out value="${product.productName}" /></p>
                                <p class="product-price">$<fmt:formatNumber value="${product.price}" minFractionDigits="2" maxFractionDigits="2" /></p>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</div>

<script>lucide.createIcons();</script>

<script>
  (function(){
    var btn = document.getElementById('menuBtn'), overlay = document.getElementById('sidebarOverlay');
    function isMobile(){ return window.matchMedia('(max-width:900px)').matches; }
    if (isMobile()) { document.body.classList.add('sidebar-hidden'); } // start closed on small screens only
    if (btn) btn.addEventListener('click', function(){ document.body.classList.toggle('sidebar-hidden'); });
    if (overlay) overlay.addEventListener('click', function(){ document.body.classList.add('sidebar-hidden'); });
  })();
</script>

</body>
</html>
