<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Products — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --red:#CE1126; --green:#007A3D; --black:#111111;
    --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF;
    --text-1:#1F2937; --text-2:#6B7280;
    --radius-lg:24px; --radius-md:18px; --radius-sm:12px;
    --shadow-sm:0 4px 16px rgba(31,41,55,0.06);
    --shadow-md:0 18px 40px -16px rgba(31,41,55,0.18);
    --ease:cubic-bezier(.4,0,.2,1);
    --sidebar-w:250px; --topbar-h:68px;
  }
  *{box-sizing:border-box;}
  html,body{ height:100%; }
  body{
    margin:0; font-family:'Inter',sans-serif; color:var(--text-1);
    background:var(--neutral-1);
    /* the reusable keffiyeh-glow backdrop - decorative only, applied to every page */
    background-image:
      radial-gradient(700px 480px at -10% -10%, rgba(206,17,38,0.055), transparent 60%),
      radial-gradient(700px 480px at 110% 0%, rgba(0,122,61,0.06), transparent 60%),
      radial-gradient(600px 420px at 60% 120%, rgba(0,0,0,0.025), transparent 60%);
    background-attachment:fixed;
  }
  a{ text-decoration:none; color:inherit; }
  @keyframes fadeInUp{ from{opacity:0; transform:translateY(10px);} to{opacity:1; transform:translateY(0);} }

  /* Real keffiyeh pattern, fixed behind everything, anchored at the bottom-right
     corner and faded out toward the rest of the page via a mask - so it reads as
     a subtle corner watermark instead of a busy tiled background. Kept on its own
     layer (not on body's own background) so the mask doesn't also fade out the
     page's base color / soft color glows. */
  .keffiyeh-corner-bg{
    position:fixed; inset:0; z-index:0; pointer-events:none;
    background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
    background-repeat:no-repeat;
    background-position:bottom right;
    background-size:min(70vw, 900px);
    opacity:0.07;
    -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
    mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
  }

  /* ===================== APP SHELL (reused on every page) ===================== */

  .sidebar{
    position:fixed; top:0; left:0; bottom:0; width:var(--sidebar-w); z-index:30;
    background:rgba(255,255,255,0.7); backdrop-filter:blur(20px); -webkit-backdrop-filter:blur(20px);
    border-right:1px solid rgba(255,255,255,0.6);
    display:flex; flex-direction:column; padding:22px 16px;
  }
  .sidebar-brand{ display:flex; align-items:center; gap:10px; padding:6px 10px 26px; }
  .sidebar-brand .mark{
    width:38px; height:38px; border-radius:12px; flex-shrink:0; overflow:hidden;
    background:linear-gradient(135deg, var(--red), var(--green));
    display:flex; align-items:center; justify-content:center; color:var(--white); font-family:'Poppins',sans-serif; font-weight:800;
  }
  .sidebar-brand .mark img{ width:100%; height:100%; object-fit:cover; }
  .sidebar-brand .name{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; }

  .side-label{ font-size:10.5px; font-weight:700; text-transform:uppercase; letter-spacing:.08em; color:var(--text-2); padding:14px 12px 8px; }
  .side-link{
    display:flex; align-items:center; gap:12px; padding:11px 12px; border-radius:var(--radius-sm);
    font-weight:600; font-size:14px; color:var(--text-1); margin-bottom:3px; transition:all .22s var(--ease); position:relative;
  }
  .side-link svg{ flex-shrink:0; opacity:.8; }
  .side-link:hover{ background:var(--neutral-2); }
  .side-link.active{
    background:linear-gradient(90deg, rgba(206,17,38,0.1), rgba(0,122,61,0.1));
    color:var(--text-1); box-shadow:inset 0 0 0 1px rgba(0,122,61,0.15);
  }
  .side-link.active svg{ opacity:1; color:var(--green); }
  .side-link.active::before{
    content:""; position:absolute; left:-16px; top:8px; bottom:8px; width:4px; border-radius:4px;
    background:linear-gradient(180deg, var(--red), var(--green));
  }

  .sidebar-footer{ margin-top:auto; padding-top:14px; border-top:1px solid var(--neutral-2); }

  .main-area{ margin-left:var(--sidebar-w); min-height:100%; display:flex; flex-direction:column; position:relative; z-index:1; }

  .topbar{
    position:sticky; top:0; z-index:20; height:var(--topbar-h);
    display:flex; align-items:center; justify-content:space-between; gap:16px; padding:0 28px;
    background:rgba(255,255,255,0.65); backdrop-filter:blur(18px); -webkit-backdrop-filter:blur(18px);
    border-bottom:1px solid rgba(255,255,255,0.5);
  }
  .topbar-title{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; }
  .topbar-right{ display:flex; align-items:center; gap:12px; }
  .user-chip{ display:flex; align-items:center; gap:10px; padding:6px 14px 6px 6px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); }
  .user-avatar{
    width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center;
    background:linear-gradient(135deg, var(--red), var(--green)); color:var(--white); font-weight:700; font-size:13px; flex-shrink:0;
  }
  .user-chip .u-name{ font-size:13px; font-weight:600; }
  .logout-btn{ display:flex; align-items:center; gap:6px; padding:9px 14px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); font-size:13px; font-weight:600; color:var(--text-2); transition:all .2s var(--ease); }
  .logout-btn:hover{ color:var(--red); border-color:var(--red); }

  .test-nav{ padding:8px 28px; font-size:11.5px; color:var(--text-2); background:rgba(255,255,255,0.4); }
  .test-nav a{ color:var(--text-2); }
  .test-nav a:hover{ color:var(--red); }

  .page{ max-width:1160px; padding:26px 28px 60px; width:100%; }

  /* ===================== PAGE CONTENT ===================== */

  .hero{
    position:relative; overflow:hidden; border-radius:var(--radius-lg);
    padding:42px 38px 54px; margin-bottom:28px;
    box-shadow:var(--shadow-md);
    animation:fadeInUp .5s var(--ease);
  }
  .hero::before{
    content:""; position:absolute; inset:-40px; z-index:0;
    background:
      linear-gradient(120deg, rgba(206,17,38,0.9) 0%,  rgba(0,122,61,0.85) 55%, rgba(255,255,255,0.8) 78%, rgba(17,17,17,0.55) 100%),
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
  .hero-eyebrow{ color:rgba(255,255,255,0.85); font-weight:700; font-size:12px; letter-spacing:.08em; text-transform:uppercase; margin:0 0 8px; }
  .hero h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:32px; color:var(--white); margin:0; text-shadow:0 2px 12px rgba(0,0,0,0.25); }
  .hero p{ color:rgba(255,255,255,0.88); margin:8px 0 0; font-size:14px; max-width:480px; }

  .muted{ color:var(--text-2); font-size:13px; margin:0; }

  .product-grid{ display:grid; grid-template-columns:repeat(auto-fill, minmax(220px, 1fr)); gap:20px; }
  .product-card{
    position:relative;
    background:rgba(255,255,255,0.85); backdrop-filter:blur(10px); -webkit-backdrop-filter:blur(10px);
    border:1px solid rgba(255,255,255,0.6); border-radius:var(--radius-md); overflow:hidden;
    box-shadow:var(--shadow-sm); transition:transform .3s var(--ease), box-shadow .3s var(--ease);
    animation:fadeInUp .45s var(--ease) backwards;
  }
  .product-card:hover{ transform:translateY(-6px) scale(1.015); box-shadow:var(--shadow-md); }
  .product-card a{ display:flex; flex-direction:column; height:100%; }
  .product-image-wrap{ aspect-ratio:1/1; background:var(--neutral-2); display:flex; align-items:center; justify-content:center; overflow:hidden; position:relative; }
  .product-image-wrap img{ width:100%; height:100%; object-fit:cover; transition:transform .4s var(--ease); }
  .product-card:hover .product-image-wrap img{ transform:scale(1.06); }
  .image-placeholder{ color:var(--text-2); font-size:12.5px; margin:0; }
  .corner-accent{ position:absolute; top:0; right:0; width:36px; height:36px; background:linear-gradient(135deg, var(--red), var(--green)); clip-path:polygon(100% 0, 0 0, 100% 100%); opacity:.85; }
  .out-of-stock-badge{ position:absolute; top:10px; left:10px; z-index:2; background:rgba(17,17,17,0.82); color:#fff; font-size:10.5px; font-weight:700; letter-spacing:.03em; text-transform:uppercase; padding:5px 10px; border-radius:999px; }
  .product-card.is-out-of-stock .product-image-wrap img{ filter:grayscale(0.6); opacity:.55; }
  .product-body{ padding:15px 17px; display:flex; flex-direction:column; gap:6px; flex:1; }
  .product-name{ font-weight:700; font-size:14.5px; margin:0; color:var(--text-1); }
  .product-price{ margin:0; font-weight:800; font-size:15px; background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }

  .empty-state{ text-align:center; padding:70px 30px; background:rgba(255,255,255,0.7); backdrop-filter:blur(10px); border:1px dashed var(--neutral-2); border-radius:var(--radius-lg); color:var(--text-2); }
  .empty-state h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:19px; color:var(--text-1); margin:0 0 6px; }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); }
    .main-area{ margin-left:0; }
  }
  .search-bar{
    display:flex; align-items:center; gap:10px; max-width:420px; margin:20px 0 20px;
    background:rgba(255,255,255,0.8); backdrop-filter:blur(16px); -webkit-backdrop-filter:blur(16px);
    border:1px solid rgba(255,255,255,0.6); border-radius:999px; padding:11px 18px;
    box-shadow:var(--shadow-sm); color:var(--text-2);
  }
  .search-bar input{ flex:1; border:none; outline:none; background:transparent; font-size:13.5px; font-family:'Inter',sans-serif; color:var(--text-1); }
  .search-bar input::placeholder{ color:#9CA3AF; }
  .clear-btn{ color:var(--text-2); display:flex; }
  .clear-btn:hover{ color:var(--red); }

  .filter-bar{ display:flex; align-items:center; flex-wrap:wrap; gap:14px; margin:0 0 24px; }
  .price-filter{
    display:flex; align-items:center; gap:10px;
    background:rgba(255,255,255,0.8); backdrop-filter:blur(16px); -webkit-backdrop-filter:blur(16px);
    border:1px solid rgba(255,255,255,0.6); border-radius:999px; padding:9px 16px;
    box-shadow:var(--shadow-sm); color:var(--text-2); font-size:13px;
  }
  .price-filter label{ font-weight:600; font-size:12px; color:var(--text-2); white-space:nowrap; }
  .price-filter input{
    width:78px; border:none; outline:none; background:var(--neutral-1); border-radius:999px;
    padding:6px 12px; font-size:13px; font-family:'Inter',sans-serif; color:var(--text-1);
  }
  .price-filter .dash{ color:var(--text-2); }
  .filter-clear{ display:flex; align-items:center; gap:6px; font-size:12.5px; font-weight:600; color:var(--text-2); padding:9px 14px; border-radius:999px; border:1px solid var(--neutral-2); background:rgba(255,255,255,0.6); transition:all .2s var(--ease); }
  .filter-clear:hover{ color:var(--red); border-color:var(--red); }
  .grid-loading{ text-align:center; padding:40px; color:var(--text-2); font-size:13px; }
  #productGrid{ transition:opacity .15s var(--ease); }
</style>
</head>
<body style="--keffiyeh-pattern: url('data:image/svg+xml;utf8,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%22140%22 height=%22140%22><g fill=%22none%22 stroke=%22%23ffffff%22 stroke-width=%222%22 opacity=%220.5%22><path d=%22M0 70 L70 0 L140 70 L70 140 Z%22/><path d=%22M70 0 L70 140%22/><path d=%22M0 70 L140 70%22/></g></svg>')">

<%-- ===== Real keffiyeh pattern, fading in from the bottom-right corner, behind everything ===== --%>
<div class="keffiyeh-corner-bg"></div>

<%-- ===================== SIDEBAR (reusable shell) ===================== --%>
<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
        <div class="mark"><img src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="HerjaHub" /></div>
        <div class="name">HerjaHub</div>
    </a>

    <div class="side-label">Shop</div>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/dashboard">
        <i data-lucide="layout-dashboard" width="18" height="18"></i> Dashboard
    </a>
    <a class="side-link active" href="${pageContext.request.contextPath}/customer/products">
        <i data-lucide="shopping-bag" width="18" height="18"></i> Products
    </a>
    <%-- Note: no confirmed customer-facing "all stores" route yet - pointing here for now --%>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/stores">
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

<div class="main-area">

    <%-- ===================== TOPBAR (reusable shell) ===================== --%>
    <div class="topbar">
        <div class="topbar-title">Products</div>
        <div class="topbar-right">
            <div class="user-chip">
                <div class="user-avatar"><c:out value="${fn:substring(customer.firstName, 0, 1)}" /></div>
                <span class="u-name"><c:out value="${customer.firstName}" /></span>
            </div>

        </div>
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

 <%-- ===== Search bar + price filter ===== --%>
  <form id="filterForm" class="search-bar" action="${pageContext.request.contextPath}/customer/products" method="get">
      <i data-lucide="search" width="17" height="17"></i>
      <input type="text" id="searchInput" name="q" value="${q}" placeholder="Search products..." autocomplete="off" />
      <c:if test="${not empty q}">
          <a class="clear-btn" href="${pageContext.request.contextPath}/customer/products">
              <i data-lucide="x" width="15" height="15"></i>
          </a>
      </c:if>
  </form>

  <div class="filter-bar">
      <div class="price-filter">
          <label for="minPriceInput">Price</label>
          <input type="number" id="minPriceInput" min="0" step="0.01" placeholder="Min" value="${minPrice}" />
          <span class="dash">&ndash;</span>
          <input type="number" id="maxPriceInput" min="0" step="0.01" placeholder="Max" value="${maxPrice}" />
      </div>
      <a href="${pageContext.request.contextPath}/customer/products" class="filter-clear" id="clearFiltersBtn">
          <i data-lucide="rotate-ccw" width="13" height="13"></i> Clear filters
      </a>
  </div>

        <%-- ===== Product grid (swapped in-place by the AJAX search/filter) ===== --%>
        <div id="productGrid">
            <jsp:include page="products-grid.jsp" />
        </div>

    </div>
</div>

<script>
(function() {
    var searchInput = document.getElementById('searchInput');
    var minPriceInput = document.getElementById('minPriceInput');
    var maxPriceInput = document.getElementById('maxPriceInput');
    var clearFiltersBtn = document.getElementById('clearFiltersBtn');
    var productGrid = document.getElementById('productGrid');
    var contextPath = '${pageContext.request.contextPath}';
    var debounceTimer = null;
    var currentRequest = null;

    function buildParams() {
        var params = new URLSearchParams();
        if (searchInput.value.trim()) params.set('q', searchInput.value.trim());
        if (minPriceInput.value) params.set('minPrice', minPriceInput.value);
        if (maxPriceInput.value) params.set('maxPrice', maxPriceInput.value);
        return params;
    }

    function fetchGrid() {
        var params = buildParams();

        // keep the URL (and back button / refresh / share link) in sync with the current filters
        var newUrl = contextPath + '/customer/products' + (params.toString() ? '?' + params.toString() : '');
        window.history.replaceState(null, '', newUrl);

        if (currentRequest) {
            currentRequest.abort();
        }
        var controller = new AbortController();
        currentRequest = controller;

        productGrid.style.opacity = '0.5';

        fetch(contextPath + '/customer/products/grid?' + params.toString(), { signal: controller.signal })
            .then(function(res) { return res.text(); })
            .then(function(html) {
                productGrid.innerHTML = html;
                productGrid.style.opacity = '1';
                if (window.lucide) { lucide.createIcons(); }
            })
            .catch(function(err) {
                if (err.name !== 'AbortError') {
                    productGrid.style.opacity = '1';
                }
            });
    }

    function debouncedFetch() {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(fetchGrid, 300);
    }

    searchInput.addEventListener('input', debouncedFetch);
    minPriceInput.addEventListener('input', debouncedFetch);
    maxPriceInput.addEventListener('input', debouncedFetch);

    clearFiltersBtn.addEventListener('click', function(e) {
        e.preventDefault();
        searchInput.value = '';
        minPriceInput.value = '';
        maxPriceInput.value = '';
        fetchGrid();
    });

    // stop the plain form submit (no-JS fallback) from doing a full page reload once JS is active
    document.getElementById('filterForm').addEventListener('submit', function(e) {
        e.preventDefault();
        fetchGrid();
    });
})();
</script>

<script>lucide.createIcons();</script>
</body>
</html>
