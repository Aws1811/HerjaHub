<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Product Details — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;0,6..72,700;1,6..72,500&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --olive:#4B5D3A; --olive-dark:#39492B; --olive-light:#EEF1E6;
    --sage:#93A57F; --ivory:#FBF8F0; --white:#FFFFFF;
    --gold:#C9A227; --gold-light:#F8F0DA;
    --charcoal:#2B2A24; --muted:#7C7969;
    --border:#E9E4D6; --error:#B3483F; --error-bg:#FBEAE8;
    --success:#4F7A3D; --success-bg:#EAF2E1; --warn:#B07A1E; --warn-bg:#FBF1DE;
    --radius-lg:20px; --radius-md:14px; --radius-sm:10px;
    --shadow-sm:0 2px 10px rgba(43,41,35,0.05);
    --shadow-md:0 16px 40px -18px rgba(43,41,35,0.22);
  }
  *{box-sizing:border-box;}
  body{ margin:0; font-family:'Inter',sans-serif; background:var(--ivory); color:var(--charcoal); }
  a{ color:inherit; }

  .topbar{ display:flex; align-items:center; justify-content:space-between; padding:16px 32px; background:var(--white); border-bottom:1px solid var(--border); }
  .brand{ display:flex; align-items:center; gap:10px; font-family:'Newsreader',serif; font-weight:600; font-size:20px; color:var(--olive-dark); }
  .brand .mark{ width:36px; height:36px; border-radius:11px; background:linear-gradient(155deg,var(--olive),var(--olive-dark)); color:var(--gold-light); display:flex; align-items:center; justify-content:center; }

  .page-wrap{ max-width:900px; margin:0 auto; padding:32px 24px 60px; }

  .page-header{ display:flex; align-items:center; gap:14px; margin-bottom:22px; }
  .back-link{ width:38px; height:38px; border-radius:11px; border:1px solid var(--border); background:var(--white); display:flex; align-items:center; justify-content:center; color:var(--muted); text-decoration:none; }
  .back-link:hover{ background:var(--olive-light); color:var(--olive-dark); }
  .page-header h1{ font-family:'Newsreader',serif; font-weight:600; font-size:27px; margin:0; }
  .page-header p{ margin:2px 0 0; color:var(--muted); font-size:14px; }
  .header-actions{ margin-left:auto; display:flex; gap:10px; }

  .btn{ border:none; border-radius:var(--radius-sm); padding:11px 20px; font-weight:700; font-size:14px; cursor:pointer; font-family:'Inter',sans-serif; display:inline-flex; align-items:center; gap:8px; transition:transform .15s ease, box-shadow .15s ease; text-decoration:none; }
  .btn-primary{ background:var(--olive); color:#fff; box-shadow:var(--shadow-sm); }
  .btn-primary:hover{ background:var(--olive-dark); transform:translateY(-1px); box-shadow:var(--shadow-md); }
  .btn-ghost{ background:var(--white); color:var(--charcoal); border:1px solid var(--border); }
  .btn-ghost:hover{ background:var(--olive-light); }

  .detail-card{ background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); box-shadow:var(--shadow-sm); overflow:hidden; margin-bottom:20px; display:flex; gap:0; }
  .detail-image{ width:280px; flex-shrink:0; background:var(--olive-light) center/contain no-repeat; display:flex; align-items:center; justify-content:center; color:var(--sage); }
  .detail-body{ padding:28px; flex:1; min-width:0; }
  .detail-top{ display:flex; align-items:flex-start; justify-content:space-between; gap:14px; margin-bottom:6px; }
  .detail-body h2{ font-family:'Newsreader',serif; font-size:24px; margin:0; }
  .detail-price{ font-family:'Newsreader',serif; font-size:22px; font-weight:600; color:var(--olive-dark); white-space:nowrap; }
  .badge{ display:inline-flex; align-items:center; gap:5px; padding:5px 11px; border-radius:999px; font-size:12px; font-weight:700; margin-bottom:14px; }
  .badge.in-stock{ background:var(--success-bg); color:var(--success); }
  .badge.low-stock{ background:var(--warn-bg); color:var(--warn); }
  .badge.out-of-stock{ background:var(--error-bg); color:var(--error); }
  .detail-desc{ color:var(--muted); font-size:14.5px; line-height:1.6; margin-bottom:20px; }

  .stat-strip{ display:grid; grid-template-columns:repeat(4,1fr); gap:14px; }
  .stat-mini{ text-align:center; padding:12px 8px; border-radius:var(--radius-sm); background:var(--ivory); border:1px solid var(--border); }
  .stat-mini .n{ font-family:'Newsreader',serif; font-size:19px; font-weight:600; }
  .stat-mini .l{ font-size:11.5px; color:var(--muted); font-weight:600; margin-top:2px; }

  .meta-row{ display:flex; gap:22px; flex-wrap:wrap; margin-top:18px; font-size:13px; color:var(--muted); }
  .meta-row span{ display:flex; align-items:center; gap:6px; }
  .meta-row strong{ color:var(--charcoal); }

  .card{ background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:26px; box-shadow:var(--shadow-sm); }
  .card-title{ display:flex; align-items:center; gap:10px; margin-bottom:18px; }
  .card-title .ic{ width:36px; height:36px; border-radius:10px; background:var(--olive-light); color:var(--olive-dark); display:flex; align-items:center; justify-content:center; }
  .card-title h2{ font-family:'Newsreader',serif; font-size:18px; margin:0; }
  .comment{ padding:14px 0; border-bottom:1px solid var(--border); }
  .comment:last-child{ border-bottom:none; }
  .comment-top{ display:flex; justify-content:space-between; font-size:13.5px; margin-bottom:4px; }
  .comment-who{ font-weight:700; }
  .comment-text{ font-size:13.5px; color:var(--muted); }
  .empty-mini{ text-align:center; padding:20px; color:var(--muted); font-size:13.5px; }

  @media (max-width:700px){
    .detail-card{ flex-direction:column; }
    .detail-image{ width:100%; height:220px; }
    .stat-strip{ grid-template-columns:1fr 1fr; }
    .page-wrap{ padding:20px 14px 40px; }
  }
</style>
</head>
<body>
  <div class="topbar">
    <div class="brand"><div class="mark"><i data-lucide="leaf" style="width:19px;height:19px;"></i></div> HerjaHub</div>
  </div>

  <div class="page-wrap">
    <c:set var="mn" value="${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']}"/>
    <c:set var="ratingSum" value="${0}"/>
    <c:forEach var="cm" items="${comments}"><c:set var="ratingSum" value="${ratingSum + cm.rating}"/></c:forEach>

    <div class="page-header">
      <a class="back-link" href="${pageContext.request.contextPath}/store/products"><i data-lucide="arrow-left" style="width:17px;height:17px;"></i></a>
      <div>
        <h1>Product Details</h1>
        <p>Everything about this listing at a glance.</p>
      </div>
      <div class="header-actions">
        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/store/products"><i data-lucide="list" style="width:16px;height:16px;"></i> All Products</a>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/store/products/${product.id}/edit"><i data-lucide="pencil" style="width:16px;height:16px;"></i> Edit Product</a>
      </div>
    </div>

    <div class="detail-card">
      <c:choose>
        <c:when test="${not empty product.image}">
          <div class="detail-image" style="background-image:url('${product.image}')"></div>
        </c:when>
        <c:otherwise>
          <div class="detail-image"><i data-lucide="image" style="width:40px;height:40px;"></i></div>
        </c:otherwise>
      </c:choose>

      <div class="detail-body">
        <div class="detail-top">
          <h2><c:out value="${product.productName}"/></h2>
          <div class="detail-price">$<fmt:formatNumber value="${product.price}" minFractionDigits="2" maxFractionDigits="2"/></div>
        </div>

        <c:choose>
          <c:when test="${product.quantity == 0}"><span class="badge out-of-stock"><i data-lucide="x-circle" style="width:12px;height:12px;"></i> Out of Stock</span></c:when>
          <c:when test="${product.quantity lt 5}"><span class="badge low-stock"><i data-lucide="alert-triangle" style="width:12px;height:12px;"></i> Low Stock — ${product.quantity} left</span></c:when>
          <c:otherwise><span class="badge in-stock"><i data-lucide="check-circle" style="width:12px;height:12px;"></i> In Stock — ${product.quantity} available</span></c:otherwise>
        </c:choose>

        <p class="detail-desc">
          <c:choose>
            <c:when test="${not empty product.description}"><c:out value="${product.description}"/></c:when>
            <c:otherwise>No description provided.</c:otherwise>
          </c:choose>
        </p>

        <div class="stat-strip">
          <div class="stat-mini">
            <div class="n">${stats.unitsSold}</div>
            <div class="l">Units Sold</div>
          </div>
          <div class="stat-mini">
            <div class="n">$<fmt:formatNumber value="${stats.revenue}" minFractionDigits="2" maxFractionDigits="2"/></div>
            <div class="l">Revenue</div>
          </div>
          <div class="stat-mini">
            <c:choose>
              <c:when test="${not empty comments}">
                <div class="n"><fmt:formatNumber value="${ratingSum / fn:length(comments)}" maxFractionDigits="1"/>/5</div>
              </c:when>
              <c:otherwise><div class="n">—</div></c:otherwise>
            </c:choose>
            <div class="l">Avg. Rating</div>
          </div>
          <div class="stat-mini">
            <div class="n">${fn:length(comments)}</div>
            <div class="l">Reviews</div>
          </div>
        </div>

        <div class="meta-row">
          <span><i data-lucide="calendar-plus" style="width:14px;height:14px;"></i> Created <strong>${mn[product.createdAt.monthValue - 1]} ${product.createdAt.dayOfMonth}, ${product.createdAt.year}</strong></span>
          <span><i data-lucide="calendar-clock" style="width:14px;height:14px;"></i> Updated <strong>${mn[product.updatedAt.monthValue - 1]} ${product.updatedAt.dayOfMonth}, ${product.updatedAt.year}</strong></span>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-title"><div class="ic"><i data-lucide="message-square" style="width:18px;height:18px;"></i></div><h2>Comments</h2></div>
      <c:forEach var="cm" items="${comments}">
        <div class="comment">
          <div class="comment-top">
            <span class="comment-who"><c:out value="${cm.customerName}"/></span>
            <span>${cm.rating}/5 <i data-lucide="star" style="width:12px;height:12px;color:var(--gold);"></i></span>
          </div>
          <div class="comment-text"><c:out value="${cm.comment}"/></div>
        </div>
      </c:forEach>
      <c:if test="${empty comments}">
        <div class="empty-mini">No comments on this product yet.</div>
      </c:if>
    </div>
  </div>

<script>
  try { if (window.lucide) { lucide.createIcons(); } } catch (e) { console.warn("Icon rendering failed:", e); }
</script>
</body>
</html>
