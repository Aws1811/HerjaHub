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

  .topbar{ display:flex; align-items:center; justify-content:space-between; padding:16px 32px; background:var(--white); border-bottom:1px solid var(--border); }
  .brand{ display:flex; align-items:center; gap:10px; font-family:'Newsreader',serif; font-weight:600; font-size:20px; color:var(--olive-dark); }
  .brand .mark{ width:36px; height:36px; border-radius:11px; background:linear-gradient(155deg,var(--olive),var(--olive-dark)); color:var(--gold-light); display:flex; align-items:center; justify-content:center; }
  .topbar-nav{ display:flex; gap:8px; }
  .topbar-nav a{ padding:9px 14px; border-radius:var(--radius-sm); text-decoration:none; font-weight:600; font-size:13.5px; color:var(--muted); }
  .topbar-nav a:hover{ background:var(--olive-light); color:var(--olive-dark); }
  .topbar-nav a.logout:hover{ background:var(--error-bg); color:var(--error); }

  .page-wrap{ max-width:900px; margin:0 auto; padding:32px 24px 60px; }

  .error-banner{ display:flex; align-items:center; gap:10px; color:var(--error); font-size:13.5px; background:var(--error-bg); border:1px solid #f0c9c4; border-radius:var(--radius-md); padding:12px 16px; margin-bottom:18px; }

  .profile-header{ display:flex; align-items:center; gap:20px; background:linear-gradient(120deg,var(--olive-dark), var(--olive) 70%); border-radius:var(--radius-lg); padding:28px 30px; color:var(--white); margin-bottom:22px; box-shadow:var(--shadow-md); }
  .profile-logo{ width:84px; height:84px; border-radius:20px; background:rgba(255,255,255,0.15) center/contain no-repeat; border:2px solid rgba(255,255,255,0.35); display:flex; align-items:center; justify-content:center; flex-shrink:0; }
  .profile-header h1{ font-family:'Newsreader',serif; font-size:25px; margin:0 0 4px; }
  .profile-header p{ margin:0; color:rgba(255,255,255,0.8); font-size:14px; }

  .stats-grid{ display:grid; grid-template-columns:repeat(3,1fr); gap:16px; margin-bottom:22px; }
  .stat-card{ background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:18px; text-align:center; box-shadow:var(--shadow-sm); }
  .stat-card .num{ font-family:'Newsreader',serif; font-size:26px; font-weight:600; color:var(--olive-dark); }
  .stat-card .lbl{ font-size:12.5px; color:var(--muted); font-weight:600; margin-top:2px; }

  .card{ background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:26px; box-shadow:var(--shadow-sm); margin-bottom:20px; }
  .card-title{ display:flex; align-items:center; gap:10px; margin-bottom:18px; }
  .card-title .ic{ width:36px; height:36px; border-radius:10px; background:var(--olive-light); color:var(--olive-dark); display:flex; align-items:center; justify-content:center; }
  .card-title h2{ font-family:'Newsreader',serif; font-size:18px; margin:0; }

  .field-grid{ display:grid; grid-template-columns:1fr 1fr; gap:16px; }
  label{ display:block; font-size:13px; font-weight:700; margin:0 0 6px; }
  .field{ margin-bottom:16px; }
  .field.full{ grid-column:1 / -1; }
  input[type=text], input[type=password], textarea{ width:100%; padding:11px 13px; border:1px solid var(--border); border-radius:var(--radius-sm); font-size:14px; font-family:'Inter',sans-serif; background:var(--ivory); transition:all .15s ease; }
  input:disabled{ background:#F1EEE5; color:var(--muted); }
  input[type=text]:focus, input[type=password]:focus, textarea:focus{ outline:none; border-color:var(--olive); background:var(--white); box-shadow:0 0 0 3px var(--olive-light); }
  textarea{ min-height:80px; resize:vertical; }
  .hint{ font-size:12.5px; color:var(--muted); margin:2px 0 14px; }

  .dropzone{ border:2px dashed var(--sage); border-radius:var(--radius-md); background:var(--olive-light); padding:20px; text-align:center; cursor:pointer; transition:all .18s ease; display:flex; align-items:center; gap:14px; justify-content:center; }
  .dropzone:hover, .dropzone.dragover{ background:#E4EBDA; border-color:var(--olive); }
  .dropzone i{ color:var(--olive); }
  .dropzone input[type=file]{ display:none; }
  .dz-text{ text-align:left; }
  .dz-title{ font-weight:700; font-size:13.5px; }
  .dz-sub{ font-size:12px; color:var(--muted); }

  .actions-bar{ display:flex; justify-content:flex-end; gap:10px; margin-top:6px; }
  .btn{ border:none; border-radius:var(--radius-sm); padding:12px 22px; font-weight:700; font-size:14px; cursor:pointer; font-family:'Inter',sans-serif; display:inline-flex; align-items:center; gap:8px; transition:transform .15s ease, box-shadow .15s ease; }
  .btn-primary{ background:var(--olive); color:#fff; box-shadow:var(--shadow-sm); }
  .btn-primary:hover{ background:var(--olive-dark); transform:translateY(-1px); box-shadow:var(--shadow-md); }
  .btn-ghost{ background:var(--white); color:var(--charcoal); border:1px solid var(--border); }
  .btn-ghost:hover{ background:var(--olive-light); }

  .comment{ padding:14px 0; border-bottom:1px solid var(--border); }
  .comment:last-child{ border-bottom:none; }
  .comment-top{ display:flex; justify-content:space-between; font-size:13.5px; margin-bottom:4px; flex-wrap:wrap; gap:4px; }
  .comment-who{ font-weight:700; }
  .comment-product{ color:var(--muted); font-style:italic; font-size:12.5px; }
  .comment-text{ font-size:13.5px; color:var(--muted); }
  .empty-mini{ text-align:center; padding:20px; color:var(--muted); font-size:13.5px; }

  @media (max-width:700px){
    .field-grid{ grid-template-columns:1fr; }
    .stats-grid{ grid-template-columns:1fr; }
    .profile-header{ flex-direction:column; text-align:center; }
    .page-wrap{ padding:20px 14px 40px; }
  }
</style>
</head>
<body>
  
  <div class="page-wrap">

    <div class="profile-header">
      <c:choose>
        <c:when test="${not empty store.image}">
          <div class="profile-logo" style="background-image:url('${store.image}')"></div>
        </c:when>
        <c:otherwise>
          <div class="profile-logo"><i data-lucide="store" style="width:32px;height:32px;"></i></div>
        </c:otherwise>
      </c:choose>
      <div>
        <h1><c:out value="${store.storeName}"/></h1>
        <p><c:out value="${store.email}"/></p>
      </div>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="num">${fn:length(store.products)}</div>
        <div class="lbl">Products</div>
      </div>
      <div class="stat-card">
        <div class="num">${fn:length(comments)}</div>
        <div class="lbl">Reviews</div>
      </div>
      <div class="stat-card">
        <div class="num">${mn[store.createdAt.monthValue - 1]} ${store.createdAt.year}</div>
        <div class="lbl">Joined</div>
      </div>
    </div>

    <c:if test="${not empty errorMessage}">
      <div class="error-banner"><i data-lucide="alert-circle" style="width:17px;height:17px;"></i> ${errorMessage}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/store/edit" enctype="multipart/form-data">

      <div class="card">
        <div class="card-title"><div class="ic"><i data-lucide="image-plus" style="width:18px;height:18px;"></i></div><h2>Store Logo</h2></div>
        <label class="dropzone" for="logo-input">
          <i data-lucide="upload-cloud" style="width:26px;height:26px;"></i>
          <div class="dz-text">
            <div class="dz-title">Click to upload a new logo</div>
            <div class="dz-sub">PNG or JPG, up to 25MB — optional</div>
          </div>
          <input type="file" id="logo-input" name="logoFile" accept="image/*">
        </label>
      </div>

      <div class="card">
        <div class="card-title"><div class="ic"><i data-lucide="user" style="width:18px;height:18px;"></i></div><h2>Personal Information</h2></div>
        <div class="field-grid">
          <div class="field">
            <label>First Name</label>
            <input type="text" name="firstName" value="${storeForm.firstName}" required>
          </div>
          <div class="field">
            <label>Last Name</label>
            <input type="text" name="lastName" value="${storeForm.lastName}" required>
          </div>
          <div class="field full">
            <label>Email</label>
            <input type="text" value="${store.email}" disabled>
          </div>
          <div class="field full">
            <label>Phone (10 digits)</label>
            <input type="text" name="phone" value="${storeForm.phone}">
          </div>
        </div>

        <p class="hint">Leave the password fields blank to keep your current password.</p>
        <div class="field-grid">
          <div class="field">
            <label>Current Password</label>
            <input type="password" name="currentPassword">
          </div>
          <div class="field">
            <label>New Password</label>
            <input type="password" name="newPassword">
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-title"><div class="ic"><i data-lucide="store" style="width:18px;height:18px;"></i></div><h2>Store Information</h2></div>
        <div class="field">
          <label>Store Name</label>
          <input type="text" name="storeName" value="${storeForm.storeName}" required>
        </div>
        <div class="field">
          <label>Description</label>
          <textarea name="description">${storeForm.description}</textarea>
        </div>
        <div class="field">
          <label>Address</label>
          <input type="text" name="address" value="${storeForm.address}">
        </div>
      </div>

      <div class="actions-bar">
        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/store/dashboard">Cancel</a>
        <button type="submit" class="btn btn-primary"><i data-lucide="check" style="width:16px;height:16px;"></i> Save Changes</button>
      </div>
    </form>

    <div class="card">
      <div class="card-title"><div class="ic"><i data-lucide="message-square" style="width:18px;height:18px;"></i></div><h2>Comments (from Product Details)</h2></div>
      <c:forEach var="cm" items="${comments}">
        <div class="comment">
          <div class="comment-top">
            <span><span class="comment-who"><c:out value="${cm.customerName}"/></span> &middot; <span class="comment-product"><c:out value="${cm.productName}"/></span></span>
            <span>${cm.rating}/5 <i data-lucide="star" style="width:12px;height:12px;color:var(--gold);"></i></span>
          </div>
          <div class="comment-text"><c:out value="${cm.comment}"/></div>
        </div>
      </c:forEach>
      <c:if test="${empty comments}">
        <div class="empty-mini">No comments yet across any of your products.</div>
      </c:if>
    </div>
  </div>

<script>
  try { if (window.lucide) { lucide.createIcons(); } } catch (e) { console.warn("Icon rendering failed:", e); }
  var logoInput = document.getElementById('logo-input');
  var dropzone = logoInput.closest('.dropzone');
  logoInput.addEventListener('change', function () {
    if (logoInput.files && logoInput.files[0]) {
      dropzone.querySelector('.dz-title').textContent = logoInput.files[0].name;
    }
  });
</script>
</body>
</html>
