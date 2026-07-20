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
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --olive:#4B5D3A; --olive-dark:#39492B; --olive-light:#EEF1E6;
    --sage:#93A57F; --ivory:#FBF8F0; --white:#FFFFFF;
    --gold:#C9A227; --gold-light:#F8F0DA;
    --charcoal:#2B2A24; --muted:#7C7969;
    --border:#E9E4D6; --error:#B3483F; --error-bg:#FBEAE8;
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

  .page-wrap{ max-width:820px; margin:0 auto; padding:32px 24px 60px; }

  .page-header{ display:flex; align-items:center; gap:14px; margin-bottom:10px; }
  .back-link{ width:38px; height:38px; border-radius:11px; border:1px solid var(--border); background:var(--white); display:flex; align-items:center; justify-content:center; color:var(--muted); text-decoration:none; }
  .back-link:hover{ background:var(--olive-light); color:var(--olive-dark); }
  .page-header h1{ font-family:'Newsreader',serif; font-weight:600; font-size:27px; margin:0; }
  .page-header p{ margin:2px 0 0; color:var(--muted); font-size:14px; }

  .meta-row{ display:flex; gap:22px; flex-wrap:wrap; margin:16px 0 22px; font-size:13px; color:var(--muted); }
  .meta-row span{ display:flex; align-items:center; gap:6px; }
  .meta-row strong{ color:var(--charcoal); }
  .stars{ color:var(--gold); }

  .error-banner{ display:flex; align-items:center; gap:10px; color:var(--error); font-size:13.5px; background:var(--error-bg); border:1px solid #f0c9c4; border-radius:var(--radius-md); padding:12px 16px; margin-bottom:18px; }

  .card{ background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:26px; box-shadow:var(--shadow-sm); margin-bottom:20px; }
  .card-title{ display:flex; align-items:center; gap:10px; margin-bottom:18px; }
  .card-title .ic{ width:36px; height:36px; border-radius:10px; background:var(--olive-light); color:var(--olive-dark); display:flex; align-items:center; justify-content:center; }
  .card-title h2{ font-family:'Newsreader',serif; font-size:18px; margin:0; }

  label{ display:block; font-size:13px; font-weight:700; margin:0 0 6px; }
  .field{ margin-bottom:16px; }
  .field:last-child{ margin-bottom:0; }
  input[type=text], input[type=number], textarea{ width:100%; padding:11px 13px; border:1px solid var(--border); border-radius:var(--radius-sm); font-size:14px; font-family:'Inter',sans-serif; background:var(--ivory); transition:all .15s ease; }
  input[type=text]:focus, input[type=number]:focus, textarea:focus{ outline:none; border-color:var(--olive); background:var(--white); box-shadow:0 0 0 3px var(--olive-light); }
  textarea{ min-height:100px; resize:vertical; }
  .price-input-wrap{ position:relative; }
  .price-input-wrap span{ position:absolute; left:13px; top:50%; transform:translateY(-50%); color:var(--muted); font-weight:600; }
  .price-input-wrap input{ padding-left:28px; }

  .current-image{ display:flex; align-items:center; gap:16px; margin-bottom:16px; }
  .current-image .thumb{ width:96px; height:96px; border-radius:14px; border:1px solid var(--border); background:var(--olive-light) center/contain no-repeat; display:flex; align-items:center; justify-content:center; color:var(--sage); flex-shrink:0; }
  .dropzone{ border:2px dashed var(--sage); border-radius:var(--radius-md); background:var(--olive-light); padding:26px 20px; text-align:center; cursor:pointer; transition:all .18s ease; }
  .dropzone:hover, .dropzone.dragover{ background:#E4EBDA; border-color:var(--olive); }
  .dropzone i{ color:var(--olive); }
  .dropzone .dz-title{ font-weight:700; margin:8px 0 4px; font-size:13.5px; }
  .dropzone .dz-sub{ font-size:12px; color:var(--muted); }
  .dropzone input[type=file]{ display:none; }
  .preview-wrap{ margin-top:14px; display:none; align-items:center; gap:14px; }
  .preview-wrap img{ width:72px; height:72px; object-fit:contain; border-radius:12px; border:1px solid var(--border); background:var(--white); }
  .preview-remove{ font-size:13px; color:var(--error); cursor:pointer; font-weight:700; background:none; border:none; }

  .actions-bar{ display:flex; justify-content:space-between; align-items:center; gap:10px; margin-top:6px; flex-wrap:wrap; }
  .actions-right{ display:flex; gap:10px; }
  .btn{ border:none; border-radius:var(--radius-sm); padding:12px 22px; font-weight:700; font-size:14px; cursor:pointer; font-family:'Inter',sans-serif; display:inline-flex; align-items:center; gap:8px; transition:transform .15s ease, box-shadow .15s ease; }
  .btn-primary{ background:var(--olive); color:#fff; box-shadow:var(--shadow-sm); }
  .btn-primary:hover{ background:var(--olive-dark); transform:translateY(-1px); box-shadow:var(--shadow-md); }
  .btn-ghost{ background:var(--white); color:var(--charcoal); border:1px solid var(--border); }
  .btn-ghost:hover{ background:var(--olive-light); }
  .btn-danger{ background:var(--white); color:var(--error); border:1px solid #f0c9c4; }
  .btn-danger:hover{ background:var(--error-bg); }

  .comments-card .comment{ padding:14px 0; border-bottom:1px solid var(--border); }
  .comments-card .comment:last-child{ border-bottom:none; }
  .comment-top{ display:flex; justify-content:space-between; font-size:13.5px; margin-bottom:4px; }
  .comment-who{ font-weight:700; }
  .comment-text{ font-size:13.5px; color:var(--muted); }
  .empty-mini{ text-align:center; padding:20px; color:var(--muted); font-size:13.5px; }

  .modal-overlay{ display:none; position:fixed; inset:0; background:rgba(43,41,35,0.45); backdrop-filter:blur(3px); align-items:center; justify-content:center; z-index:60; }
  .modal-overlay.active{ display:flex; }
  .modal{ background:var(--white); border-radius:var(--radius-lg); padding:26px; width:100%; max-width:400px; box-shadow:var(--shadow-md); }
  .modal h3{ font-family:'Newsreader',serif; margin:0 0 8px; font-size:19px; display:flex; align-items:center; gap:10px; color:var(--error); }
  .modal p{ color:var(--muted); font-size:14px; margin:0 0 20px; }
  .modal-actions{ display:flex; gap:10px; justify-content:flex-end; }

  @media (max-width:600px){ .page-wrap{ padding:20px 14px 40px; } }
</style>
</head>
<body>
  <div class="topbar">
    <div class="brand"><div class="mark"><i data-lucide="leaf" style="width:19px;height:19px;"></i></div> HerjaHub</div>
  </div>

  <div class="page-wrap">
    <div class="page-header">
      <a class="back-link" href="${pageContext.request.contextPath}/store/products"><i data-lucide="arrow-left" style="width:17px;height:17px;"></i></a>
      <div>
        <h1>Edit Product</h1>
        <p>Update details for <c:out value="${product.productName}"/>.</p>
      </div>
    </div>

    <c:set var="mn" value="${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']}"/>
    <div class="meta-row">
      <span><i data-lucide="calendar-plus" style="width:14px;height:14px;"></i> Created <strong>${mn[product.createdAt.monthValue - 1]} ${product.createdAt.dayOfMonth}, ${product.createdAt.year}</strong></span>
      <span><i data-lucide="calendar-clock" style="width:14px;height:14px;"></i> Updated <strong>${mn[product.updatedAt.monthValue - 1]} ${product.updatedAt.dayOfMonth}, ${product.updatedAt.year}</strong></span>
      <c:set var="ratingSum" value="${0}"/>
      <c:forEach var="cm" items="${comments}"><c:set var="ratingSum" value="${ratingSum + cm.rating}"/></c:forEach>
      <span>
        <i data-lucide="star" style="width:14px;height:14px;" class="stars"></i>
        <c:choose>
          <c:when test="${not empty comments}">
            <strong><fmt:formatNumber value="${ratingSum / fn:length(comments)}" maxFractionDigits="1"/> / 5</strong> (${fn:length(comments)} review<c:if test="${fn:length(comments) != 1}">s</c:if>)
          </c:when>
          <c:otherwise>No reviews yet</c:otherwise>
        </c:choose>
      </span>
    </div>

    <c:if test="${not empty errorMessage}">
      <div class="error-banner"><i data-lucide="alert-circle" style="width:17px;height:17px;"></i> ${errorMessage}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/store/products/${product.id}/edit" enctype="multipart/form-data">

      <div class="card">
        <div class="card-title"><div class="ic"><i data-lucide="file-text" style="width:18px;height:18px;"></i></div><h2>Product Information</h2></div>
        <div class="field">
          <label>Product Name</label>
          <input type="text" name="productName" value="${productForm.productName}" required>
        </div>
        <div class="field">
          <label>Description</label>
          <textarea name="description">${productForm.description}</textarea>
        </div>
      </div>

      <div class="card">
        <div class="card-title"><div class="ic"><i data-lucide="tag" style="width:18px;height:18px;"></i></div><h2>Pricing</h2></div>
        <div class="field">
          <label>Price (USD)</label>
          <div class="price-input-wrap">
            <span>$</span>
            <input type="number" step="0.01" min="0.01" name="price" value="${productForm.price}" required>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-title"><div class="ic"><i data-lucide="boxes" style="width:18px;height:18px;"></i></div><h2>Inventory</h2></div>
        <div class="field">
          <label>Quantity in Stock</label>
          <input type="number" step="1" min="0" name="quantity" value="${productForm.quantity}" required>
        </div>
      </div>

      <div class="card">
        <div class="card-title"><div class="ic"><i data-lucide="image-plus" style="width:18px;height:18px;"></i></div><h2>Image</h2></div>

        <div class="current-image">
          <c:choose>
            <c:when test="${not empty product.image}">
              <div class="thumb" style="background-image:url('${product.image}')"></div>
            </c:when>
            <c:otherwise>
              <div class="thumb"><i data-lucide="image" style="width:24px;height:24px;"></i></div>
            </c:otherwise>
          </c:choose>
          <div style="font-size:13px; color:var(--muted);">Current image. Upload a new one below to replace it.</div>
        </div>

        <label class="dropzone" id="dropzone" for="file-input">
          <i data-lucide="upload-cloud" style="width:28px;height:28px;"></i>
          <div class="dz-title">Drag & drop a new photo, or click to browse</div>
          <div class="dz-sub">PNG or JPG, up to 25MB — optional</div>
          <input type="file" id="file-input" name="imageFile" accept="image/*">
        </label>
        <div class="preview-wrap" id="preview-wrap">
          <img id="preview-img" src="" alt="Preview">
          <div>
            <div style="font-weight:700; font-size:13.5px;" id="preview-name"></div>
            <button type="button" class="preview-remove" id="preview-remove">Remove</button>
          </div>
        </div>
      </div>

      <div class="actions-bar">
        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/store/products">Cancel</a>
        <div class="actions-right">
          <button type="button" class="btn btn-danger" onclick="openDeleteModal()"><i data-lucide="trash-2" style="width:16px;height:16px;"></i> Delete Product</button>
          <button type="submit" class="btn btn-primary"><i data-lucide="check" style="width:16px;height:16px;"></i> Update Product</button>
        </div>
      </div>
    </form>

    <div class="card comments-card">
      <div class="card-title"><div class="ic"><i data-lucide="message-square" style="width:18px;height:18px;"></i></div><h2>Comments</h2></div>
      <c:forEach var="cm" items="${comments}">
        <div class="comment">
          <div class="comment-top">
            <span class="comment-who"><c:out value="${cm.customerName}"/></span>
            <span class="stars">${cm.rating}/5 <i data-lucide="star" style="width:12px;height:12px;"></i></span>
          </div>
          <div class="comment-text"><c:out value="${cm.comment}"/></div>
        </div>
      </c:forEach>
      <c:if test="${empty comments}">
        <div class="empty-mini">No comments on this product yet.</div>
      </c:if>
    </div>
  </div>

  <!-- DELETE CONFIRMATION MODAL -->
  <div class="modal-overlay" id="delete-modal-overlay">
    <div class="modal">
      <h3><i data-lucide="alert-triangle" style="width:20px;height:20px;"></i> Delete Product</h3>
      <p>Are you sure you want to delete "<c:out value="${product.productName}"/>"? This cannot be undone.</p>
      <form method="post" action="${pageContext.request.contextPath}/store/products/${product.id}/delete">
        <div class="modal-actions">
          <button type="button" class="btn btn-ghost" onclick="closeDeleteModal()">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete Product</button>
        </div>
      </form>
    </div>
  </div>

<script>
  try { if (window.lucide) { lucide.createIcons(); } } catch (e) { console.warn("Icon rendering failed:", e); }

  function openDeleteModal() { document.getElementById('delete-modal-overlay').classList.add('active'); }
  function closeDeleteModal() { document.getElementById('delete-modal-overlay').classList.remove('active'); }
  document.getElementById('delete-modal-overlay').addEventListener('click', function (e) {
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
    reader.onload = function (e) {
      previewImg.src = e.target.result;
      previewName.textContent = file.name;
      previewWrap.style.display = 'flex';
    };
    reader.readAsDataURL(file);
  }

  fileInput.addEventListener('change', function () {
    if (fileInput.files && fileInput.files[0]) showPreview(fileInput.files[0]);
  });

  ['dragover', 'dragenter'].forEach(function (evt) {
    dropzone.addEventListener(evt, function (e) { e.preventDefault(); dropzone.classList.add('dragover'); });
  });
  ['dragleave', 'drop'].forEach(function (evt) {
    dropzone.addEventListener(evt, function (e) { e.preventDefault(); dropzone.classList.remove('dragover'); });
  });
  dropzone.addEventListener('drop', function (e) {
    e.preventDefault();
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
      fileInput.files = e.dataTransfer.files;
      showPreview(e.dataTransfer.files[0]);
    }
  });

  previewRemove.addEventListener('click', function (e) {
    e.preventDefault();
    fileInput.value = '';
    previewWrap.style.display = 'none';
  });
</script>
</body>
</html>
