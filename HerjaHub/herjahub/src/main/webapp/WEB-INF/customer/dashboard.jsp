<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customer Dashboard — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;1,6..72,500&family=Inter:wght@400;500;600;700&family=Tajawal:wght@400;500;700&display=swap" rel="stylesheet">
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
        animation: { 'fade-in': 'fadeIn 400ms ease-out', 'slide-up': 'slideUp 500ms ease-out' },
      },
    },
  };
</script>
<style>
  .keffiyeh-bg { position: fixed; inset: 0; pointer-events: none; z-index: 0;
    background-image: repeating-linear-gradient(45deg,currentColor 0,currentColor 1px,transparent 1px,transparent 14px),
    repeating-linear-gradient(-45deg,currentColor 0,currentColor 1px,transparent 1px,transparent 14px); opacity: 0.05; }
  .tatreez-divider::before,.tatreez-divider::after { content:''; flex:1; height:1px; background-color:#E5E5E2; }
  @keyframes fadeIn { from{opacity:0} to{opacity:1} }
  @keyframes slideUp { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
  .animate-fade-in { animation: fadeIn 400ms ease-out; }
  .animate-slide-up { animation: slideUp 500ms ease-out; }
</style>
</head>
<body class="bg-background text-foreground font-sans min-h-screen relative text-[#1F2937]">

<div class="keffiyeh-bg"></div>

<%-- Navbar --%>
<nav class="sticky top-0 z-50 bg-card/80 backdrop-blur-lg border-b border-border">
  <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
    <a href="${pageContext.request.contextPath}/customer/dashboard" class="flex items-center gap-3">
      <div class="flex items-center justify-center rounded-lg bg-gradient-to-br from-primary to-primary/80 text-white font-serif font-bold w-7 h-7" style="font-size:1.05rem;">ه</div>
      <div><div class="font-serif font-bold text-lg leading-tight">HerjaHub</div><div class="text-xs text-muted-foreground">Palestinian Crafts</div></div>
    </a>
    <div class="flex items-center gap-4">
      <a href="${pageContext.request.contextPath}/customer/cart" class="w-10 h-10 rounded-full bg-secondary hover:bg-primary/10 flex items-center justify-center transition-colors">
        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
      </a>
      <a href="${pageContext.request.contextPath}/customer/profile/edit" class="w-10 h-10 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-semibold">${customer.firstName.substring(0,1)}</a>
      <a href="${pageContext.request.contextPath}/logout" class="text-sm font-semibold text-muted-foreground hover:text-foreground transition-colors">Log out</a>
    </div>
  </div>
</nav>

<%-- Hero Banner --%>
<section class="relative py-16 lg:py-24 overflow-hidden">
  <div class="absolute inset-0 bg-gradient-to-r from-primary/10 to-primary/5"></div>
  <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
    <h1 class="text-5xl lg:text-6xl font-serif font-semibold mb-4">Welcome, <c:out value="${customer.firstName}"/></h1>
    <p class="text-lg text-muted-foreground max-w-2xl">Discover authentic Palestinian crafts from talented artisans. Every purchase supports heritage and tradition.</p>
  </div>
</section>

<%-- Search & Category Pills --%>
<section class="py-8 sticky top-16 z-40 bg-card/80 backdrop-blur-lg border-b border-border">
  <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex flex-col lg:flex-row gap-4">
      <div class="flex-1 relative">
        <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
        <input type="text" placeholder="Search crafts, artisans, stores..." class="w-full pl-12 pr-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
      </div>
      <a href="${pageContext.request.contextPath}/customer/products" class="px-6 py-3 rounded-xl border border-border hover:bg-secondary transition-colors flex items-center justify-center gap-2">
        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
        <span class="hidden sm:inline">Filters</span>
      </a>
    </div>
    <div class="flex gap-3 mt-4 overflow-x-auto pb-2">
      <a href="${pageContext.request.contextPath}/customer/dashboard" class="px-4 py-2 rounded-full font-semibold whitespace-nowrap bg-primary text-primary-foreground">All</a>
      <button class="px-4 py-2 rounded-full font-semibold whitespace-nowrap bg-secondary text-foreground hover:bg-secondary/80">Embroidery</button>
      <button class="px-4 py-2 rounded-full font-semibold whitespace-nowrap bg-secondary text-foreground hover:bg-secondary/80">Olive Wood</button>
      <button class="px-4 py-2 rounded-full font-semibold whitespace-nowrap bg-secondary text-foreground hover:bg-secondary/80">Pottery</button>
      <button class="px-4 py-2 rounded-full font-semibold whitespace-nowrap bg-secondary text-foreground hover:bg-secondary/80">Jewelry</button>
      <button class="px-4 py-2 rounded-full font-semibold whitespace-nowrap bg-secondary text-foreground hover:bg-secondary/80">Textiles</button>
    </div>
  </div>
</section>

<div class="tatreez-divider flex items-center justify-center gap-3 my-12"></div>

<%-- Featured Stores --%>
<section class="py-16 lg:py-24 relative z-10">
  <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex items-center justify-between mb-12">
      <h2 class="text-4xl font-serif font-semibold">Featured Stores</h2>
      <a href="#" class="text-primary font-semibold flex items-center gap-2 hover:gap-3 transition-all">View All <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></a>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      <div class="group cursor-pointer animate-slide-up">
        <div class="relative h-48 rounded-[28px] overflow-hidden shadow-lg mb-4 bg-secondary">
          <div class="w-full h-full bg-gradient-to-br from-primary/20 to-primary/5 flex items-center justify-center">
            <div class="w-20 h-20 rounded-full bg-primary/20 flex items-center justify-center"><span class="text-4xl font-serif text-primary/50">ه</span></div>
          </div>
        </div>
        <h3 class="text-xl font-semibold mb-2 group-hover:text-primary transition-colors">Store Name</h3>
        <p class="text-muted-foreground text-sm mb-4">Handmade crafts with authentic Palestinian heritage</p>
        <div class="flex items-center gap-2">
          <div class="flex gap-0.5">
            <svg class="w-4 h-4 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg class="w-4 h-4 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg class="w-4 h-4 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg class="w-4 h-4 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg class="w-4 h-4 text-border" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
          </div>
          <span class="text-sm text-muted-foreground">(128)</span>
        </div>
      </div>
    </div>
  </div>
</section>

<div class="tatreez-divider flex items-center justify-center gap-3 my-12"></div>

<%-- Popular Products --%>
<section class="py-16 lg:py-24 relative z-10">
  <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex items-center justify-between mb-12">
      <h2 class="text-4xl font-serif font-semibold">Popular Products</h2>
      <a href="${pageContext.request.contextPath}/customer/products" class="text-primary font-semibold flex items-center gap-2 hover:gap-3 transition-all">View All <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg></a>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      <div class="group cursor-pointer animate-slide-up">
        <div class="relative h-64 rounded-[28px] overflow-hidden shadow-lg mb-4 bg-secondary group-hover:shadow-xl transition-shadow">
          <div class="w-full h-full bg-gradient-to-br from-primary/10 to-primary/5 flex items-center justify-center">
            <svg class="w-12 h-12 text-primary/30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
          </div>
        </div>
        <h3 class="font-semibold mb-2 group-hover:text-primary transition-colors">Product Name</h3>
        <p class="text-sm text-muted-foreground mb-3">Store Name</p>
        <div class="flex items-center justify-between">
          <span class="font-semibold text-primary">$45.00</span>
          <div class="flex gap-0.5">
            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg class="w-3.5 h-3.5 text-border" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<div class="tatreez-divider flex items-center justify-center gap-3 my-12"></div>

<%-- AI Recommendation Banner --%>
<section class="py-16 lg:py-24 relative z-10">
  <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8">
    <div class="bg-gradient-to-r from-primary/20 to-primary/10 rounded-[28px] p-12 text-center border border-primary/20">
      <div class="flex justify-center mb-6">
        <svg class="w-12 h-12 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>
      </div>
      <h2 class="text-4xl font-serif font-semibold mb-4">AI-Powered Recommendations</h2>
      <p class="text-lg text-muted-foreground max-w-2xl mx-auto mb-8">Our AI assistant learns your preferences and suggests crafts tailored just for you. Discover hidden gems from Palestinian artisans.</p>
      <a href="${pageContext.request.contextPath}/customer/ai" class="px-8 py-4 bg-primary text-primary-foreground rounded-full font-semibold hover:shadow-lg hover:-translate-y-1 transition-all inline-flex items-center gap-2">
        Try AI Assistant <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
      </a>
    </div>
  </div>
</section>

<div class="tatreez-divider flex items-center justify-center gap-3 my-12"></div>

<%-- Testing Navigation --%>
<section class="py-8 relative z-10">
  <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8">
    <div class="bg-card rounded-[28px] p-8 border border-border">
      <h2 class="text-2xl font-serif font-semibold mb-2">Testing Navigation</h2>
      <p class="text-muted-foreground text-sm mb-6">Quick links for development.</p>
      <div class="flex flex-wrap gap-3">
        <a href="${pageContext.request.contextPath}/customer/dashboard" class="px-4 py-2 border border-border rounded-lg text-sm font-semibold hover:bg-secondary transition-colors">Dashboard</a>
        <a href="${pageContext.request.contextPath}/customer/products" class="px-4 py-2 border border-border rounded-lg text-sm font-semibold hover:bg-secondary transition-colors">Products</a>
        <a href="${pageContext.request.contextPath}/customer/products/1" class="px-4 py-2 border border-border rounded-lg text-sm font-semibold hover:bg-secondary transition-colors">Product Details</a>
        <a href="${pageContext.request.contextPath}/customer/cart" class="px-4 py-2 border border-border rounded-lg text-sm font-semibold hover:bg-secondary transition-colors">Cart</a>
        <a href="${pageContext.request.contextPath}/customer/orders" class="px-4 py-2 border border-border rounded-lg text-sm font-semibold hover:bg-secondary transition-colors">My Orders</a>
        <a href="${pageContext.request.contextPath}/customer/orders/1/confirmation" class="px-4 py-2 border border-border rounded-lg text-sm font-semibold hover:bg-secondary transition-colors">Order Confirmation</a>
        <a href="${pageContext.request.contextPath}/customer/profile/edit" class="px-4 py-2 border border-border rounded-lg text-sm font-semibold hover:bg-secondary transition-colors">Edit Profile</a>
        <a href="${pageContext.request.contextPath}/customer/ai" class="px-4 py-2 border border-border rounded-lg text-sm font-semibold hover:bg-secondary transition-colors">AI Chat</a>
      </div>
    </div>
  </div>
</section>

<div class="tatreez-divider flex items-center justify-center gap-3 my-12"></div>

<%-- Footer --%>
<footer class="bg-card border-t border-border py-12">
  <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 text-center text-muted-foreground text-sm">
    <p>&copy; 2024 HerjaHub. Supporting Palestinian artisans worldwide.</p>
  </div>
</footer>

</body>
</html>
