<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Product — HerjaHub</title>
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

<div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-12 relative z-10">

  <%-- Page Header --%>
  <div class="flex items-center gap-4 mb-4">
    <a href="${pageContext.request.contextPath}/store/products" class="w-10 h-10 rounded-xl border border-border bg-card flex items-center justify-center hover:bg-secondary transition-colors">
      <svg class="w-5 h-5 text-muted-foreground" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
    </a>
    <div>
      <h1 class="text-3xl font-serif font-semibold">Edit Product</h1>
      <p class="text-muted-foreground text-sm">Update details for <c:out value="${product.productName}"/>.</p>
    </div>
  </div>

  <%-- Meta Row --%>
  <div class="flex gap-6 flex-wrap mb-6 text-sm text-muted-foreground">
    <span class="flex items-center gap-2">
      <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
      Created <strong class="text-foreground">${mn[product.createdAt.monthValue - 1]} ${product.createdAt.dayOfMonth}, ${product.createdAt.year}</strong>
    </span>
    <span class="flex items-center gap-2">
      <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
      Updated <strong class="text-foreground">${mn[product.updatedAt.monthValue - 1]} ${product.updatedAt.dayOfMonth}, ${product.updatedAt.year}</strong>
    </span>
    <c:set var="ratingSum" value="${0}"/>
    <c:forEach var="cm" items="${comments}"><c:set var="ratingSum" value="${ratingSum + cm.rating}"/></c:forEach>
    <span class="flex items-center gap-2">
      <svg class="w-4 h-4 text-amber-500 fill-amber-500" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
      <c:choose>
        <c:when test="${not empty comments}">
          <strong class="text-foreground"><fmt:formatNumber value="${ratingSum / fn:length(comments)}" maxFractionDigits="1"/> / 5</strong> (${fn:length(comments)} review<c:if test="${fn:length(comments) != 1}">s</c:if>)
        </c:when>
        <c:otherwise>No reviews yet</c:otherwise>
      </c:choose>
    </span>
  </div>

  <c:if test="${not empty errorMessage}">
    <div class="flex items-center gap-3 p-4 rounded-xl bg-red-50 border border-red-200 text-destructive text-sm mb-6">
      <svg class="w-5 h-5 flex-shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      <span>${errorMessage}</span>
    </div>
  </c:if>

  <form method="post" action="${pageContext.request.contextPath}/store/products/${product.id}/edit" enctype="multipart/form-data" class="grid grid-cols-1 lg:grid-cols-2 gap-8">

    <%-- Left Column --%>
    <div class="space-y-6">
      <%-- Product Information --%>
      <div class="bg-card rounded-[28px] p-6 border border-border">
        <div class="flex items-center gap-3 mb-6">
          <div class="w-9 h-9 rounded-xl bg-primary/10 flex items-center justify-center">
            <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
          </div>
          <h2 class="text-xl font-serif font-semibold">Product Information</h2>
        </div>
        <div class="space-y-5">
          <div>
            <label class="block text-sm font-semibold mb-2">Product Name</label>
            <input type="text" name="productName" value="${productForm.productName}" required class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
          </div>
          <div>
            <label class="block text-sm font-semibold mb-2">Description</label>
            <textarea name="description" rows="4" class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all resize-none">${productForm.description}</textarea>
          </div>
        </div>
      </div>

      <%-- Pricing --%>
      <div class="bg-card rounded-[28px] p-6 border border-border">
        <div class="flex items-center gap-3 mb-6">
          <div class="w-9 h-9 rounded-xl bg-primary/10 flex items-center justify-center">
            <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
          </div>
          <h2 class="text-xl font-serif font-semibold">Pricing</h2>
        </div>
        <div>
          <label class="block text-sm font-semibold mb-2">Price (USD)</label>
          <div class="relative">
            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground font-semibold">$</span>
            <input type="number" step="0.01" min="0.01" name="price" value="${productForm.price}" required class="w-full pl-8 pr-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
          </div>
        </div>
      </div>

      <%-- Inventory --%>
      <div class="bg-card rounded-[28px] p-6 border border-border">
        <div class="flex items-center gap-3 mb-6">
          <div class="w-9 h-9 rounded-xl bg-primary/10 flex items-center justify-center">
            <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
          </div>
          <h2 class="text-xl font-serif font-semibold">Inventory</h2>
        </div>
        <div>
          <label class="block text-sm font-semibold mb-2">Quantity in Stock</label>
          <input type="number" step="1" min="0" name="quantity" value="${productForm.quantity}" required class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
        </div>
      </div>
    </div>

    <%-- Right Column --%>
    <div class="space-y-6">
      <%-- Image --%>
      <div class="bg-card rounded-[28px] p-6 border border-border">
        <div class="flex items-center gap-3 mb-6">
          <div class="w-9 h-9 rounded-xl bg-primary/10 flex items-center justify-center">
            <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
          </div>
          <h2 class="text-xl font-serif font-semibold">Image</h2>
        </div>

        <%-- Current Image --%>
        <div class="flex items-center gap-4 mb-5">
          <div class="w-24 h-24 rounded-xl border border-border bg-secondary flex items-center justify-center flex-shrink-0 overflow-hidden">
            <c:choose>
              <c:when test="${not empty product.image}">
                <img src="${product.image}" alt="Current" class="w-full h-full object-cover"/>
              </c:when>
              <c:otherwise>
                <svg class="w-6 h-6 text-muted-foreground" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
              </c:otherwise>
            </c:choose>
          </div>
          <p class="text-sm text-muted-foreground">Current image. Upload a new one below to replace it.</p>
        </div>

        <label class="border-2 border-dashed border-primary/30 rounded-xl bg-primary/5 p-6 text-center cursor-pointer hover:bg-primary/10 hover:border-primary transition-all" id="dropzone" for="file-input">
          <svg class="w-8 h-8 text-primary/40 mx-auto mb-2" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
          <div class="dz-title font-semibold text-sm">Drag & drop a new photo, or click to browse</div>
          <div class="dz-sub text-xs text-muted-foreground mt-1">PNG or JPG, up to 25MB — optional</div>
          <input type="file" id="file-input" name="imageFile" accept="image/*" class="hidden">
        </label>
        <div class="flex items-center gap-4 mt-4 hidden" id="preview-wrap">
          <img id="preview-img" src="" alt="Preview" class="w-16 h-16 object-contain rounded-xl border border-border bg-white"/>
          <div>
            <div class="font-semibold text-sm" id="preview-name"></div>
            <button type="button" class="text-sm text-destructive font-semibold hover:underline mt-1" id="preview-remove">Remove</button>
          </div>
        </div>
      </div>

      <%-- Actions --%>
      <div class="flex justify-between items-center gap-3 flex-wrap">
        <a href="${pageContext.request.contextPath}/store/products" class="px-6 py-3 rounded-full border-2 border-border font-semibold hover:bg-secondary transition-all">Cancel</a>
        <div class="flex gap-3">
          <button type="button" class="px-6 py-3 rounded-full border-2 border-red-200 text-destructive font-semibold hover:bg-red-50 transition-all" onclick="openDeleteModal()">
            <svg class="w-4 h-4 inline mr-1" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2"/></svg>
            Delete Product
          </button>
          <button type="submit" class="px-6 py-3 rounded-full bg-primary text-primary-foreground font-semibold hover:shadow-lg hover:-translate-y-0.5 active:scale-95 transition-all flex items-center gap-2">
            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
            Update Product
          </button>
        </div>
      </div>
    </div>
  </form>

  <%-- Comments --%>
  <div class="bg-card rounded-[28px] p-6 border border-border mt-8">
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

<%-- Delete Modal --%>
<div class="fixed inset-0 bg-black/40 backdrop-blur-sm hidden items-center justify-center z-[60]" id="delete-modal-overlay">
  <div class="bg-card rounded-[28px] p-8 w-full max-w-md shadow-xl">
    <div class="flex items-center gap-3 mb-4">
      <div class="w-10 h-10 rounded-full bg-red-50 flex items-center justify-center">
        <svg class="w-5 h-5 text-destructive" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      </div>
      <h3 class="text-xl font-serif font-semibold text-destructive">Delete Product</h3>
    </div>
    <p class="text-muted-foreground mb-6">Are you sure you want to delete "<c:out value="${product.productName}"/>"? This cannot be undone.</p>
    <div class="flex gap-3 justify-end">
      <button type="button" class="px-6 py-3 rounded-full border-2 border-border font-semibold hover:bg-secondary transition-all" onclick="closeDeleteModal()">Cancel</button>
      <form method="post" action="${pageContext.request.contextPath}/store/products/${product.id}/delete">
        <button type="submit" class="px-6 py-3 rounded-full bg-destructive text-white font-semibold hover:shadow-lg transition-all">Delete Product</button>
      </form>
    </div>
  </div>
</div>

<script>
  function openDeleteModal() {
    var modal = document.getElementById('delete-modal-overlay');
    modal.classList.remove('hidden');
    modal.classList.add('flex');
  }
  function closeDeleteModal() {
    var modal = document.getElementById('delete-modal-overlay');
    modal.classList.add('hidden');
    modal.classList.remove('flex');
  }
  document.getElementById('delete-modal-overlay').addEventListener('click', function(e) {
    if (e.target === this) closeDeleteModal();
  });

  var dropzone = document.getElementById('dropzone');
  var fileInput = document.getElementById('file-input');
  var previewWrap = document.getElementById('preview-wrap');
  var previewImg = document.getElementById('preview-img');
  var previewName = document.getElementById('preview-name');
  var previewRemove = document.getElementById('preview-remove');

  function showPreview(file) {
    if (!file) return;
    var reader = new FileReader();
    reader.onload = function(e) {
      previewImg.src = e.target.result;
      previewName.textContent = file.name;
      previewWrap.classList.remove('hidden');
      previewWrap.classList.add('flex');
    };
    reader.readAsDataURL(file);
  }

  fileInput.addEventListener('change', function() {
    if (fileInput.files && fileInput.files[0]) showPreview(fileInput.files[0]);
  });

  ['dragover', 'dragenter'].forEach(function(evt) {
    dropzone.addEventListener(evt, function(e) { e.preventDefault(); dropzone.classList.add('dragover'); });
  });
  ['dragleave', 'drop'].forEach(function(evt) {
    dropzone.addEventListener(evt, function(e) { e.preventDefault(); dropzone.classList.remove('dragover'); });
  });
  dropzone.addEventListener('drop', function(e) {
    e.preventDefault();
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
      fileInput.files = e.dataTransfer.files;
      showPreview(e.dataTransfer.files[0]);
    }
  });

  previewRemove.addEventListener('click', function(e) {
    e.preventDefault();
    fileInput.value = '';
    previewWrap.classList.add('hidden');
    previewWrap.classList.remove('flex');
  });
</script>

</body>
</html>
