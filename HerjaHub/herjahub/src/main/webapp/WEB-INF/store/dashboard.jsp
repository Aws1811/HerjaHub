<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Store Dashboard — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.4/chart.umd.min.js"></script>
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

  /* ===== App shell ===== */
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

  /* ===================== SIGNATURE: real analytics dashboard - hero + KPI row + chart ===================== */
  .hero{ position:relative; overflow:hidden; border-radius:var(--radius-lg); padding:34px 38px; margin-bottom:24px; background:linear-gradient(120deg,var(--red),var(--green)); color:#fff; box-shadow:var(--shadow-md); animation:fadeInUp .5s var(--ease); }
  .hero::after{ content:""; position:absolute; right:-40px; top:-40px; width:220px; height:220px; border-radius:50%; background:rgba(255,255,255,0.08); }
  .hero-eyebrow{ font-size:12px; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:rgba(255,255,255,0.85); margin:0 0 6px; position:relative; z-index:1; }
  .hero h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:27px; margin:0 0 8px; position:relative; z-index:1; }
  .hero p{ margin:0; color:rgba(255,255,255,0.88); font-size:14px; max-width:520px; position:relative; z-index:1; }

  .kpi-row{ display:grid; grid-template-columns:1.4fr 1fr 1fr 1fr; gap:16px; margin-bottom:24px; }
  .kpi-card{ background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-md); padding:20px 22px; transition:all .22s var(--ease); animation:fadeInUp .4s var(--ease) backwards; }
  .kpi-card:hover{ transform:translateY(-4px); box-shadow:var(--shadow-md); }
  .kpi-card.hero-metric{ background:linear-gradient(135deg, rgba(206,17,38,0.06), rgba(0,122,61,0.08)); border-color:rgba(0,122,61,0.2); }
  .kpi-top{ display:flex; align-items:center; justify-content:space-between; margin-bottom:14px; }
  .kpi-label{ font-size:12px; font-weight:700; color:var(--text-2); }
  .kpi-icon{ width:34px; height:34px; border-radius:10px; display:flex; align-items:center; justify-content:center; background:rgba(0,122,61,0.1); color:var(--green); }
  .kpi-value{ font-family:'Poppins',sans-serif; font-weight:800; font-size:24px; }
  .kpi-card.hero-metric .kpi-value{ background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; font-size:28px; }

  .content-row{ display:grid; grid-template-columns:2fr 1fr; gap:18px; margin-bottom:18px; }
  .panel{ background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-lg); padding:24px 26px; box-shadow:var(--shadow-sm); animation:fadeInUp .4s var(--ease) .08s backwards; }
  .panel h2{ font-family:'Poppins',sans-serif; font-weight:700; font-size:17px; margin:0 0 4px; }
  .panel .sub{ color:var(--text-2); font-size:13px; margin:0 0 18px; }
  .empty-note{ text-align:center; padding:40px 20px; color:var(--text-2); font-size:13.5px; }
  .empty-note svg{ color:var(--green); opacity:.4; margin-bottom:10px; }

  .chart-insight{ display:flex; align-items:center; gap:26px; margin-top:18px; padding-top:18px; border-top:1px solid var(--neutral-2); flex-wrap:wrap; }
  .insight-stat{ display:flex; flex-direction:column; gap:3px; }
  .insight-label{ font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.05em; color:var(--text-2); }
  .insight-value{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; }
  .insight-badge{ display:inline-flex; align-items:center; gap:5px; padding:6px 12px; border-radius:999px; font-size:12px; font-weight:700; }
  .insight-badge.up{ background:rgba(0,122,61,0.1); color:var(--green); }
  .insight-badge.down{ background:rgba(206,17,38,0.08); color:var(--red); }

  .qa-link{ display:flex; align-items:center; gap:13px; padding:14px; border-radius:var(--radius-sm); border:1px solid var(--neutral-2); margin-bottom:10px; transition:all .2s var(--ease); }
  .qa-link:last-child{ margin-bottom:0; }
  .qa-link:hover{ border-color:var(--green); background:rgba(0,122,61,0.05); transform:translateX(3px); }
  .qa-icon{ width:38px; height:38px; border-radius:11px; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; display:flex; align-items:center; justify-content:center; flex-shrink:0; }
  .qa-text .t1{ font-weight:700; font-size:13.5px; }
  .qa-text .t2{ font-size:12px; color:var(--text-2); }

  .bottom-row{ display:grid; grid-template-columns:1fr 1fr; gap:18px; }
  .review-row{ padding:14px 0; border-bottom:1px solid var(--neutral-2); }
  .review-row:last-child{ border-bottom:none; padding-bottom:0; }
  .review-meta{ display:flex; align-items:center; gap:6px; flex-wrap:wrap; font-size:12.5px; margin-bottom:4px; }
  .review-meta strong{ font-size:13.5px; }
  .review-meta .sep{ color:var(--neutral-2); }
  .review-meta .rating{ color:var(--green); font-weight:700; }
  .review-text{ color:var(--text-2); font-size:13px; margin:0; }

  .stock-row{ display:flex; align-items:center; justify-content:space-between; padding:12px 0; border-bottom:1px solid var(--neutral-2); }
  .stock-row:last-child{ border-bottom:none; }
  .stock-name{ font-weight:600; font-size:13.5px; }
  .stock-qty{ font-weight:800; font-size:13px; color:var(--red); background:rgba(206,17,38,0.08); padding:4px 11px; border-radius:999px; }

  @media (max-width: 1000px){
    .sidebar{ transform:translateX(-100%); }
    .main-area{ margin-left:0; }
    .kpi-row{ grid-template-columns:1fr 1fr; }
    .content-row, .bottom-row{ grid-template-columns:1fr; }
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
    <a class="side-link active" href="${pageContext.request.contextPath}/store/dashboard">
        <i data-lucide="layout-dashboard" width="18" height="18"></i> Dashboard
    </a>
    <div class="side-label">Manage</div>
    <a class="side-link" href="${pageContext.request.contextPath}/store/products">
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
        <div class="topbar-title">Dashboard</div>
        <div class="user-chip">
            <div class="user-avatar"><c:out value="${fn:substring(store.storeName, 0, 1)}" /></div>
            <span class="u-name"><c:out value="${store.storeName}" /></span>
        </div>
    </div>

    <div class="page">

        <%-- ===== Hero ===== --%>
        <div class="hero">
            <p class="hero-eyebrow">Store Owner Dashboard</p>
            <h1>Welcome back, <c:out value="${store.storeName}" /></h1>
            <p>Here's how your handmade goods are doing today. Track sales, manage your catalog, and keep your storefront looking its best.</p>
        </div>

        <%-- ===== KPI row - revenue highlighted as the hero metric ===== --%>
        <div class="kpi-row">
            <div class="kpi-card hero-metric">
                <div class="kpi-top">
                    <span class="kpi-label">Total Revenue</span>
                    <div class="kpi-icon"><i data-lucide="banknote" width="17" height="17"></i></div>
                </div>
                <div class="kpi-value">$<fmt:formatNumber value="${sales.totalRevenue}" minFractionDigits="2" maxFractionDigits="2" /></div>
            </div>
            <div class="kpi-card">
                <div class="kpi-top">
                    <span class="kpi-label">Total Products</span>
                    <div class="kpi-icon"><i data-lucide="shopping-bag" width="16" height="16"></i></div>
                </div>
                <div class="kpi-value">${sales.totalProducts}</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-top">
                    <span class="kpi-label">Units Sold</span>
                    <div class="kpi-icon"><i data-lucide="package-check" width="16" height="16"></i></div>
                </div>
                <div class="kpi-value">${sales.totalUnitsSold}</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-top">
                    <span class="kpi-label">Avg. Rev / Product</span>
                    <div class="kpi-icon"><i data-lucide="trending-up" width="16" height="16"></i></div>
                </div>
                <c:choose>
                    <c:when test="${sales.totalProducts > 0}">
                        <div class="kpi-value">$<fmt:formatNumber value="${sales.totalRevenue / sales.totalProducts}" minFractionDigits="2" maxFractionDigits="2" /></div>
                    </c:when>
                    <c:otherwise><div class="kpi-value">$0.00</div></c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- ===== Chart + Quick Actions ===== --%>
        <div class="content-row">
            <div class="panel">
                <h2>Sales Over Time</h2>
                <p class="sub">Monthly revenue across all of your products.</p>
                <c:choose>
                    <c:when test="${not empty sales.chart}">
                        <div style="height:270px; position:relative;"><canvas id="salesChart"></canvas></div>

                        <c:set var="chartSum" value="${0}" />
                        <c:forEach var="p" items="${sales.chart}">
                            <c:set var="chartSum" value="${chartSum + p.total}" />
                        </c:forEach>
                        <c:set var="chartCount" value="${fn:length(sales.chart)}" />
                        <c:set var="avgPerMonth" value="${chartCount > 0 ? (chartSum / chartCount) : 0}" />
                        <c:set var="latestTotal" value="${sales.chart[chartCount - 1].total}" />

                        <div class="chart-insight">
                            <div class="insight-stat">
                                <span class="insight-label">Total Revenue</span>
                                <span class="insight-value">$<fmt:formatNumber value="${sales.totalRevenue}" minFractionDigits="2" maxFractionDigits="2" /></span>
                            </div>
                            <div class="insight-stat">
                                <span class="insight-label">Avg / Month</span>
                                <span class="insight-value">$<fmt:formatNumber value="${avgPerMonth}" minFractionDigits="2" maxFractionDigits="2" /></span>
                            </div>
                            <div class="insight-stat">
                                <span class="insight-label">Latest Month</span>
                                <c:choose>
                                    <c:when test="${avgPerMonth == 0}">
                                        <span class="insight-badge up"><i data-lucide="minus" width="12" height="12"></i> No baseline yet</span>
                                    </c:when>
                                    <c:when test="${latestTotal >= avgPerMonth}">
                                        <span class="insight-badge up"><i data-lucide="trending-up" width="12" height="12"></i> <fmt:formatNumber value="${((latestTotal - avgPerMonth) / avgPerMonth) * 100}" maxFractionDigits="0" />% above avg</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="insight-badge down"><i data-lucide="trending-down" width="12" height="12"></i> <fmt:formatNumber value="${((avgPerMonth - latestTotal) / avgPerMonth) * 100}" maxFractionDigits="0" />% below avg</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-note">
                            <i data-lucide="bar-chart-3" width="30" height="30"></i>
                            <div>No sales yet — once orders come in, your trend will show up here.</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="panel">
                <h2>Quick Actions</h2>
                <p class="sub">Jump right into managing your store.</p>
                <a class="qa-link" href="${pageContext.request.contextPath}/store/products/add">
                    <div class="qa-icon"><i data-lucide="plus" width="17" height="17"></i></div>
                    <div class="qa-text"><div class="t1">Add a Product</div><div class="t2">List something new for sale</div></div>
                </a>
                <a class="qa-link" href="${pageContext.request.contextPath}/store/products">
                    <div class="qa-icon"><i data-lucide="shopping-bag" width="17" height="17"></i></div>
                    <div class="qa-text"><div class="t1">Manage Products</div><div class="t2">Edit, restock, or remove items</div></div>
                </a>
                <a class="qa-link" href="${pageContext.request.contextPath}/store/edit">
                    <div class="qa-icon"><i data-lucide="store" width="17" height="17"></i></div>
                    <div class="qa-text"><div class="t1">Store Profile</div><div class="t2">Update your info and logo</div></div>
                </a>
            </div>
        </div>

        <%-- ===== Reviews + Low Stock ===== --%>
        <div class="bottom-row">
            <div class="panel">
                <h2>Recent Reviews</h2>
                <p class="sub">What customers are saying about your products.</p>
                <c:choose>
                    <c:when test="${not empty recentReviews}">
                        <c:forEach var="rv" items="${recentReviews}">
                            <div class="review-row">
                                <div class="review-meta">
                                    <strong><c:out value="${rv.customerName}" /></strong>
                                    <span class="sep">&middot;</span>
                                    <span style="color:var(--text-2);"><c:out value="${rv.productName}" /></span>
                                    <span class="sep">&middot;</span>
                                    <span class="rating">${rv.rating}/5</span>
                                </div>
                                <p class="review-text"><c:out value="${rv.comment}" /></p>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-note">
                            <i data-lucide="message-square" width="28" height="28"></i>
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
                            <div class="stock-row">
                                <span class="stock-name"><c:out value="${lp.productName}" /></span>
                                <span class="stock-qty">${lp.quantity} left</span>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-note">
                            <i data-lucide="check-circle-2" width="28" height="28"></i>
                            <div>Nothing running low right now.</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</div>

<script>lucide.createIcons();</script>

<script>
  var labels = [
    <c:forEach var="p" items="${sales.chart}" varStatus="s">"${p.label}"<c:if test="${!s.last}">,</c:if></c:forEach>
  ];
  var data = [
    <c:forEach var="p" items="${sales.chart}" varStatus="s">${p.total}<c:if test="${!s.last}">,</c:if></c:forEach>
  ];
  var canvas = document.getElementById('salesChart');
  if (canvas) {
    try {
      var ctx = canvas.getContext('2d');
      var gradient = ctx.createLinearGradient(0, 0, 0, 270);
      gradient.addColorStop(0, 'rgba(0,122,61,0.22)');
      gradient.addColorStop(1, 'rgba(0,122,61,0.02)');
      new Chart(ctx, {
        type: 'line',
        data: {
          labels: labels,
          datasets: [{
            label: 'Revenue',
            data: data,
            borderColor: '#007A3D',
            backgroundColor: gradient,
            fill: true,
            tension: 0.35,
            pointRadius: 4,
            pointBackgroundColor: '#CE1126',
            pointBorderColor: '#fff',
            pointBorderWidth: 2
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: {
            y: { beginAtZero: true, ticks: { callback: function(v) { return '$' + v; } }, grid:{ color:'#E9ECEF' } },
            x: { grid:{ display:false } }
          }
        }
      });
    } catch (e) { console.warn("Chart rendering failed:", e); }
  }
</script>

</body>
</html>
