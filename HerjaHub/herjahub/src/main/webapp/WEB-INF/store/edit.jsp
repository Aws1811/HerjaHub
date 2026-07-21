<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Store Profile — HerjaHub</title>
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

  .page{ max-width:840px; margin:0 auto; padding:32px 32px 60px; }

  .page-header{ margin-bottom:22px; animation:fadeInUp .4s var(--ease); }
  .page-title{ font-family:'Poppins',sans-serif; font-weight:800; font-size:26px; margin:0; }
  .page-sub{ color:var(--text-2); font-size:13.5px; margin:4px 0 0; }

  /* ===================== SIGNATURE: profile hero (banner + overlapping logo) + stats strip ===================== */
  .profile-hero{ position:relative; border-radius:var(--radius-lg); overflow:hidden; box-shadow:var(--shadow-md); margin-bottom:20px; animation:fadeInUp .4s var(--ease) .05s backwards; }
  .profile-banner{ height:110px; background:linear-gradient(120deg,var(--red),var(--green)); position:relative; }
  .profile-banner::after{ content:""; position:absolute; inset:0; background:radial-gradient(circle at 85% 20%, rgba(255,255,255,0.18), transparent 55%); }
  .profile-identity{ background:var(--white); display:flex; align-items:flex-end; gap:18px; padding:0 28px 22px; margin-top:-38px; position:relative; z-index:2; }
  .profile-logo{ width:84px; height:84px; border-radius:22px; border:5px solid var(--white); box-shadow:var(--shadow-sm); flex-shrink:0; overflow:hidden; background:linear-gradient(135deg,var(--red),var(--green)); display:flex; align-items:center; justify-content:center; }
  .profile-logo img{ width:100%; height:100%; object-fit:cover; }
  .profile-logo svg{ color:rgba(255,255,255,0.85); }
  .profile-identity h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:21px; margin:0 0 18px; color:var(--text-1); }
  .profile-identity .email{ display:block; font-size:12.5px; color:var(--text-2); font-weight:500; margin-top:-14px; }

  .stats-strip{ display:grid; grid-template-columns:repeat(3,1fr); border-top:1px solid var(--neutral-2); }
  .stat-cell{ padding:16px 10px; text-align:center; border-left:1px solid var(--neutral-2); }
  .stat-cell:first-child{ border-left:none; }
  .stat-value{ font-family:'Poppins',sans-serif; font-weight:800; font-size:20px; background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }
  .stat-label{ font-size:11.5px; color:var(--text-2); font-weight:600; margin-top:2px; }

  .error-banner{ display:flex; align-items:center; gap:10px; padding:14px 18px; border-radius:14px; background:var(--error-bg); border:1px solid #F3CACA; color:var(--red); font-size:13.5px; margin-bottom:20px; }

  .form-panel{ background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-lg); padding:24px; margin-bottom:20px; box-shadow:var(--shadow-sm); animation:fadeInUp .4s var(--ease) backwards; }
  .panel-head{ display:flex; align-items:center; gap:12px; margin-bottom:20px; }
  .panel-icon{ width:36px; height:36px; border-radius:11px; background:rgba(0,122,61,0.1); color:var(--green); display:flex; align-items:center; justify-content:center; flex-shrink:0; }
  .panel-head h2{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; margin:0; }

  .field{ margin-bottom:18px; }
  .field:last-child{ margin-bottom:0; }
  .field label{ display:block; font-size:12.5px; font-weight:700; margin-bottom:8px; }
  .field input, .field textarea{ width:100%; padding:12px 16px; border:1px solid var(--neutral-2); border-radius:14px; background:var(--neutral-1); font-size:14px; font-family:'Inter',sans-serif; transition:all .2s var(--ease); }
  .field input:focus, .field textarea:focus{ outline:none; border-color:var(--green); background:var(--white); box-shadow:0 0 0 3px rgba(0,122,61,0.12); }
  .field input:disabled{ color:var(--text-2); cursor:not-allowed; }
  .field textarea{ resize:vertical; min-height:90px; }
  .field-grid{ display:grid; grid-template-columns:1fr 1fr; gap:18px; }
  .field-note{ font-size:12px; color:var(--text-2); margin:-6px 0 18px; }

  .current-logo-row{ display:flex; align-items:center; gap:14px; margin-bottom:18px; }
  .current-logo{ width:64px; height:64px; border-radius:16px; border:1px solid var(--neutral-2); background:var(--neutral-1); display:flex; align-items:center; justify-content:center; overflow:hidden; flex-shrink:0; }
  .current-logo img{ width:100%; height:100%; object-fit:cover; }
  .current-logo-row p{ font-size:12.5px; color:var(--text-2); margin:0; }

  .dropzone{ display:flex; flex-direction:column; align-items:center; justify-content:center; border:2px dashed rgba(0,122,61,0.3); border-radius:var(--radius-md); background:rgba(0,122,61,0.04); padding:26px 20px; text-align:center; cursor:pointer; transition:all .2s var(--ease); }
  .dropzone:hover, .dropzone.dragover{ background:rgba(0,122,61,0.08); border-color:var(--green); }
  .dropzone svg{ color:var(--green); opacity:.5; margin-bottom:8px; }
  .dz-title{ font-weight:700; font-size:13.5px; }
  .dz-sub{ font-size:12px; color:var(--text-2); margin-top:4px; }
  #preview-wrap{ display:none; align-items:center; gap:14px; margin-top:16px; }
  #preview-img{ width:56px; height:56px; object-fit:contain; border-radius:14px; border:1px solid var(--neutral-2); background:#fff; }
  #preview-name{ font-weight:700; font-size:13.5px; }
  #preview-remove{ font-size:12.5px; color:var(--red); font-weight:700; background:none; border:none; cursor:pointer; padding:0; margin-top:4px; }

  .actions-row{ display:flex; justify-content:flex-end; align-items:center; gap:12px; margin-bottom:24px; }
  .btn-cancel{ padding:13px 24px; border-radius:999px; border:1.5px solid var(--neutral-2); font-weight:700; font-size:13.5px; color:var(--text-1); transition:all .2s var(--ease); }
  .btn-cancel:hover{ background:var(--neutral-1); }
  .btn-submit{ display:flex; align-items:center; gap:8px; padding:13px 26px; border-radius:999px; border:none; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:13.5px; cursor:pointer; transition:all .2s var(--ease); }
  .btn-submit:hover{ transform:translateY(-2px); box-shadow:0 14px 26px -14px rgba(0,122,61,0.5); }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); }
    .main-area{ margin-left:0; }
  }
  @media (max-width: 560px){
    .field-grid{ grid-template-columns:1fr; }
    .stats-strip{ grid-template-columns:1fr; }
    .stat-cell{ border-left:none; border-top:1px solid var(--neutral-2); }
    .stat-cell:first-child{ border-top:none; }
    .profile-identity{ flex-direction:column; align-items:flex-start; }
    .profile-identity h1{ margin-bottom:2px; }
  }
</style>
</head>
<body>

<div class="keffiyeh-corner-bg"></div>

<c:set var="mn" value="${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']}"/>

<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/store/dashboard">
        <div class="mark"><img src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="HerjaHub" /></div>
        <div class="name">HerjaHub</div>
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

    <div class="page">

        <div class="page-header">
            <h1 class="page-title">Store Profile</h1>
            <p class="page-sub">Manage how your storefront appears to customers.</p>
        </div>

        <%-- ===== Profile hero: banner + overlapping logo + stats strip ===== --%>
        <div class="profile-hero">
            <div class="profile-banner"></div>
            <div class="profile-identity">
                <div class="profile-logo">
                    <c:choose>
                        <c:when test="${not empty store.image}">
                            <img src="${pageContext.request.contextPath}${store.image}" alt="${store.storeName}" />
                        </c:when>
                        <c:otherwise>
                            <i data-lucide="store" width="30" height="30"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <h1><c:out value="${store.storeName}" /></h1>
                    <span class="email"><c:out value="${store.email}" /></span>
                </div>
            </div>
            <div class="stats-strip">
                <div class="stat-cell">
                    <div class="stat-value">${fn:length(store.products)}</div>
                    <div class="stat-label">Products</div>
                </div>
                <div class="stat-cell">
                    <div class="stat-value">${fn:length(comments)}</div>
                    <div class="stat-label">Reviews</div>
                </div>
                <div class="stat-cell">
                    <div class="stat-value">${mn[store.createdAt.monthValue - 1]} ${store.createdAt.year}</div>
                    <div class="stat-label">Joined</div>
                </div>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="error-banner">
                <i data-lucide="alert-circle" width="18" height="18"></i>
                <span><c:out value="${errorMessage}" /></span>
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/store/edit" enctype="multipart/form-data">

            <%-- ===== Store Logo ===== --%>
            <div class="form-panel">
                <div class="panel-head">
                    <div class="panel-icon"><i data-lucide="image" width="17" height="17"></i></div>
                    <h2>Store Logo</h2>
                </div>

                <div class="current-logo-row">
                    <div class="current-logo">
                        <c:choose>
                            <c:when test="${not empty store.image}">
                                <img src="${pageContext.request.contextPath}${store.image}" alt="Current logo" />
                            </c:when>
                            <c:otherwise>
                                <i data-lucide="image" width="24" height="24" style="color:var(--text-2);"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <p>Current logo. Upload a new one below to replace it.</p>
                </div>

                <label class="dropzone" id="dropzone" for="logo-input">
                    <i data-lucide="upload-cloud" width="26" height="26"></i>
                    <div class="dz-title">Drag &amp; drop a new logo, or click to browse</div>
                    <div class="dz-sub">PNG or JPG, up to 25MB — optional</div>
                    <input type="file" id="logo-input" name="logoFile" accept="image/*" style="display:none;">
                </label>
                <div id="preview-wrap">
                    <img id="preview-img" src="" alt="Preview" />
                    <div>
                        <div id="preview-name"></div>
                        <button type="button" id="preview-remove">Remove</button>
                    </div>
                </div>
            </div>

            <%-- ===== Personal Information ===== --%>
            <div class="form-panel">
                <div class="panel-head">
                    <div class="panel-icon"><i data-lucide="user" width="17" height="17"></i></div>
                    <h2>Personal Information</h2>
                </div>
                <div class="field-grid">
                    <div class="field">
                        <label>First Name</label>
                        <input type="text" name="firstName" value="${storeForm.firstName}" required />
                    </div>
                    <div class="field">
                        <label>Last Name</label>
                        <input type="text" name="lastName" value="${storeForm.lastName}" required />
                    </div>
                </div>
                <div class="field">
                    <label>Email</label>
                    <input type="text" value="${store.email}" disabled />
                </div>
                <div class="field">
                    <label>Phone</label>
                    <input type="text" name="phone" value="${storeForm.phone}" />
                </div>
            </div>

            <%-- ===== Security ===== --%>
            <div class="form-panel">
                <div class="panel-head">
                    <div class="panel-icon"><i data-lucide="lock" width="17" height="17"></i></div>
                    <h2>Security</h2>
                </div>
                <p class="field-note">Leave both fields blank to keep your current password.</p>
                <div class="field-grid">
                    <div class="field">
                        <label>Current Password</label>
                        <input type="password" name="currentPassword" />
                    </div>
                    <div class="field">
                        <label>New Password</label>
                        <input type="password" name="newPassword" />
                    </div>
                </div>
            </div>

            <%-- ===== Store Information ===== --%>
            <div class="form-panel">
                <div class="panel-head">
                    <div class="panel-icon"><i data-lucide="store" width="17" height="17"></i></div>
                    <h2>Store Information</h2>
                </div>
                <div class="field">
                    <label>Store Name</label>
                    <input type="text" name="storeName" value="${storeForm.storeName}" required />
                </div>
                <div class="field">
                    <label>Description</label>
                    <textarea name="description" rows="3">${storeForm.description}</textarea>
                </div>
                <div class="field">
                    <label>Address</label>
                    <input type="text" name="address" value="${storeForm.address}" />
                </div>
            </div>

            <div class="actions-row">
                <a class="btn-cancel" href="${pageContext.request.contextPath}/store/dashboard">Cancel</a>
                <button type="submit" class="btn-submit">
                    <i data-lucide="check" width="16" height="16"></i> Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<script>lucide.createIcons();</script>

<script>
  var logoInput = document.getElementById('logo-input');
  var dropzone = document.getElementById('dropzone');
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

  logoInput.addEventListener('change', function() {
    if (logoInput.files && logoInput.files[0]) showPreview(logoInput.files[0]);
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
      logoInput.files = e.dataTransfer.files;
      showPreview(e.dataTransfer.files[0]);
    }
  });

  previewRemove.addEventListener('click', function(e) {
    e.preventDefault();
    logoInput.value = '';
    previewWrap.style.display = 'none';
  });
</script>

</body>
</html>
