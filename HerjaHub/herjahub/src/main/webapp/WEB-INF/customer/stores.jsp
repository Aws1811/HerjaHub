<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Stores — HerjaHub</title>
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
    background-image:
      radial-gradient(700px 480px at -10% -10%, rgba(206,17,38,0.05), transparent 60%),
      radial-gradient(700px 480px at 110% 0%, rgba(0,122,61,0.06), transparent 60%);
    background-attachment:fixed;
  }
  a{ text-decoration:none; color:inherit; }
  @keyframes fadeInUp{ from{opacity:0; transform:translateY(10px);} to{opacity:1; transform:translateY(0);} }

  /* ===== Reusable app shell ===== */
  .sidebar{
    position:fixed; top:0; left:0; bottom:0; width:var(--sidebar-w); z-index:30;
    background:rgba(255,255,255,0.7); backdrop-filter:blur(20px); -webkit-backdrop-filter:blur(20px);
    border-right:1px solid rgba(255,255,255,0.6);
    display:flex; flex-direction:column; padding:22px 16px;
  }
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

  .topbar{
    position:sticky; top:0; z-index:20; height:var(--topbar-h);
    display:flex; align-items:center; justify-content:space-between; gap:16px; padding:0 28px;
    background:rgba(255,255,255,0.65); backdrop-filter:blur(18px); -webkit-backdrop-filter:blur(18px);
    border-bottom:1px solid rgba(255,255,255,0.5);
  }
  .topbar-title{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; }
  .logout-btn{ display:flex; align-items:center; gap:6px; padding:9px 14px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); font-size:13px; font-weight:600; color:var(--text-2); transition:all .2s var(--ease); }
  .logout-btn:hover{ color:var(--red); border-color:var(--red); }

  .keffiyeh-corner-bg{
    position:fixed; inset:0; z-index:0; pointer-events:none;
    background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
    background-repeat:no-repeat; background-position:bottom right; background-size:min(70vw, 900px);
    opacity:0.06;
    -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
    mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
  }

  .page{ max-width:1160px; padding:36px 32px 60px; }

  /* ===================== SIGNATURE FOR THIS PAGE: simple text header + list-style cards ===================== */
  .page-head{ margin-bottom:30px; animation:fadeInUp .5s var(--ease); }
  .page-head h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:30px; margin:0; }
  .page-head p{ color:var(--text-2); font-size:14px; margin:6px 0 0; }

  /* Wide list-style cards (deliberately different from the square-grid rhythm
     used on Products/Dashboard) - each row is a full-width strip */
  .store-list{ display:flex; flex-direction:column; gap:14px; }
  .store-row{
    display:flex; align-items:center; gap:20px; background:var(--white);
    border:1px solid var(--neutral-2); border-radius:var(--radius-lg); padding:22px 26px;
    transition:all .25s var(--ease); animation:fadeInUp .4s var(--ease) backwards;
  }
  .store-row:hover{ transform:translateX(4px); box-shadow:var(--shadow-md); border-color:var(--green); }

  .store-avatar{
    width:64px; height:64px; flex-shrink:0; border-radius:20px;
    background:linear-gradient(135deg,var(--red),var(--green)); color:#fff;
    font-family:'Poppins',sans-serif; font-weight:800; font-size:24px;
    display:flex; align-items:center; justify-content:center;
  }
  .store-avatar img{ width:100%; height:100%; object-fit:cover; border-radius:20px; }

  .store-info{ flex:1; min-width:0; }
  .store-info h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:17px; margin:0 0 4px; }
  .store-info p{ color:var(--text-2); font-size:13.5px; margin:0; line-height:1.5; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }

  .store-meta{ display:flex; flex-direction:column; gap:6px; flex-shrink:0; text-align:right; }
  .store-meta .meta-row{ display:flex; align-items:center; gap:6px; justify-content:flex-end; font-size:12.5px; color:var(--text-2); }
  .store-meta .meta-row svg{ flex-shrink:0; }

  .empty-state{ text-align:center; padding:70px 30px; background:var(--white); border:1px dashed var(--neutral-2); border-radius:var(--radius-lg); color:var(--text-2); }
  .empty-state h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:19px; color:var(--text-1); margin:0 0 6px; }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); }
    .main-area{ margin-left:0; }
    .store-row{ flex-wrap:wrap; }
    .store-meta{ text-align:left; align-items:flex-start; width:100%; }
  }
    .topbar-right{ display:flex; align-items:center; gap:12px; }
    .user-chip{ display:flex; align-items:center; gap:10px; padding:6px 14px 6px 6px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); }
    .user-avatar{ width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center; background:linear-gradient(135deg, var(--red), var(--green)); color:#fff; font-weight:700; font-size:13px; flex-shrink:0; }
    .u-name{ font-size:13px; font-weight:600; }
</style>
</head>
<body>

<div class="keffiyeh-corner-bg"></div>

<%-- ===================== SIDEBAR ===================== --%>
<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
        <div class="mark"><img src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="HerjaHub" /></div>
        <div class="name">HerjaHub</div>
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

<div class="main-area">

    <%-- ===================== TOPBAR ===================== --%>
    <div class="topbar">
        <div class="topbar-title">Stores</div>
<div class="topbar-right">
    <div class="user-chip">
        <div class="user-avatar"><c:out value="${fn:substring(customer.firstName, 0, 1)}" /></div>
        <span class="u-name"><c:out value="${customer.firstName}" /></span>
    </div>
</div>
    </div>

    <div class="page">

        <div class="page-head">
            <h1>All Stores</h1>
            <p>Every artisan storefront on HerjaHub.</p>
        </div>

        <c:choose>
            <c:when test="${empty stores}">
                <div class="empty-state">
                    <h3>No stores yet</h3>
                    <p>Check back soon as more artisans join HerjaHub.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="store-list">
                    <c:forEach var="store" items="${stores}" varStatus="i">
                        <div class="store-row" style="animation-delay:${i.index * 0.04}s">

                            <div class="store-avatar">
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

                            <div class="store-info">
                                <h3><c:out value="${store.storeName}" /></h3>
                                <c:choose>
                                    <c:when test="${empty store.description}">
                                        <p style="color:var(--text-2); font-style:italic;">No description yet.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p><c:out value="${store.description}" /></p>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="store-meta">
                                <c:if test="${not empty store.address}">
                                    <div class="meta-row"><i data-lucide="map-pin" width="13" height="13"></i> <c:out value="${store.address}" /></div>
                                </c:if>
                                <c:if test="${not empty store.phone}">
                                    <div class="meta-row"><i data-lucide="phone" width="13" height="13"></i> <c:out value="${store.phone}" /></div>
                                </c:if>
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
