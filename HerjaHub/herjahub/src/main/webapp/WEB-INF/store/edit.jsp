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
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
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
  :root{
    --red:#CE1126; --green:#007A3D; --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF;
    --text-1:#1F2937; --text-2:#6B7280;
    --radius-lg:24px; --radius-md:18px; --radius-sm:12px;
    --shadow-sm:0 4px 16px rgba(31,41,55,0.06); --shadow-md:0 18px 40px -16px rgba(31,41,55,0.18);
    --ease:cubic-bezier(.4,0,.2,1); --sidebar-w:250px; --topbar-h:68px;
  }
  .keffiyeh-bg { position: fixed; inset: 0; pointer-events: none; z-index: 0;
    background-image: repeating-linear-gradient(45deg,currentColor 0,currentColor 1px,transparent 1px,transparent 14px),
    repeating-linear-gradient(-45deg,currentColor 0,currentColor 1px,transparent 1px,transparent 14px); opacity: 0.05; }
  .field-error-input { border-color: #D72638 !important; background-color: #FFF5F5 !important; }

  .sidebar{ position:fixed; top:0; left:0; bottom:0; width:var(--sidebar-w); z-index:30; background:rgba(255,255,255,0.7); backdrop-filter:blur(20px); -webkit-backdrop-filter:blur(20px); border-right:1px solid rgba(255,255,255,0.6); display:flex; flex-direction:column; padding:22px 16px; }
  .sidebar-brand{ display:flex; align-items:center; gap:10px; padding:6px 10px 26px; text-decoration:none; color:inherit; }
  .sidebar-brand .mark{ width:38px; height:38px; border-radius:12px; flex-shrink:0; background:linear-gradient(135deg, var(--red), var(--green)); display:flex; align-items:center; justify-content:center; color:var(--white); font-family:'Newsreader',serif; font-weight:800; }
  .sidebar-brand .name{ font-family:'Newsreader',serif; font-weight:800; font-size:17px; }
  .side-label{ font-size:10.5px; font-weight:700; text-transform:uppercase; letter-spacing:.08em; color:var(--text-2); padding:14px 12px 8px; }
  .side-link{ display:flex; align-items:center; gap:12px; padding:11px 12px; border-radius:var(--radius-sm); font-weight:600; font-size:14px; color:var(--text-1); margin-bottom:3px; transition:all .22s var(--ease); position:relative; text-decoration:none; }
  .side-link svg, .side-link i{ flex-shrink:0; opacity:.8; }
  .side-link:hover{ background:var(--neutral-2); }
  .side-link.active{ background:linear-gradient(90deg, rgba(206,17,38,0.1), rgba(0,122,61,0.1)); box-shadow:inset 0 0 0 1px rgba(0,122,61,0.15); }
  .side-link.active svg, .side-link.active i{ opacity:1; color:var(--green); }
  .side-link.active::before{ content:""; position:absolute; left:-16px; top:8px; bottom:8px; width:4px; border-radius:4px; background:linear-gradient(180deg, var(--red), var(--green)); }
  .sidebar-footer{ margin-top:auto; padding-top:14px; border-top:1px solid var(--neutral-2); }

  .main-area{ margin-left:var(--sidebar-w); min-height:100%; position:relative; z-index:1; }
  .topbar{ position:sticky; top:0; z-index:20; height:var(--topbar-h); display:flex; align-items:center; justify-content:space-between; gap:16px; padding:0 28px; background:rgba(255,255,255,0.65); backdrop-filter:blur(18px); -webkit-backdrop-filter:blur(18px); border-bottom:1px solid rgba(255,255,255,0.5); }
  .topbar-title{ font-family:'Newsreader',serif; font-weight:700; font-size:16px; }
  .user-chip{ display:flex; align-items:center; gap:10px; padding:6px 14px 6px 6px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); }
  .user-avatar{ width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center; background:linear-gradient(135deg, var(--red), var(--green)); color:#fff; font-weight:700; font-size:13px; flex-shrink:0; }
  .u-name{ font-size:13px; font-weight:600; }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); }
    .main-area{ margin-left:0; }
  }
</style>
</head>
<body class="bg-background text-foreground font-sans min-h-screen relative text-[#1F2937]">

<div class="keffiyeh-bg"></div>

<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/store/dashboard">
        <div class="mark">ه</div><div class="name">HerjaHub</div>
    </a>
    <div class="side-label">Overview</div>
    <a class="side-link" href="${pageContext.request.contextPath}/store/dashboard">
        <i data-lucide="layout-dashboard" width="18" height="18"></i> Dashboard
    </a>
    <div class="side-label">Manage</div>
    <a class="side-link" href="${pageContext.request.contextPath}/store/products">
        <i data-lucide="shopping-bag" width="18" height="18"></i> Products
    </a>
    <a class="side-link active" href="${pageContext.request.contextPath}/store/edit">
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
    <div class="topbar-title">Store Profile</div>
    <div class="user-chip">
        <div class="user-avatar"><c:out value="${fn:substring(store.storeName, 0, 1)}" /></div>
        <span class="u-name"><c:out value="${store.storeName}" /></span>
    </div>
  </div>

<c:set var="mn" value="${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']}"/>

<div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-12 relative z-10">

  <%-- Profile Header --%>
  <div class="bg-gradient-to-r from-primary to-primary/80 rounded-[28px] p-8 lg:p-10 text-white mb-8 shadow-xl relative overflow-hidden">
    <div class="absolute right-[-40px] top-[-40px] w-52 h-52 rounded-full bg-white/10"></div>
    <div class="relative z-10 flex items-center gap-6">
      <c:choose>
        <c:when test="${not empty store.image}">
          <div class="w-20 h-20 rounded-2xl bg-white/20 border-2 border-white/40 overflow-hidden flex-shrink-0">
            <img src="${pageContext.request.contextPath}${store.image}" alt="Store Logo" class="w-full h-full object-cover"/>
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
</div>

<script>
  var logoInput = document.getElementById('logo-input');
  var dropzone = logoInput.closest('label');
  logoInput.addEventListener('change', function() {
    if (logoInput.files && logoInput.files[0]) {
      dropzone.querySelector('.dz-title').textContent = logoInput.files[0].name;
    }
  });
  try { if (window.lucide) { lucide.createIcons(); } } catch (e) { console.warn("Icon rendering failed:", e); }
</script>

</body>
</html>
