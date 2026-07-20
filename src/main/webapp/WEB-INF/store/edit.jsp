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

</head>
<body>
  <c:set var="mn" value="${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']}"/>
  <div class="topbar">
    <div class="brand"><div class="mark"><i data-lucide="leaf" style="width:19px;height:19px;"></i></div> HerjaHub</div>
    <div class="topbar-nav">
      <a href="${pageContext.request.contextPath}/store/dashboard">Dashboard</a>
      <a href="${pageContext.request.contextPath}/store/products">Products</a>
      <a class="logout" href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
  </div>

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
