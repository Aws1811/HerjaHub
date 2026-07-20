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
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.4/chart.umd.min.js"></script>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          background: '#FAF8F3', foreground: '#1F2937', card: '#FFFFFF',
          primary: '#198754', 'primary-foreground': '#FFFFFF', secondary: '#F8F9FA',
          muted: '#F1F1EE', 'muted-foreground': '#6B7280', border: '#E5E5E2',
          destructive: '#D72638',
        },
        fontFamily: { serif: ['Newsreader','serif'], sans: ['Inter','sans-serif'], ar: ['Tajawal','sans-serif'] },
        borderRadius: { DEFAULT: '1.75rem' },
      },
    },
  };
</script>
<style>
  .keffiyeh-bg { position: fixed; inset: 0; pointer-events: none; z-index: 0;
    background-image: repeating-linear-gradient(45deg,currentColor 0,currentColor 1px,transparent 1px,transparent 14px),
    repeating-linear-gradient(-45deg,currentColor 0,currentColor 1px,transparent 1px,transparent 14px); opacity: 0.05; }
</style>
</head>
<body class="bg-background text-foreground font-sans min-h-screen relative text-[#1F2937]">

<div class="keffiyeh-bg"></div>

<%-- Navbar --%>
<nav class="sticky top-0 z-50 bg-card/80 backdrop-blur-lg border-b border-border">
  <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
    <div class="flex items-center gap-3">
      <div class="flex items-center justify-center rounded-lg bg-gradient-to-br from-primary to-primary/80 text-white font-serif font-bold w-7 h-7" style="font-size:1.05rem;">ه</div>
      <div><div class="font-serif font-bold text-lg leading-tight">HerjaHub</div><div class="text-xs text-muted-foreground">Store Dashboard</div></div>
    </div>
    <div class="flex items-center gap-3">
      <a href="${pageContext.request.contextPath}/store/edit" class="w-10 h-10 rounded-full bg-secondary hover:bg-primary/10 flex items-center justify-center transition-colors">
        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
      </a>
      <a href="${pageContext.request.contextPath}/logout" class="text-sm font-semibold text-muted-foreground hover:text-foreground transition-colors">Log out</a>
    </div>
  </div>
</nav>

<div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-8 flex gap-8 relative z-10">

  <%-- Sidebar --%>
  <div class="w-56 flex-shrink-0 hidden lg:block">
    <div class="sticky top-20 space-y-6">
      <div>
        <div class="text-xs font-bold text-muted-foreground uppercase tracking-wider mb-3 px-3">Overview</div>
        <a href="${pageContext.request.contextPath}/store/dashboard" class="flex items-center gap-3 px-3 py-2.5 rounded-lg bg-primary text-primary-foreground font-semibold text-sm transition-all">
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
          Dashboard
        </a>
      </div>
      <div>
        <div class="text-xs font-bold text-muted-foreground uppercase tracking-wider mb-3 px-3">Manage</div>
        <a href="${pageContext.request.contextPath}/store/products" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-foreground hover:bg-secondary font-semibold text-sm transition-all">
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
          Products
        </a>
        <a href="${pageContext.request.contextPath}/store/edit" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-foreground hover:bg-secondary font-semibold text-sm transition-all">
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 3h18v18H3zM3 9h18M9 21V9"/></svg>
          Store Profile
        </a>
      </div>
      <div>
        <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-destructive hover:bg-red-50 font-semibold text-sm transition-all">
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
          Logout
        </a>
      </div>
    </div>
  </div>

  <%-- Main Content --%>
  <div class="flex-1 min-w-0">

    <%-- Hero --%>
    <div class="bg-gradient-to-r from-primary to-primary/80 rounded-[28px] p-8 lg:p-10 text-white mb-8 shadow-xl relative overflow-hidden">
      <div class="absolute right-[-40px] top-[-40px] w-52 h-52 rounded-full bg-white/10"></div>
      <div class="relative z-10">
        <div class="text-sm font-bold uppercase tracking-wider text-white/80 mb-2">Store Owner Dashboard</div>
        <h1 class="text-3xl font-serif font-semibold mb-3">Welcome back, <c:out value="${store.storeName}"/></h1>
        <p class="text-white/80 max-w-xl">Here's how your handmade goods are doing today. Track sales, manage your catalog, and keep your storefront looking its best.</p>
      </div>
    </div>

    <%-- KPI Cards --%>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-8">
      <div class="bg-card rounded-[28px] p-6 border border-border hover:shadow-lg hover:-translate-y-1 transition-all">
        <div class="flex items-center justify-between mb-4">
          <span class="text-sm text-muted-foreground font-semibold">Total Products</span>
          <div class="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center">
            <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
          </div>
        </div>
        <div class="text-3xl font-serif font-semibold">${sales.totalProducts}</div>
      </div>
      <div class="bg-card rounded-[28px] p-6 border border-border hover:shadow-lg hover:-translate-y-1 transition-all">
        <div class="flex items-center justify-between mb-4">
          <span class="text-sm text-muted-foreground font-semibold">Units Sold</span>
          <div class="w-10 h-10 rounded-xl bg-green-100 flex items-center justify-center">
            <svg class="w-5 h-5 text-green-700" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
          </div>
        </div>
        <div class="text-3xl font-serif font-semibold">${sales.totalUnitsSold}</div>
      </div>
      <div class="bg-card rounded-[28px] p-6 border border-border hover:shadow-lg hover:-translate-y-1 transition-all">
        <div class="flex items-center justify-between mb-4">
          <span class="text-sm text-muted-foreground font-semibold">Total Revenue</span>
          <div class="w-10 h-10 rounded-xl bg-amber-100 flex items-center justify-center">
            <svg class="w-5 h-5 text-amber-700" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="M2 10h20"/></svg>
          </div>
        </div>
        <div class="text-3xl font-serif font-semibold">$<fmt:formatNumber value="${sales.totalRevenue}" minFractionDigits="2" maxFractionDigits="2"/></div>
      </div>
      <div class="bg-card rounded-[28px] p-6 border border-border hover:shadow-lg hover:-translate-y-1 transition-all">
        <div class="flex items-center justify-between mb-4">
          <span class="text-sm text-muted-foreground font-semibold">Avg. Revenue/Product</span>
          <div class="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center">
            <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
          </div>
        </div>
        <c:choose>
          <c:when test="${sales.totalProducts > 0}">
            <div class="text-3xl font-serif font-semibold">$<fmt:formatNumber value="${sales.totalRevenue / sales.totalProducts}" minFractionDigits="2" maxFractionDigits="2"/></div>
          </c:when>
          <c:otherwise><div class="text-3xl font-serif font-semibold">$0.00</div></c:otherwise>
        </c:choose>
      </div>
    </div>

    <%-- Chart + Quick Actions --%>
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
      <div class="lg:col-span-2 bg-card rounded-[28px] p-6 border border-border">
        <h2 class="text-xl font-serif font-semibold mb-1">Sales Over Time</h2>
        <p class="text-sm text-muted-foreground mb-6">Monthly revenue across all of your products.</p>
        <c:choose>
          <c:when test="${not empty sales.chart}">
            <div style="height:280px"><canvas id="salesChart"></canvas></div>
          </c:when>
          <c:otherwise>
            <div class="text-center py-10 text-muted-foreground text-sm">
              <svg class="w-8 h-8 mx-auto mb-3 text-primary/30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
              <div>No sales yet — once orders come in, your trend will show up here.</div>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="bg-card rounded-[28px] p-6 border border-border">
        <h2 class="text-xl font-serif font-semibold mb-1">Quick Actions</h2>
        <p class="text-sm text-muted-foreground mb-6">Jump right into managing your store.</p>
        <div class="space-y-3">
          <a href="${pageContext.request.contextPath}/store/products/add" class="flex items-center gap-3 p-4 rounded-xl border border-border hover:border-primary hover:bg-primary/5 transition-all">
            <div class="w-10 h-10 rounded-xl bg-primary text-primary-foreground flex items-center justify-center flex-shrink-0">
              <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            </div>
            <div><div class="font-semibold text-sm">Add a Product</div><div class="text-xs text-muted-foreground">List something new for sale</div></div>
          </a>
          <a href="${pageContext.request.contextPath}/store/products" class="flex items-center gap-3 p-4 rounded-xl border border-border hover:border-primary hover:bg-primary/5 transition-all">
            <div class="w-10 h-10 rounded-xl bg-primary text-primary-foreground flex items-center justify-center flex-shrink-0">
              <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
            </div>
            <div><div class="font-semibold text-sm">Manage Products</div><div class="text-xs text-muted-foreground">Edit, restock, or remove items</div></div>
          </a>
          <a href="${pageContext.request.contextPath}/store/edit" class="flex items-center gap-3 p-4 rounded-xl border border-border hover:border-primary hover:bg-primary/5 transition-all">
            <div class="w-10 h-10 rounded-xl bg-primary text-primary-foreground flex items-center justify-center flex-shrink-0">
              <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 3h18v18H3zM3 9h18M9 21V9"/></svg>
            </div>
            <div><div class="font-semibold text-sm">Store Profile</div><div class="text-xs text-muted-foreground">Update your info and logo</div></div>
          </a>
        </div>
      </div>
    </div>

    <%-- Reviews + Low Stock --%>
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div class="bg-card rounded-[28px] p-6 border border-border">
        <h2 class="text-xl font-serif font-semibold mb-1">Recent Reviews</h2>
        <p class="text-sm text-muted-foreground mb-6">What customers are saying about your products.</p>
        <c:choose>
          <c:when test="${not empty recentReviews}">
            <div class="space-y-4">
              <c:forEach var="rv" items="${recentReviews}">
                <div class="border-b border-border pb-4 last:border-0 last:pb-0">
                  <div class="flex items-center gap-2 mb-1">
                    <strong class="text-sm"><c:out value="${rv.customerName}"/></strong>
                    <span class="text-sm text-muted-foreground">&middot;</span>
                    <span class="text-sm text-muted-foreground"><c:out value="${rv.productName}"/></span>
                    <span class="text-sm text-muted-foreground">&middot;</span>
                    <span class="text-sm">${rv.rating}/5</span>
                  </div>
                  <p class="text-sm text-muted-foreground"><c:out value="${rv.comment}"/></p>
                </div>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <div class="text-center py-10 text-muted-foreground text-sm">
              <svg class="w-8 h-8 mx-auto mb-3 text-primary/30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
              <div>No reviews yet across your products.</div>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="bg-card rounded-[28px] p-6 border border-border">
        <h2 class="text-xl font-serif font-semibold mb-1">Low Stock</h2>
        <p class="text-sm text-muted-foreground mb-6">Products running low on inventory.</p>
        <c:choose>
          <c:when test="${not empty lowStockProducts}">
            <div class="space-y-3">
              <c:forEach var="lp" items="${lowStockProducts}">
                <div class="flex items-center justify-between py-3 border-b border-border last:border-0">
                  <span class="text-sm font-medium"><c:out value="${lp.productName}"/></span>
                  <span class="text-sm font-bold text-destructive">${lp.quantity} left</span>
                </div>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <div class="text-center py-10 text-muted-foreground text-sm">
              <svg class="w-8 h-8 mx-auto mb-3 text-primary/30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
              <div>Nothing running low right now.</div>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

  </div>
</div>

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
      new Chart(canvas.getContext('2d'), {
        type: 'line',
        data: {
          labels: labels,
          datasets: [{
            label: 'Revenue',
            data: data,
            borderColor: '#198754',
            backgroundColor: 'rgba(25,135,84,0.10)',
            fill: true,
            tension: 0.35,
            pointRadius: 4,
            pointBackgroundColor: '#198754'
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { legend: { display: false } },
          scales: {
            y: { beginAtZero: true, ticks: { callback: function(v) { return '$' + v; } }, grid:{ color:'#EEEAE0' } },
            x: { grid:{ display:false } }
          }
        }
      });
    } catch (e) { console.warn("Chart rendering failed:", e); }
  }
</script>

</body>
</html>
