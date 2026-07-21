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
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --red:#CE1126; --green:#007A3D; --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF;
    --text-1:#1F2937; --text-2:#6B7280; --error-bg:#FBEAEA; --gold:#C9A227;
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
  .sidebar-brand .mark{ width:38px; height:38px; border-radius:12px; flex-shrink:0; overflow:hidden; background:linear-gradient(135deg, var(--red), var(--green)); display:flex; align-items:center; justify-content:center; color:var(--white); font-family:'Poppins',sans-serif; font-weight:800; }
  .sidebar-brand .mark img{ width:100%; height:100%; object-fit:cover; }
  .sidebar-brand .name{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; }
  .sidebar-brand .name .hub-accent{ background:linear-gradient(90deg, #CE1126, #007A3D); -webkit-background-clip:text; background-clip:text; color:transparent; }
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

  .page{ max-width:1000px; padding:32px 32px 60px; }

  .page-header{ display:flex; align-items:center; gap:16px; margin-bottom:18px; animation:fadeInUp .4s var(--ease); }
  .back-btn{ width:42px; height:42px; border-radius:14px; border:1px solid var(--neutral-2); background:var(--white); display:flex; align-items:center; justify-content:center; color:var(--text-2); transition:all .2s var(--ease); flex-shrink:0; }
  .back-btn:hover{ border-color:var(--green); color:var(--green); }
  .page-title{ font-family:'Poppins',sans-serif; font-weight:800; font-size:26px; margin:0; }
  .page-sub{ color:var(--text-2); font-size:13.5px; margin:2px 0 0; }

  /* ===================== SIGNATURE ELEMENT vs Add Product: meta stats bar ===================== */
  .meta-bar{ display:flex; gap:22px; flex-wrap:wrap; margin-bottom:22px; padding:16px 20px; background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-md); animation:fadeInUp .4s var(--ease) .05s backwards; }
  .meta-item{ display:flex; align-items:center; gap:8px; font-size:13px; color:var(--text-2); }
  .meta-item svg{ flex-shrink:0; }
  .meta-item strong{ color:var(--text-1); }
  .meta-item .star{ color:var(--gold); }

  .error-banner{ display:flex; align-items:center; gap:10px; padding:14px 18px; border-radius:14px; background:var(--error-bg); border:1px solid #F3CACA; color:var(--red); font-size:13.5px; margin-bottom:20px; }

  .form-grid{ display:grid; grid-template-columns:1fr 1fr; gap:24px; align-items:start; }
  .form-panel{ background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-lg); padding:24px; margin-bottom:20px; box-shadow:var(--shadow-sm); animation:fadeInUp .4s var(--ease) backwards; }
  .form-panel:last-child{ margin-bottom:0; }
  .panel-head{ display:flex; align-items:center; gap:12px; margin-bottom:20px; }
  .panel-icon{ width:36px; height:36px; border-radius:11px; background:rgba(0,122,61,0.1); color:var(--green); display:flex; align-items:center; justify-content:center; flex-shrink:0; }
  .panel-head h2{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; margin:0; }

  .field{ margin-bottom:18px; }
  .field:last-child{ margin-bottom:0; }
  .field label{ display:block; font-size:12.5px; font-weight:700; margin-bottom:8px; }
  .field input, .field textarea{ width:100%; padding:12px 16px; border:1px solid var(--neutral-2); border-radius:14px; background:var(--neutral-1); font-size:14px; font-family:'Inter',sans-serif; transition:all .2s var(--ease); }
  .field input:focus, .field textarea:focus{ outline:none; border-color:var(--green); background:var(--white); box-shadow:0 0 0 3px rgba(0,122,61,0.12); }
  .field textarea{ resize:vertical; min-height:100px; }
  .price-field{ position:relative; }
  .price-field .dollar{ position:absolute; left:16px; top:50%; transform:translateY(-50%); color:var(--text-2); font-weight:700; }
  .price-field input{ padding-left:30px; }

  .current-image-row{ display:flex; align-items:center; gap:14px; margin-bottom:18px; }
  .current-image{ width:76px; height:76px; border-radius:14px; border:1px solid var(--neutral-2); background:var(--neutral-1); display:flex; align-items:center; justify-content:center; overflow:hidden; flex-shrink:0; }
  .current-image img{ width:100%; height:100%; object-fit:cover; }
  .current-image-row p{ font-size:12.5px; color:var(--text-2); margin:0; }

  .dropzone{ display:flex; flex-direction:column; align-items:center; justify-content:center; border:2px dashed rgba(0,122,61,0.3); border-radius:var(--radius-md); background:rgba(0,122,61,0.04); padding:26px 20px; text-align:center; cursor:pointer; transition:all .2s var(--ease); }
  .dropzone:hover, .dropzone.dragover{ background:rgba(0,122,61,0.08); border-color:var(--green); }
  .dropzone svg{ color:var(--green); opacity:.5; margin-bottom:8px; }
  .dz-title{ font-weight:700; font-size:13.5px; }
  .dz-sub{ font-size:12px; color:var(--text-2); margin-top:4px; }
  #preview-wrap{ display:none; align-items:center; gap:14px; margin-top:16px; }
  #preview-img{ width:64px; height:64px; object-fit:contain; border-radius:14px; border:1px solid var(--neutral-2); background:#fff; }
  #preview-name{ font-weight:700; font-size:13.5px; }
  #preview-remove{ font-size:12.5px; color:var(--red); font-weight:700; background:none; border:none; cursor:pointer; padding:0; margin-top:4px; }

  .actions-row{ display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap; }
  .btn-cancel{ padding:13px 24px; border-radius:999px; border:1.5px solid var(--neutral-2); font-weight:700; font-size:13.5px; color:var(--text-1); transition:all .2s var(--ease); }
  .btn-cancel:hover{ background:var(--neutral-1); }
  .btn-delete{ display:flex; align-items:center; gap:7px; padding:13px 22px; border-radius:999px; border:1.5px solid #F3CACA; background:none; color:var(--red); font-weight:700; font-size:13.5px; cursor:pointer; transition:all .2s var(--ease); }
  .btn-delete:hover{ background:var(--error-bg); }
  .btn-submit{ display:flex; align-items:center; gap:8px; padding:13px 26px; border-radius:999px; border:none; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:13.5px; cursor:pointer; transition:all .2s var(--ease); }
  .btn-submit:hover{ transform:translateY(-2px); box-shadow:0 14px 26px -14px rgba(0,122,61,0.5); }
  .actions-right{ display:flex; gap:12px; }

  /* ===== Comments panel below the form ===== */
  /* ===== Delete confirmation modal ===== */
  .modal-overlay{ display:none; position:fixed; inset:0; background:rgba(17,17,17,0.45); backdrop-filter:blur(4px); align-items:center; justify-content:center; z-index:60; }
  .modal-box{ background:var(--white); border-radius:var(--radius-lg); padding:30px; width:100%; max-width:420px; margin:0 20px; box-shadow:var(--shadow-md); }
  .modal-head{ display:flex; align-items:center; gap:12px; margin-bottom:14px; }
  .modal-icon{ width:42px; height:42px; border-radius:50%; background:var(--error-bg); color:var(--red); display:flex; align-items:center; justify-content:center; flex-shrink:0; }
  .modal-box h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:18px; color:var(--red); margin:0; }
  .modal-box p{ color:var(--text-2); font-size:14px; margin:0 0 22px; }
  .modal-actions{ display:flex; justify-content:flex-end; gap:10px; }
  .modal-actions button[type=submit]{ background:var(--red); color:#fff; border:none; padding:12px 22px; border-radius:999px; font-weight:700; font-size:13.5px; cursor:pointer; }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); transition:transform .3s ease; }
    .sidebar.open{ transform:translateX(0); }
    .menu-btn{ display:flex; }
    .sidebar-overlay.show{ display:block; }
    .main-area{ margin-left:0; }
    .form-grid{ grid-template-columns:1fr; }
  }

  .menu-btn{ display:none; width:40px; height:40px; border-radius:12px; border:1px solid var(--neutral-2); background:var(--white); color:var(--text-1); align-items:center; justify-content:center; cursor:pointer; flex-shrink:0; }
  .sidebar-overlay{ display:none; position:fixed; inset:0; z-index:25; background:rgba(17,17,17,0.35); }
</style>
</head>
<body>

<div class="keffiyeh-corner-bg"></div>

<c:set var="mn" value="${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']}"/>

<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/store/dashboard">
        <div class="mark"><img src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="HerjaHub" /></div><div class="name">Herja<span class="hub-accent">Hub</span></div>
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

<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="main-area">
    <div class="topbar">
        <button class="menu-btn" id="menuBtn" type="button" aria-label="Open menu"><i data-lucide="menu" width="20" height="20"></i></button>
        <div class="topbar-title">Edit Product</div>
        <div class="user-chip">
            <div class="user-avatar"><c:out value="${fn:substring(store.storeName, 0, 1)}" /></div>
            <span class="u-name"><c:out value="${store.storeName}" /></span>
        </div>
    </div>

    <div class="page">

        <div class="page-header">
            <a class="back-btn" href="${pageContext.request.contextPath}/store/products">
                <i data-lucide="arrow-left" width="18" height="18"></i>
            </a>
            <div>
                <h1 class="page-title">Edit Product</h1>
                <p class="page-sub">Update details for <c:out value="${product.productName}" />.</p>
            </div>
        </div>

        <%-- ===== Meta stats bar ===== --%>
        <div class="meta-bar">
            <div class="meta-item">
                <i data-lucide="calendar" width="15" height="15"></i>
                Created <strong>${mn[product.createdAt.monthValue - 1]} ${product.createdAt.dayOfMonth}, ${product.createdAt.year}</strong>
            </div>
            <div class="meta-item">
                <i data-lucide="clock" width="15" height="15"></i>
                Updated <strong>${mn[product.updatedAt.monthValue - 1]} ${product.updatedAt.dayOfMonth}, ${product.updatedAt.year}</strong>
            </div>
            <c:set var="ratingSum" value="${0}" />
            <c:forEach var="cm" items="${comments}"><c:set var="ratingSum" value="${ratingSum + cm.rating}" /></c:forEach>
            <div class="meta-item">
                <i data-lucide="star" width="15" height="15" class="star"></i>
                <c:choose>
                    <c:when test="${not empty comments}">
                        <strong><fmt:formatNumber value="${ratingSum / fn:length(comments)}" maxFractionDigits="1" /> / 5</strong>&nbsp;(${fn:length(comments)} review<c:if test="${fn:length(comments) != 1}">s</c:if>)
                    </c:when>
                    <c:otherwise>No reviews yet</c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="error-banner">
                <i data-lucide="alert-circle" width="18" height="18"></i>
                <span><c:out value="${errorMessage}" /></span>
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/store/products/${product.id}/edit" enctype="multipart/form-data">
            <div class="form-grid">

                <%-- Left column --%>
                <div>
                    <div class="form-panel">
                        <div class="panel-head">
                            <div class="panel-icon"><i data-lucide="file-text" width="17" height="17"></i></div>
                            <h2>Product Information</h2>
                        </div>
                        <div class="field">
                            <label>Product Name</label>
                            <input type="text" name="productName" value="${productForm.productName}" required />
                        </div>
                        <div class="field">
                            <label>Description</label>
                            <textarea name="description" rows="4">${productForm.description}</textarea>
                        </div>
                    </div>

                    <div class="form-panel">
                        <div class="panel-head">
                            <div class="panel-icon"><i data-lucide="dollar-sign" width="17" height="17"></i></div>
                            <h2>Pricing</h2>
                        </div>
                        <div class="field">
                            <label>Price (USD)</label>
                            <div class="price-field">
                                <span class="dollar">$</span>
                                <input type="number" step="0.01" min="0.01" name="price" value="${productForm.price}" required />
                            </div>
                        </div>
                    </div>

                    <div class="form-panel">
                        <div class="panel-head">
                            <div class="panel-icon"><i data-lucide="shopping-bag" width="17" height="17"></i></div>
                            <h2>Inventory</h2>
                        </div>
                        <div class="field">
                            <label>Quantity in Stock</label>
                            <input type="number" step="1" min="0" name="quantity" value="${productForm.quantity}" required />
                        </div>
                    </div>
                </div>

                <%-- Right column --%>
                <div>
                    <div class="form-panel">
                        <div class="panel-head">
                            <div class="panel-icon"><i data-lucide="image" width="17" height="17"></i></div>
                            <h2>Image</h2>
                        </div>

                        <div class="current-image-row">
                            <div class="current-image">
                                <c:choose>
                                    <c:when test="${not empty product.image}">
                                        <img src="${pageContext.request.contextPath}${product.image}" alt="Current" />
                                    </c:when>
                                    <c:otherwise>
                                        <i data-lucide="image" width="24" height="24" style="color:var(--text-2);"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <p>Current image. Upload a new one below to replace it.</p>
                        </div>

                        <label class="dropzone" id="dropzone" for="file-input">
                            <i data-lucide="upload-cloud" width="28" height="28"></i>
                            <div class="dz-title">Drag & drop a new photo, or click to browse</div>
                            <div class="dz-sub">PNG or JPG, up to 25MB — optional</div>
                            <input type="file" id="file-input" name="imageFile" accept="image/*" style="display:none;">
                        </label>
                        <div id="preview-wrap">
                            <img id="preview-img" src="" alt="Preview" />
                            <div>
                                <div id="preview-name"></div>
                                <button type="button" id="preview-remove">Remove</button>
                            </div>
                        </div>
                    </div>

                    <div class="actions-row">
                        <a class="btn-cancel" href="${pageContext.request.contextPath}/store/products">Cancel</a>
                        <div class="actions-right">
                            <button type="button" class="btn-delete" onclick="openDeleteModal()">
                                <i data-lucide="trash-2" width="15" height="15"></i> Delete
                            </button>
                            <button type="submit" class="btn-submit">
                                <i data-lucide="check" width="16" height="16"></i> Update Product
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<%-- ===== Delete confirmation modal ===== --%>
<div class="modal-overlay" id="delete-modal-overlay">
    <div class="modal-box">
        <div class="modal-head">
            <div class="modal-icon"><i data-lucide="alert-triangle" width="20" height="20"></i></div>
            <h3>Delete Product</h3>
        </div>
        <p>Are you sure you want to delete "<c:out value="${product.productName}" />"? This cannot be undone.</p>
        <div class="modal-actions">
            <button type="button" class="btn-cancel" onclick="closeDeleteModal()">Cancel</button>
            <form method="post" action="${pageContext.request.contextPath}/store/products/${product.id}/delete">
                <button type="submit">Delete Product</button>
            </form>
        </div>
    </div>
</div>

<script>lucide.createIcons();</script>

<script>
  function openDeleteModal() {
    document.getElementById('delete-modal-overlay').style.display = 'flex';
  }
  function closeDeleteModal() {
    document.getElementById('delete-modal-overlay').style.display = 'none';
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
      previewWrap.style.display = 'flex';
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
    previewWrap.style.display = 'none';
  });
</script>


<script>
  (function(){
    var b=document.getElementById('menuBtn'), s=document.querySelector('.sidebar'), o=document.getElementById('sidebarOverlay');
    if(!b||!s||!o) return;
    b.addEventListener('click', function(){ s.classList.add('open'); o.classList.add('show'); });
    o.addEventListener('click', function(){ s.classList.remove('open'); o.classList.remove('show'); });
  })();
</script>
</body>
</html>
