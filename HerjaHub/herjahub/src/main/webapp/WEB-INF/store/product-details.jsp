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
<script src="https://cdn.tailwindcss.com"></script>
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

<c:set var="mn" value="${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']}"/>
<c:set var="ratingSum" value="${0}"/>
<c:forEach var="cm" items="${comments}"><c:set var="ratingSum" value="${ratingSum + cm.rating}"/></c:forEach>

<div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-12 relative z-10">

  <%-- Page Header --%>
  <div class="flex items-center gap-4 mb-8 flex-wrap">
    <a href="${pageContext.request.contextPath}/store/products" class="w-10 h-10 rounded-xl border border-border bg-card flex items-center justify-center hover:bg-secondary transition-colors">
      <svg class="w-5 h-5 text-muted-foreground" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
    </a>
    <div class="flex-1">
      <h1 class="text-3xl font-serif font-semibold">Product Details</h1>
      <p class="text-muted-foreground text-sm">Everything about this listing at a glance.</p>
    </div>
    <div class="flex gap-3">
      <a href="${pageContext.request.contextPath}/store/products" class="px-5 py-2.5 rounded-full border-2 border-border font-semibold hover:bg-secondary transition-all text-sm inline-flex items-center gap-2">
        <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
        All Products
      </a>
      <a href="${pageContext.request.contextPath}/store/products/${product.id}/edit" class="px-5 py-2.5 rounded-full bg-primary text-primary-foreground font-semibold hover:shadow-lg hover:-translate-y-0.5 transition-all text-sm inline-flex items-center gap-2">
        <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
        Edit Product
      </a>
    </div>
  </div>

  <%-- Detail Card --%>
  <div class="bg-card rounded-[28px] border border-border overflow-hidden mb-8 flex flex-col lg:flex-row">
    <div class="w-full lg:w-72 h-64 lg:h-auto bg-secondary flex items-center justify-center flex-shrink-0 overflow-hidden">
      <c:choose>
        <c:when test="${not empty product.image}">
          <img src="${product.image}" alt="${product.productName}" class="w-full h-full object-cover"/>
        </c:when>
        <c:otherwise>
          <svg class="w-10 h-10 text-muted-foreground" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="p-8 flex-1 min-w-0">
      <div class="flex items-start justify-between gap-4 mb-3">
        <h2 class="text-2xl font-serif font-semibold"><c:out value="${product.productName}"/></h2>
        <div class="text-2xl font-serif font-semibold text-primary whitespace-nowrap">$<fmt:formatNumber value="${product.price}" minFractionDigits="2" maxFractionDigits="2"/></div>
      </div>

      <div class="mb-4">
        <c:choose>
          <c:when test="${product.quantity == 0}">
            <span class="px-3 py-1 rounded-full text-xs font-semibold bg-red-50 text-destructive">Out of Stock</span>
          </c:when>
          <c:when test="${product.quantity lt 5}">
            <span class="px-3 py-1 rounded-full text-xs font-semibold bg-amber-50 text-amber-700">Low Stock — ${product.quantity} left</span>
          </c:when>
          <c:otherwise>
            <span class="px-3 py-1 rounded-full text-xs font-semibold bg-green-50 text-green-700">In Stock — ${product.quantity} available</span>
          </c:otherwise>
        </c:choose>
      </div>

      <p class="text-muted-foreground text-sm leading-relaxed mb-6">
        <c:choose>
          <c:when test="${not empty product.description}"><c:out value="${product.description}"/></c:when>
          <c:otherwise>No description provided.</c:otherwise>
        </c:choose>
      </p>

      <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <div class="text-center p-4 rounded-xl bg-secondary border border-border">
          <div class="text-xl font-serif font-semibold">${stats.unitsSold}</div>
          <div class="text-xs text-muted-foreground font-semibold mt-1">Units Sold</div>
        </div>
        <div class="text-center p-4 rounded-xl bg-secondary border border-border">
          <div class="text-xl font-serif font-semibold">$<fmt:formatNumber value="${stats.revenue}" minFractionDigits="2" maxFractionDigits="2"/></div>
          <div class="text-xs text-muted-foreground font-semibold mt-1">Revenue</div>
        </div>
        <div class="text-center p-4 rounded-xl bg-secondary border border-border">
          <c:choose>
            <c:when test="${not empty comments}">
              <div class="text-xl font-serif font-semibold"><fmt:formatNumber value="${ratingSum / fn:length(comments)}" maxFractionDigits="1"/>/5</div>
            </c:when>
            <c:otherwise><div class="text-xl font-serif font-semibold">—</div></c:otherwise>
          </c:choose>
          <div class="text-xs text-muted-foreground font-semibold mt-1">Avg. Rating</div>
        </div>
        <div class="text-center p-4 rounded-xl bg-secondary border border-border">
          <div class="text-xl font-serif font-semibold">${fn:length(comments)}</div>
          <div class="text-xs text-muted-foreground font-semibold mt-1">Reviews</div>
        </div>
      </div>

      <div class="flex gap-6 flex-wrap mt-6 text-sm text-muted-foreground">
        <span class="flex items-center gap-2">
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
          Created <strong class="text-foreground">${mn[product.createdAt.monthValue - 1]} ${product.createdAt.dayOfMonth}, ${product.createdAt.year}</strong>
        </span>
        <span class="flex items-center gap-2">
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          Updated <strong class="text-foreground">${mn[product.updatedAt.monthValue - 1]} ${product.updatedAt.dayOfMonth}, ${product.updatedAt.year}</strong>
        </span>
      </div>
    </div>
  </div>

  <%-- Comments --%>
  <div class="bg-card rounded-[28px] p-6 border border-border">
    <div class="flex items-center gap-3 mb-6">
      <div class="w-9 h-9 rounded-xl bg-primary/10 flex items-center justify-center">
        <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
      </div>
      <h2 class="text-xl font-serif font-semibold">Comments</h2>
    </div>
    <c:forEach var="cm" items="${comments}">
      <div class="py-4 border-b border-border last:border-0">
        <div class="flex items-center justify-between text-sm mb-2">
          <span class="font-semibold"><c:out value="${cm.customerName}"/></span>
          <span class="flex items-center gap-1 text-sm">
            ${cm.rating}/5
            <svg class="w-3 h-3 text-amber-500 fill-amber-500" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
          </span>
        </div>
        <p class="text-sm text-muted-foreground"><c:out value="${cm.comment}"/></p>
      </div>
    </c:forEach>
    <c:if test="${empty comments}">
      <div class="text-center py-6 text-muted-foreground text-sm">No comments on this product yet.</div>
    </c:if>
  </div>
</div>

</body>
</html>
