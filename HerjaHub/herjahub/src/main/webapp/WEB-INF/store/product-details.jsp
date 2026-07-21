<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${product.productName}" /> — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --red:#CE1126; --green:#007A3D; --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF;
    --text-1:#1F2937; --text-2:#6B7280; --amber:#B45309; --amber-bg:#FEF3E2; --gold:#C9A227;
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

  .keffiyeh-corner-bg{ position:fixed; inset:0; z-index:0; pointer-events:none;
    background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
    background-repeat:no-repeat; background-position:bottom right; background-size:min(70vw, 900px); opacity:0.06;
    -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
    mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%); }

  .page{ max-width:1000px; margin:0 auto; padding:32px 32px 60px; }

  .page-header{ display:flex; align-items:center; gap:16px; margin-bottom:18px; animation:fadeInUp .4s var(--ease); }
  .back-btn{ width:42px; height:42px; border-radius:14px; border:1px solid var(--neutral-2); background:var(--white); display:flex; align-items:center; justify-content:center; color:var(--text-2); transition:all .2s var(--ease); flex-shrink:0; }
  .back-btn:hover{ border-color:var(--green); color:var(--green); }
  .page-title{ font-family:'Poppins',sans-serif; font-weight:800; font-size:24px; margin:0; }
  .page-sub{ color:var(--text-2); font-size:13.5px; margin:2px 0 0; }

  /* ===================== SIGNATURE: read-only glance layout - image + stat blocks, no forms ===================== */
  .meta-bar{ display:flex; gap:22px; flex-wrap:wrap; margin-bottom:22px; padding:16px 20px; background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-md); animation:fadeInUp .4s var(--ease) .05s backwards; }
  .meta-item{ display:flex; align-items:center; gap:8px; font-size:13px; color:var(--text-2); }
  .meta-item svg{ flex-shrink:0; }
  .meta-item strong{ color:var(--text-1); }
  .meta-item .star{ color:var(--gold); }

  .view-grid{ display:grid; grid-template-columns:340px 1fr; gap:22px; align-items:start; margin-bottom:20px; }

  .image-panel{ background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-lg); overflow:hidden; box-shadow:var(--shadow-sm); animation:fadeInUp .4s var(--ease) backwards; position:relative; }
  .image-panel .img-wrap{ aspect-ratio:1/1; background:var(--neutral-1); display:flex; align-items:center; justify-content:center; overflow:hidden; }
  .image-panel img{ width:100%; height:100%; object-fit:cover; }
  .stock-badge{ position:absolute; top:12px; right:12px; padding:5px 12px; border-radius:999px; font-size:11.5px; font-weight:700; }
  .stock-badge.ok{ background:rgba(0,122,61,0.1); color:var(--green); }
  .stock-badge.low{ background:var(--amber-bg); color:var(--amber); }
  .stock-badge.out{ background:#FBEAEA; color:var(--red); }

  .info-panel{ background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-lg); padding:26px; box-shadow:var(--shadow-sm); animation:fadeInUp .4s var(--ease) .05s backwards; }
  .info-name{ font-family:'Poppins',sans-serif; font-weight:800; font-size:22px; margin:0 0 10px; }
  .info-price{ font-family:'Poppins',sans-serif; font-weight:800; font-size:26px; background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; margin:0 0 18px; }
  .info-desc{ color:var(--text-2); font-size:14px; line-height:1.7; margin:0 0 22px; white-space:pre-line; }
  .info-desc.empty{ font-style:italic; color:var(--text-2); opacity:.7; }

  .stat-row{ display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:22px; }
  .stat-block{ background:var(--neutral-1); border-radius:var(--radius-md); padding:14px 16px; }
  .stat-block-label{ font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.05em; color:var(--text-2); margin-bottom:4px; }
  .stat-block-value{ font-family:'Poppins',sans-serif; font-weight:800; font-size:18px; }

  .actions-row{ display:flex; gap:12px; flex-wrap:wrap; }
  .btn-cancel{ padding:13px 24px; border-radius:999px; border:1.5px solid var(--neutral-2); font-weight:700; font-size:13.5px; color:var(--text-1); transition:all .2s var(--ease); }
  .btn-cancel:hover{ background:var(--neutral-1); }
  .btn-submit{ display:flex; align-items:center; gap:8px; padding:13px 26px; border-radius:999px; border:none; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:13.5px; cursor:pointer; transition:all .2s var(--ease); }
  .btn-submit:hover{ transform:translateY(-2px); box-shadow:0 14px 26px -14px rgba(0,122,61,0.5); }

  .comments-panel{ margin-top:24px; background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-lg); padding:24px; box-shadow:var(--shadow-sm); }
  .panel-head{ display:flex; align-items:center; gap:12px; margin-bottom:20px; }
  .panel-icon{ width:36px; height:36px; border-radius:11px; background:rgba(0,122,61,0.1); color:var(--green); display:flex; align-items:center; justify-content:center; flex-shrink:0; }
  .panel-head h2{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; margin:0; }
  .comment-row{ padding:14px 0; border-bottom:1px solid var(--neutral-2); }
  .comment-row:last-child{ border-bottom:none; padding-bottom:0; }
  .comment-top{ display:flex; align-items:center; justify-content:space-between; font-size:13.5px; margin-bottom:5px; }
  .comment-rating{ display:flex; align-items:center; gap:4px; color:var(--gold); font-weight:700; }
  .comment-text{ color:var(--text-2); font-size:13px; margin:0; }
  .empty-note{ text-align:center; padding:24px; color:var(--text-2); font-size:13.5px; }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); transition:transform .3s ease; }
    .sidebar.open{ transform:translateX(0); }
    .menu-btn{ display:flex; }
    .sidebar-overlay.show{ display:block; }
    .main-area{ margin-left:0; }
    .view-grid{ grid-template-columns:1fr; }
  }
  @media (max-width: 480px){
    .stat-row{ grid-template-columns:1fr; }
  }

  .menu-btn{ display:flex; width:40px; height:40px; border-radius:12px; border:1px solid var(--neutral-2); background:var(--white); color:var(--text-1); align-items:center; justify-content:center; cursor:pointer; flex-shrink:0; }
  .sidebar-overlay{ display:none; position:fixed; inset:0; z-index:25; background:rgba(17,17,17,0.35); }

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
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/store/dashboard">
        <div class="mark"><img src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="HerjaHub" /></div>
        <div class="name">Herja<span class="hub-accent">Hub</span></div>
    </a>
    <div class="side-label">Overview</div>
    <a class="side-link" href="${pageContext.request.contextPath}/store/dashboard">
        <i data-lucide="layout-dashboard" width="18" height="18"></i> Dashboard
    </a>
    <div class="side-label">Manage</div>
    <a class="side-link active" href="${pageContext.request.contextPath}/store/products">
        <i data-lucide="shopping-bag" width="18" height="18"></i> Products
    </a>
    <a class="side-link" href="${pageContext.request.contextPath}/store/edit">
        <i data-lucide="store" width="18" height="18"></i> Store Profile
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
        <div class="topbar-title">Product Details</div>
        <div class="user-chip">
            <div class="user-avatar"><c:out value="${fn:substring(store.storeName, 0, 1)}" /></div>
            <span class="u-name"><c:out value="${store.storeName}" /></span>
        </div>
    </div>

    <div class="page">

        <div class="page-header">
            <a class="back-btn" href="${pageContext.request.contextPath}/store/products">
                <i data-lucide="arrow-left" width="18" height="18"></i>
            </a>
            <div>
                <h1 class="page-title"><c:out value="${product.productName}" /></h1>
                <p class="page-sub">How this product looks, plus what customers are saying.</p>
            </div>
        </div>

        <c:set var="mn" value="${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']}"/>
        <c:set var="ratingSum" value="${0}" />
        <c:forEach var="cm" items="${comments}"><c:set var="ratingSum" value="${ratingSum + cm.rating}" /></c:forEach>

        <%-- ===== Meta stats bar ===== --%>
        <div class="meta-bar">
            <div class="meta-item">
                <i data-lucide="calendar" width="15" height="15"></i>
                Created <strong>${mn[product.createdAt.monthValue - 1]} ${product.createdAt.dayOfMonth}, ${product.createdAt.year}</strong>
            </div>
            <c:if test="${not empty product.updatedAt}">
                <div class="meta-item">
                    <i data-lucide="clock" width="15" height="15"></i>
                    Updated <strong>${mn[product.updatedAt.monthValue - 1]} ${product.updatedAt.dayOfMonth}, ${product.updatedAt.year}</strong>
                </div>
            </c:if>
            <div class="meta-item">
                <i data-lucide="star" width="15" height="15" class="star"></i>
                <c:choose>
                    <c:when test="${not empty comments}">
                        <strong><fmt:formatNumber value="${ratingSum / fn:length(comments)}" maxFractionDigits="1" /> / 5</strong>&nbsp;(${fn:length(comments)} review<c:if test="${fn:length(comments) != 1}">s</c:if>)
                    </c:when>
                    <c:otherwise>No reviews yet</c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- ===== Image + info ===== --%>
        <div class="view-grid">
            <div class="image-panel">
                <div class="img-wrap">
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
                </div>
                <c:if test="${product.quantity == 0}">
                    <span class="stock-badge out">Out of stock</span>
                </c:if>
                <c:if test="${product.quantity > 0 && product.quantity <= 5}">
                    <span class="stock-badge low">Low stock</span>
                </c:if>
                <c:if test="${product.quantity > 5}">
                    <span class="stock-badge ok">In stock</span>
                </c:if>
            </div>

            <div class="info-panel">
                <h2 class="info-name"><c:out value="${product.productName}" /></h2>
                <p class="info-price">$<fmt:formatNumber value="${product.price}" minFractionDigits="2" maxFractionDigits="2" /></p>

                <c:choose>
                    <c:when test="${not empty product.description}">
                        <p class="info-desc"><c:out value="${product.description}" /></p>
                    </c:when>
                    <c:otherwise>
                        <p class="info-desc empty">No description added yet.</p>
                    </c:otherwise>
                </c:choose>

                <div class="stat-row">
                    <div class="stat-block">
                        <div class="stat-block-label">Quantity in Stock</div>
                        <div class="stat-block-value">${product.quantity}</div>
                    </div>
                    <div class="stat-block">
                        <div class="stat-block-label">Reviews</div>
                        <div class="stat-block-value">${fn:length(comments)}</div>
                    </div>
                </div>

                <div class="actions-row">
                    <a class="btn-submit" href="${pageContext.request.contextPath}/store/products/${product.id}/edit">
                        <i data-lucide="pencil" width="16" height="16"></i> Edit Product
                    </a>
                    <a class="btn-cancel" href="${pageContext.request.contextPath}/store/products">Back to Products</a>
                </div>
            </div>
        </div>

        <%-- ===== Comments ===== --%>
        <div class="comments-panel">
            <div class="panel-head">
                <div class="panel-icon"><i data-lucide="message-square" width="17" height="17"></i></div>
                <h2>Comments</h2>
            </div>
            <c:choose>
                <c:when test="${not empty comments}">
                    <c:forEach var="cm" items="${comments}">
                        <div class="comment-row">
                            <div class="comment-top">
                                <strong><c:out value="${cm.customerName}" /></strong>
                                <span class="comment-rating">${cm.rating}/5 <i data-lucide="star" width="12" height="12"></i></span>
                            </div>
                            <p class="comment-text"><c:out value="${cm.comment}" /></p>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-note">No comments on this product yet.</div>
                </c:otherwise>
            </c:choose>
        </div>
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
