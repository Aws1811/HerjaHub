<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
  .user-chip{ display:flex; align-items:center; gap:10px; padding:6px 14px 6px 6px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); }
  .user-avatar{ width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center; background:linear-gradient(135deg, var(--red), var(--green)); color:#fff; font-weight:700; font-size:13px; flex-shrink:0; }
  .u-name{ font-size:13px; font-weight:600; }

  .keffiyeh-corner-bg{ position:fixed; inset:0; z-index:0; pointer-events:none;
    background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
    background-repeat:no-repeat; background-position:bottom right; background-size:min(70vw, 900px); opacity:0.06;
    -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
    mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%); }

  .page{ max-width:1200px; padding:32px 32px 60px; }

  /* ===================== SIGNATURE: toolbar (search + count + add) over a thumbnail grid with an inline add-tile ===================== */
  .page-header{ display:flex; align-items:flex-end; justify-content:space-between; gap:16px; margin-bottom:22px; animation:fadeInUp .4s var(--ease); }
  .page-title{ font-family:'Poppins',sans-serif; font-weight:800; font-size:26px; margin:0; }
  .page-sub{ color:var(--text-2); font-size:13.5px; margin:4px 0 0; }
  .count-pill{ display:inline-flex; align-items:center; gap:6px; padding:3px 11px; border-radius:999px; background:rgba(0,122,61,0.1); color:var(--green); font-size:12px; font-weight:700; margin-left:10px; vertical-align:middle; }

  .toolbar{ display:flex; align-items:center; justify-content:space-between; gap:14px; margin-bottom:24px; flex-wrap:wrap; animation:fadeInUp .4s var(--ease) .05s backwards; }
  .search-box{ position:relative; flex:1; min-width:220px; max-width:360px; }
  .search-box svg{ position:absolute; left:14px; top:50%; transform:translateY(-50%); color:var(--text-2); pointer-events:none; }
  .search-box input{ width:100%; padding:11px 14px 11px 40px; border:1px solid var(--neutral-2); border-radius:999px; background:var(--white); font-size:13.5px; font-family:'Inter',sans-serif; transition:all .2s var(--ease); }
  .search-box input:focus{ outline:none; border-color:var(--green); box-shadow:0 0 0 3px rgba(0,122,61,0.12); }
  .btn-add{ display:flex; align-items:center; gap:8px; padding:12px 22px; border-radius:999px; border:none; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:13.5px; cursor:pointer; transition:all .2s var(--ease); flex-shrink:0; }
  .btn-add:hover{ transform:translateY(-2px); box-shadow:0 14px 26px -14px rgba(0,122,61,0.5); }

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
  .image-placeholder{ color:var(--text-2); font-size:12px; margin:0; display:flex; flex-direction:column; align-items:center; gap:6px; }
  .stock-badge{ position:absolute; top:10px; right:10px; padding:4px 10px; border-radius:999px; font-size:11px; font-weight:700; }
  .stock-badge.low{ background:var(--amber-bg); color:var(--amber); }
  .stock-badge.out{ background:#FBEAEA; color:var(--red); }
  .product-body{ padding:14px 16px 16px; display:flex; flex-direction:column; gap:5px; flex:1; }
  .product-name{ font-weight:700; font-size:14.5px; margin:0; color:var(--text-1); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .product-meta{ display:flex; align-items:center; justify-content:space-between; margin-top:2px; }
  .product-price{ margin:0; font-weight:800; font-size:15px; background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }
  .product-qty{ font-size:11.5px; color:var(--text-2); font-weight:600; }

  .add-tile{ display:flex; flex-direction:column; align-items:center; justify-content:center; gap:8px; min-height:100%; border:2px dashed rgba(0,122,61,0.3); border-radius:var(--radius-md); background:rgba(0,122,61,0.04); color:var(--green); text-align:center; cursor:pointer; transition:all .2s var(--ease); padding:20px; animation:fadeInUp .45s var(--ease) backwards; }
  .add-tile:hover{ background:rgba(0,122,61,0.08); border-color:var(--green); transform:translateY(-6px); }
  .add-tile .add-icon{ width:44px; height:44px; border-radius:50%; background:rgba(0,122,61,0.12); display:flex; align-items:center; justify-content:center; }
  .add-tile-title{ font-weight:700; font-size:13.5px; }
  .add-tile-sub{ font-size:11.5px; color:var(--text-2); }

  .empty-state{ text-align:center; padding:70px 30px; background:rgba(255,255,255,0.7); backdrop-filter:blur(10px); border:1px dashed var(--neutral-2); border-radius:var(--radius-lg); color:var(--text-2); animation:fadeInUp .4s var(--ease); }
  .empty-state .empty-icon{ width:56px; height:56px; border-radius:50%; background:rgba(0,122,61,0.1); color:var(--green); display:flex; align-items:center; justify-content:center; margin:0 auto 14px; }
  .empty-state h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:19px; color:var(--text-1); margin:0 0 6px; }
  .empty-state p{ font-size:13.5px; margin:0 0 20px; }

  #no-results{ display:none; text-align:center; padding:50px 20px; color:var(--text-2); font-size:13.5px; }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); }
    .main-area{ margin-left:0; }
    .page-header{ flex-direction:column; align-items:flex-start; }
  }
</style>
</head>
<body>

<div class="keffiyeh-corner-bg"></div>

<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/store/dashboard">
        <div class="mark">ه</div><div class="name">HerjaHub</div>
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

<div class="main-area">
    <div class="topbar">
        <div class="topbar-title">Products</div>
        <div class="user-chip">
            <div class="user-avatar"><c:out value="${fn:substring(store.storeName, 0, 1)}" /></div>
            <span class="u-name"><c:out value="${store.storeName}" /></span>
        </div>
    </div>

    <div class="page">

        <div class="page-header">
            <div>
                <h1 class="page-title">Products<span class="count-pill"><i data-lucide="package" width="12" height="12"></i> ${fn:length(products)}</span></h1>
                <p class="page-sub">Everything currently listed in your storefront.</p>
            </div>
        </div>

        <div class="toolbar">
            <div class="search-box">
                <i data-lucide="search" width="16" height="16"></i>
                <input type="text" id="product-search" placeholder="Search your products..." autocomplete="off" />
            </div>
            <a class="btn-add" href="${pageContext.request.contextPath}/store/products/add">
                <i data-lucide="plus" width="16" height="16"></i> Add Product
            </a>
        </div>

        <c:choose>
            <c:when test="${empty products}">
                <div class="empty-state">
                    <div class="empty-icon"><i data-lucide="shopping-bag" width="26" height="26"></i></div>
                    <h3>No products yet</h3>
                    <p>List your first handmade item to open your storefront.</p>
                    <a class="btn-add" href="${pageContext.request.contextPath}/store/products/add" style="display:inline-flex;">
                        <i data-lucide="plus" width="16" height="16"></i> Add Product
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="product-grid" id="product-grid">
                    <c:forEach var="product" items="${products}" varStatus="i">
                        <a class="product-card" data-name="${fn:toLowerCase(product.productName)}"
                           href="${pageContext.request.contextPath}/store/products/${product.id}/edit"
                           style="animation-delay:${i.index * 0.04}s">
                            <div class="product-image-wrap">
                                <c:choose>
                                    <c:when test="${empty product.image}">
                                        <p class="image-placeholder"><i data-lucide="image" width="22" height="22"></i> No image</p>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${product.image}" alt="${product.productName}" />
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${product.quantity == 0}">
                                    <span class="stock-badge out">Out of stock</span>
                                </c:if>
                                <c:if test="${product.quantity > 0 && product.quantity <= 5}">
                                    <span class="stock-badge low">Low stock</span>
                                </c:if>
                            </div>
                            <div class="product-body">
                                <p class="product-name"><c:out value="${product.productName}" /></p>
                                <div class="product-meta">
                                    <p class="product-price">$<c:out value="${product.price}" /></p>
                                    <span class="product-qty">${product.quantity} in stock</span>
                                </div>
                            </div>
                        </a>
                    </c:forEach>

                    <a class="add-tile" href="${pageContext.request.contextPath}/store/products/add">
                        <div class="add-icon"><i data-lucide="plus" width="20" height="20"></i></div>
                        <div class="add-tile-title">Add Product</div>
                        <div class="add-tile-sub">List something new</div>
                    </a>
                </div>

                <div id="no-results">
                    <i data-lucide="search-x" width="26" height="26"></i>
                    <p>No products match your search.</p>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</div>

<script>lucide.createIcons();</script>

<script>
  var searchInput = document.getElementById('product-search');
  if (searchInput) {
    searchInput.addEventListener('input', function() {
      var term = searchInput.value.trim().toLowerCase();
      var cards = document.querySelectorAll('#product-grid .product-card');
      var visibleCount = 0;
      cards.forEach(function(card) {
        var matches = card.getAttribute('data-name').indexOf(term) !== -1;
        card.style.display = matches ? '' : 'none';
        if (matches) visibleCount++;
      });
      var noResults = document.getElementById('no-results');
      if (noResults) {
        noResults.style.display = (term && visibleCount === 0) ? 'block' : 'none';
      }
    });
  }
</script>

</body>
</html>
