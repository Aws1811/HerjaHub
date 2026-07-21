<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Store Profile — HerjaHub</title>
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
  .field-error-input { border-color: #D72638 !important; background-color: #FFF5F5 !important; }
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

<div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-12 relative z-10">

  <%-- Profile Header --%>
  <div class="bg-gradient-to-r from-primary to-primary/80 rounded-[28px] p-8 lg:p-10 text-white mb-8 shadow-xl relative overflow-hidden">
    <div class="absolute right-[-40px] top-[-40px] w-52 h-52 rounded-full bg-white/10"></div>
    <div class="relative z-10 flex items-center gap-6">
      <c:choose>
        <c:when test="${not empty store.image}">
          <div class="w-20 h-20 rounded-2xl bg-white/20 border-2 border-white/40 overflow-hidden flex-shrink-0">
            <img src="${store.image}" alt="Store Logo" class="w-full h-full object-cover"/>
          </div>
        </c:when>
        <c:otherwise>
          <div class="w-20 h-20 rounded-2xl bg-white/20 border-2 border-white/40 flex items-center justify-center flex-shrink-0">
            <svg class="w-8 h-8 text-white/70" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 3h18v18H3zM3 9h18M9 21V9"/></svg>
          </div>
        </c:otherwise>
      </c:choose>
      <div>
        <h1 class="text-2xl font-serif font-semibold"><c:out value="${store.storeName}"/></h1>
        <p class="text-white/80"><c:out value="${store.email}"/></p>
      </div>
    </div>
  </div>

  <%-- Stats --%>
  <div class="grid grid-cols-1 sm:grid-cols-3 gap-5 mb-8">
    <div class="bg-card rounded-[28px] p-6 border border-border text-center">
      <div class="text-3xl font-serif font-semibold text-primary">${fn:length(store.products)}</div>
      <div class="text-sm text-muted-foreground font-semibold mt-1">Products</div>
    </div>
    <div class="bg-card rounded-[28px] p-6 border border-border text-center">
      <div class="text-3xl font-serif font-semibold text-primary">${fn:length(comments)}</div>
      <div class="text-sm text-muted-foreground font-semibold mt-1">Reviews</div>
    </div>
    <div class="bg-card rounded-[28px] p-6 border border-border text-center">
      <div class="text-3xl font-serif font-semibold text-primary">${mn[store.createdAt.monthValue - 1]} ${store.createdAt.year}</div>
      <div class="text-sm text-muted-foreground font-semibold mt-1">Joined</div>
    </div>
  </div>

  <%-- Error Banner --%>
  <c:if test="${not empty errorMessage}">
    <div class="flex items-center gap-3 p-4 rounded-xl bg-red-50 border border-red-200 text-destructive text-sm mb-6">
      <svg class="w-5 h-5 flex-shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      <span>${errorMessage}</span>
    </div>
  </c:if>

  <form method="post" action="${pageContext.request.contextPath}/store/edit" enctype="multipart/form-data">

    <%-- Store Logo --%>
    <div class="bg-card rounded-[28px] p-6 border border-border mb-6">
      <div class="flex items-center gap-3 mb-6">
        <div class="w-9 h-9 rounded-xl bg-primary/10 flex items-center justify-center">
          <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
        </div>
        <h2 class="text-xl font-serif font-semibold">Store Logo</h2>
      </div>
      <label class="border-2 border-dashed border-primary/30 rounded-xl bg-primary/5 p-6 text-center cursor-pointer hover:bg-primary/10 hover:border-primary transition-all flex items-center gap-4 justify-center">
        <svg class="w-7 h-7 text-primary/50" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
        <div class="text-left">
          <div class="font-semibold text-sm dz-title">Click to upload a new logo</div>
          <div class="text-xs text-muted-foreground dz-sub">PNG or JPG, up to 25MB — optional</div>
        </div>
        <input type="file" id="logo-input" name="logoFile" accept="image/*" class="hidden">
      </label>
    </div>

    <%-- Personal Information --%>
    <div class="bg-card rounded-[28px] p-6 border border-border mb-6">
      <div class="flex items-center gap-3 mb-6">
        <div class="w-9 h-9 rounded-xl bg-primary/10 flex items-center justify-center">
          <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
        </div>
        <h2 class="text-xl font-serif font-semibold">Personal Information</h2>
      </div>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <div>
          <label class="block text-sm font-semibold mb-2">First Name</label>
          <input type="text" name="firstName" value="${storeForm.firstName}" required class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
        </div>
        <div>
          <label class="block text-sm font-semibold mb-2">Last Name</label>
          <input type="text" name="lastName" value="${storeForm.lastName}" required class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
        </div>
        <div class="sm:col-span-2">
          <label class="block text-sm font-semibold mb-2">Email</label>
          <input type="text" value="${store.email}" disabled class="w-full px-4 py-3 rounded-xl border border-border bg-muted/50 text-muted-foreground"/>
        </div>
        <div class="sm:col-span-2">
          <label class="block text-sm font-semibold mb-2">Phone (10 digits)</label>
          <input type="text" name="phone" value="${storeForm.phone}" class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
        </div>
      </div>

      <p class="text-xs text-muted-foreground mt-6 mb-4">Leave the password fields blank to keep your current password.</p>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <div>
          <label class="block text-sm font-semibold mb-2">Current Password</label>
          <input type="password" name="currentPassword" class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
        </div>
        <div>
          <label class="block text-sm font-semibold mb-2">New Password</label>
          <input type="password" name="newPassword" class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
        </div>
      </div>
    </div>

    <%-- Store Information --%>
    <div class="bg-card rounded-[28px] p-6 border border-border mb-6">
      <div class="flex items-center gap-3 mb-6">
        <div class="w-9 h-9 rounded-xl bg-primary/10 flex items-center justify-center">
          <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 3h18v18H3zM3 9h18M9 21V9"/></svg>
        </div>
        <h2 class="text-xl font-serif font-semibold">Store Information</h2>
      </div>
      <div class="space-y-6">
        <div>
          <label class="block text-sm font-semibold mb-2">Store Name</label>
          <input type="text" name="storeName" value="${storeForm.storeName}" required class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
        </div>
        <div>
          <label class="block text-sm font-semibold mb-2">Description</label>
          <textarea name="description" rows="3" class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all resize-none">${storeForm.description}</textarea>
        </div>
        <div>
          <label class="block text-sm font-semibold mb-2">Address</label>
          <input type="text" name="address" value="${storeForm.address}" class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
        </div>
      </div>
    </div>

    <%-- Actions --%>
    <div class="flex justify-end gap-3 mb-8">
      <a href="${pageContext.request.contextPath}/store/dashboard" class="px-6 py-3 rounded-full border-2 border-border font-semibold hover:bg-secondary transition-all">Cancel</a>
      <button type="submit" class="px-6 py-3 rounded-full bg-primary text-primary-foreground font-semibold hover:shadow-lg hover:-translate-y-0.5 active:scale-95 transition-all flex items-center gap-2">
        <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
        Save Changes
      </button>
    </div>
  </form>

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
        <div class="flex items-center justify-between text-sm mb-2 flex-wrap gap-2">
          <span><strong><c:out value="${cm.customerName}"/></strong> &middot; <span class="text-muted-foreground italic"><c:out value="${cm.productName}"/></span></span>
          <span class="text-sm">${cm.rating}/5
            <svg class="w-3 h-3 inline text-amber-500 fill-amber-500" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
          </span>
        </div>
        <p class="text-sm text-muted-foreground"><c:out value="${cm.comment}"/></p>
      </div>
    </c:forEach>
    <c:if test="${empty comments}">
      <div class="text-center py-8 text-muted-foreground text-sm">No comments yet across any of your products.</div>
    </c:if>
  </div>
</div>

<script>
  var logoInput = document.getElementById('logo-input');
  var dropzone = logoInput.closest('label');
  logoInput.addEventListener('change', function() {
    if (logoInput.files && logoInput.files[0]) {
      dropzone.querySelector('.dz-title').textContent = logoInput.files[0].name;
    }
  });
</script>

</body>
</html>
