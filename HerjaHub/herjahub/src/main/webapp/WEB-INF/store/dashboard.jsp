<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;0,6..72,700;1,6..72,500&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.4/chart.umd.min.js"></script>
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --olive:#4B5D3A; --olive-dark:#39492B; --olive-light:#EEF1E6;
    --sage:#93A57F; --ivory:#FBF8F0; --white:#FFFFFF;
    --gold:#C9A227; --gold-light:#F8F0DA;
    --charcoal:#2B2A24; --muted:#7C7969;
    --border:#E9E4D6; --error:#B3483F; --error-bg:#FBEAE8;
    --success:#4F7A3D; --success-bg:#EAF2E1;
    --radius-lg:20px; --radius-md:14px; --radius-sm:10px;
    --shadow-sm:0 2px 10px rgba(43,41,35,0.05);
    --shadow-md:0 16px 40px -18px rgba(43,41,35,0.22);
  }
  *{box-sizing:border-box;}
  body{ margin:0; font-family:'Inter',sans-serif; background:var(--ivory); color:var(--charcoal); }
  a{ color:inherit; }
  svg{ vertical-align:middle; }

  .topbar{ display:flex; align-items:center; justify-content:space-between; padding:16px 32px; background:var(--white); border-bottom:1px solid var(--border); position:sticky; top:0; z-index:20; }
  .brand{ display:flex; align-items:center; gap:10px; font-family:'Newsreader',serif; font-weight:600; font-size:20px; color:var(--olive-dark); }
  .brand .mark{ width:36px; height:36px; border-radius:11px; background:linear-gradient(155deg,var(--olive),var(--olive-dark)); color:var(--gold-light); display:flex; align-items:center; justify-content:center; }
  .topbar-actions{ display:flex; align-items:center; gap:10px; }
  .icon-btn{ width:38px; height:38px; border-radius:12px; border:1px solid var(--border); background:var(--white); display:flex; align-items:center; justify-content:center; color:var(--muted); cursor:pointer; transition:all .18s ease; }
  .icon-btn:hover{ background:var(--olive-light); color:var(--olive-dark); transform:translateY(-1px); }

  .shell{ display:flex; max-width:1360px; margin:0 auto; }

  .sidebar{ width:236px; flex-shrink:0; padding:28px 16px; position:sticky; top:69px; align-self:flex-start; height:calc(100vh - 69px); }
  .side-section{ margin-bottom:22px; }
  .side-label{ font-size:11px; text-transform:uppercase; letter-spacing:.08em; color:var(--muted); font-weight:700; padding:0 12px 8px; }
  .nav-link{ display:flex; align-items:center; gap:11px; padding:11px 12px; margin-bottom:3px; border-radius:var(--radius-sm); text-decoration:none; font-weight:600; font-size:14px; color:var(--charcoal); cursor:pointer; transition:all .16s ease; }
  .nav-link:hover{ background:var(--olive-light); }
  .nav-link.active{ background:var(--olive); color:var(--white); box-shadow:var(--shadow-sm); }
  .nav-link.logout{ color:var(--error); }
  .nav-link.logout:hover{ background:var(--error-bg); }

  .main{ flex:1; min-width:0; padding:28px 32px 56px; }

  .hero{ background:linear-gradient(120deg,var(--olive-dark), var(--olive) 65%); border-radius:var(--radius-lg); padding:34px 38px; color:var(--white); margin-bottom:26px; box-shadow:var(--shadow-md); position:relative; overflow:hidden; }
  .hero::after{ content:""; position:absolute; right:-40px; top:-40px; width:220px; height:220px; border-radius:50%; background:rgba(255,255,255,0.06); }
  .hero-eyebrow{ font-size:13px; letter-spacing:.06em; text-transform:uppercase; color:var(--gold-light); font-weight:700; margin-bottom:6px; }
  .hero h1{ font-family:'Newsreader',serif; font-weight:600; font-size:32px; margin:0 0 8px; }
  .hero p{ margin:0; color:rgba(255,255,255,0.82); font-size:15px; max-width:520px; }

  .kpi-grid{ display:grid; grid-template-columns:repeat(4,1fr); gap:18px; margin-bottom:26px; }
  .kpi-card{ background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:22px 22px; box-shadow:var(--shadow-sm); transition:transform .2s ease, box-shadow .2s ease; }
  .kpi-card:hover{ transform:translateY(-3px); box-shadow:var(--shadow-md); }
  .kpi-top{ display:flex; align-items:center; justify-content:space-between; margin-bottom:14px; }
  .kpi-icon{ width:40px; height:40px; border-radius:12px; display:flex; align-items:center; justify-content:center; }
  .kpi-icon.olive{ background:var(--olive-light); color:var(--olive-dark); }
  .kpi-icon.gold{ background:var(--gold-light); color:#8a6d13; }
  .kpi-icon.sage{ background:#EEF2E9; color:#5c6f4c; }
  .kpi-label{ font-size:13px; color:var(--muted); font-weight:600; }
  .kpi-value{ font-family:'Newsreader',serif; font-size:30px; font-weight:600; }

  .grid-2{ display:grid; grid-template-columns:2fr 1fr; gap:20px; margin-bottom:26px; align-items:start; }

  .panel{ background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:24px; box-shadow:var(--shadow-sm); }
  .panel h2{ font-family:'Newsreader',serif; font-weight:600; font-size:19px; margin:0 0 4px; }
  .panel .sub{ margin:0 0 16px; color:var(--muted); font-size:13px; }
  .chart-wrap{ height:280px; }

  .quick-actions{ display:flex; flex-direction:column; gap:10px; }
  .qa-card{ display:flex; align-items:center; gap:12px; padding:14px 16px; border-radius:var(--radius-md); border:1px solid var(--border); text-decoration:none; color:var(--charcoal); transition:all .18s ease; }
  .qa-card:hover{ border-color:var(--olive); background:var(--olive-light); transform:translateX(2px); }
  .qa-icon{ width:38px; height:38px; border-radius:11px; background:var(--olive); color:var(--white); display:flex; align-items:center; justify-content:center; flex-shrink:0; }
  .qa-text .t1{ font-weight:700; font-size:14px; }
  .qa-text .t2{ font-size:12.5px; color:var(--muted); }

  .empty-mini{ text-align:center; padding:28px 12px; color:var(--muted); font-size:13.5px; }
  .empty-mini svg{ margin-bottom:8px; color:var(--sage); }

  @media (max-width: 1080px){
    .kpi-grid{ grid-template-columns:repeat(2,1fr); }
    .grid-2{ grid-template-columns:1fr; }
  }
  @media (max-width: 760px){
    .shell{ flex-direction:column; }
    .sidebar{ width:100%; height:auto; position:static; padding:14px 16px 0; }
    .main{ padding:20px 16px 40px; }
    .kpi-grid{ grid-template-columns:1fr 1fr; }
    .hero h1{ font-size:26px; }
  }
</style>
</head>
<body>
  <div class="topbar">
    <div class="brand"><div class="mark"><i data-lucide="leaf" style="width:19px;height:19px;"></i></div> HerjaHub</div>
    <div class="topbar-actions">
      <a class="icon-btn" href="${pageContext.request.contextPath}/store/edit" title="Store Profile"><i data-lucide="user" style="width:17px;height:17px;"></i></a>
      <a class="icon-btn" href="${pageContext.request.contextPath}/logout" title="Log out"><i data-lucide="log-out" style="width:17px;height:17px;"></i></a>
    </div>
  </div>

  <div class="shell">
    <div class="sidebar">
      <div class="side-section">
        <div class="side-label">Overview</div>
        <a class="nav-link active" href="${pageContext.request.contextPath}/store/dashboard"><i data-lucide="layout-dashboard" style="width:17px;height:17px;"></i> Dashboard</a>
      </div>
      <div class="side-section">
        <div class="side-label">Manage</div>
        <a class="nav-link" href="${pageContext.request.contextPath}/store/products"><i data-lucide="package" style="width:17px;height:17px;"></i> Products</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/store/edit"><i data-lucide="store" style="width:17px;height:17px;"></i> Store Profile</a>
      </div>
      <div class="side-section">
        <a class="nav-link logout" href="${pageContext.request.contextPath}/logout"><i data-lucide="log-out" style="width:17px;height:17px;"></i> Logout</a>
      </div>
    </div>

    <div class="main">

      <div class="hero">
        <div class="hero-eyebrow">Store Owner Dashboard</div>
        <h1>Welcome back, ${store.storeName}</h1>
        <p>Here's how your handmade goods are doing today. Track sales, manage your catalog, and keep your storefront looking its best.</p>
      </div>

      <div class="kpi-grid">
        <div class="kpi-card">
          <div class="kpi-top"><span class="kpi-label">Total Products</span><div class="kpi-icon olive"><i data-lucide="package" style="width:19px;height:19px;"></i></div></div>
          <div class="kpi-value">${sales.totalProducts}</div>
        </div>
        <div class="kpi-card">
          <div class="kpi-top"><span class="kpi-label">Units Sold</span><div class="kpi-icon sage"><i data-lucide="shopping-bag" style="width:19px;height:19px;"></i></div></div>
          <div class="kpi-value">${sales.totalUnitsSold}</div>
        </div>
        <div class="kpi-card">
          <div class="kpi-top"><span class="kpi-label">Total Revenue</span><div class="kpi-icon gold"><i data-lucide="wallet" style="width:19px;height:19px;"></i></div></div>
          <div class="kpi-value">$<fmt:formatNumber value="${sales.totalRevenue}" minFractionDigits="2" maxFractionDigits="2"/></div>
        </div>
        <div class="kpi-card">
          <div class="kpi-top"><span class="kpi-label">Avg. Revenue / Product</span><div class="kpi-icon olive"><i data-lucide="trending-up" style="width:19px;height:19px;"></i></div></div>
          <c:choose>
            <c:when test="${sales.totalProducts > 0}">
              <div class="kpi-value">$<fmt:formatNumber value="${sales.totalRevenue / sales.totalProducts}" minFractionDigits="2" maxFractionDigits="2"/></div>
            </c:when>
            <c:otherwise><div class="kpi-value">$0.00</div></c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="grid-2">
        <div class="panel">
          <h2>Sales Over Time</h2>
          <p class="sub">Monthly revenue across all of your products.</p>
          <c:choose>
            <c:when test="${not empty sales.chart}">
              <div class="chart-wrap"><canvas id="salesChart"></canvas></div>
            </c:when>
            <c:otherwise>
              <div class="empty-mini">
                <i data-lucide="bar-chart-3" style="width:30px;height:30px;"></i>
                <div>No sales yet — once orders come in, your trend will show up here.</div>
              </div>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="panel">
          <h2>Quick Actions</h2>
          <p class="sub">Jump right into managing your store.</p>
          <div class="quick-actions">
            <a class="qa-card" href="${pageContext.request.contextPath}/store/products/add">
              <div class="qa-icon"><i data-lucide="plus" style="width:18px;height:18px;"></i></div>
              <div class="qa-text"><div class="t1">Add a Product</div><div class="t2">List something new for sale</div></div>
            </a>
            <a class="qa-card" href="${pageContext.request.contextPath}/store/products">
              <div class="qa-icon"><i data-lucide="package" style="width:18px;height:18px;"></i></div>
              <div class="qa-text"><div class="t1">Manage Products</div><div class="t2">Edit, restock, or remove items</div></div>
            </a>
            <a class="qa-card" href="${pageContext.request.contextPath}/store/edit">
              <div class="qa-icon"><i data-lucide="store" style="width:18px;height:18px;"></i></div>
              <div class="qa-text"><div class="t1">Store Profile</div><div class="t2">Update your info and logo</div></div>
            </a>
          </div>
        </div>
      </div>

      <div class="grid-2">
        <div class="panel">
          <h2>Recent Reviews</h2>
          <p class="sub">What customers are saying about your products.</p>
          <c:choose>
            <c:when test="${not empty recentReviews}">
              <c:forEach var="rv" items="${recentReviews}">
                <div style="padding:12px 0; border-bottom:1px solid var(--border); font-size:13.5px;">
                  <strong><c:out value="${rv.customerName}"/></strong> &middot; <c:out value="${rv.productName}"/> &middot; ${rv.rating}/5<br>
                  <span style="color:var(--muted);"><c:out value="${rv.comment}"/></span>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div class="empty-mini">
                <i data-lucide="message-square" style="width:28px;height:28px;"></i>
                <div>No reviews yet across your products.</div>
              </div>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="panel">
          <h2>Low Stock</h2>
          <p class="sub">Products running low on inventory.</p>
          <c:choose>
            <c:when test="${not empty lowStockProducts}">
              <c:forEach var="lp" items="${lowStockProducts}">
                <div style="display:flex; justify-content:space-between; padding:10px 0; border-bottom:1px solid var(--border); font-size:13.5px;">
                  <span><c:out value="${lp.productName}"/></span>
                  <span style="color:var(--error); font-weight:700;">${lp.quantity} left</span>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div class="empty-mini">
                <i data-lucide="check-circle-2" style="width:28px;height:28px;"></i>
                <div>Nothing running low right now.</div>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

    </div>
  </div>

<script>
  try { if (window.lucide) { lucide.createIcons(); } } catch (e) { console.warn("Icon rendering failed:", e); }

  var labels = [
    <c:forEach var="p" items="${sales.chart}" varStatus="s">"${p.label}"<c:if test="${!s.last}">,</c:if></c:forEach>
  ];
  var data = [
    <c:forEach var="p" items="${sales.chart}" varStatus="s">${p.total}<c:if test="${!s.last}">,</c:if></c:forEach>
  ];

  var canvas = document.getElementById('salesChart');
  if (canvas) {
    try {
      new Chart(canvas.getContext('2d'), {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: 'Revenue',
          data: data,
          borderColor: '#4B5D3A',
          backgroundColor: 'rgba(75,93,58,0.10)',
          fill: true,
          tension: 0.35,
          pointRadius: 4,
          pointBackgroundColor: '#4B5D3A'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
          y: { beginAtZero: true, ticks: { callback: function (v) { return '$' + v; } }, grid:{ color:'#EEEAE0' } },
          x: { grid:{ display:false } }
        }
      }
    });
    } catch (e) { console.warn("Chart rendering failed:", e); }
  }
</script>
</body>
</html>
