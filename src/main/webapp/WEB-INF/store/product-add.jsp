<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Product — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;0,6..72,700;1,6..72,500&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  
  .actions-bar{ display:flex; justify-content:flex-end; gap:10px; margin-top:6px; }
  .btn{ border:none; border-radius:var(--radius-sm); padding:12px 22px; font-weight:700; font-size:14px; cursor:pointer; font-family:'Inter',sans-serif; display:inline-flex; align-items:center; gap:8px; transition:transform .15s ease, box-shadow .15s ease; }
  .btn-primary{ background:var(--olive); color:#fff; box-shadow:var(--shadow-sm); }
  .btn-primary:hover{ background:var(--olive-dark); transform:translateY(-1px); box-shadow:var(--shadow-md); }
  .btn-ghost{ background:var(--white); color:var(--charcoal); border:1px solid var(--border); }
  .btn-ghost:hover{ background:var(--olive-light); }

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
        <h1>Add Product</h1>
        <p>List a new handmade item in your store.</p>
      </div>
    </div>

    <c:if test="${not empty errorMessage}">
      <div class="error-banner"><i data-lucide="alert-circle" style="width:17px;height:17px;"></i> ${errorMessage}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/store/products/add" enctype="multipart/form-data">

      <div class="card">
        <div class="card-title"><div class="ic"><i data-lucide="file-text" style="width:18px;height:18px;"></i></div><h2>Product Information</h2></div>
        <div class="field">
          <label>Product Name</label>
          <input type="text" name="productName" value="${productForm.productName}" placeholder="e.g. Hand-carved Olive Wood Bowl" required>
        </div>
        <div class="field">
          <label>Description</label>
          <textarea name="description" placeholder="Describe what makes this piece special...">${productForm.description}</textarea>
        </div>
      </div>

      <div class="card">
        <div class="card-title"><div class="ic"><i data-lucide="tag" style="width:18px;height:18px;"></i></div><h2>Pricing</h2></div>
        <div class="field">
          <label>Price (USD)</label>
          <div class="price-input-wrap">
            <span>$</span>
            <input type="number" step="0.01" min="0.01" name="price" value="${productForm.price}" placeholder="0.00" required>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-title"><div class="ic"><i data-lucide="boxes" style="width:18px;height:18px;"></i></div><h2>Inventory</h2></div>
        <div class="field">
          <label>Quantity in Stock</label>
          <input type="number" step="1" min="0" name="quantity" value="${productForm.quantity}" placeholder="0" required>
        </div>
      </div>

      <div class="card">
        <div class="card-title"><div class="ic"><i data-lucide="image-plus" style="width:18px;height:18px;"></i></div><h2>Image</h2></div>
        <label class="dropzone" id="dropzone" for="file-input">
          <i data-lucide="upload-cloud" style="width:34px;height:34px;"></i>
          <div class="dz-title">Drag & drop a photo, or click to browse</div>
          <div class="dz-sub">PNG or JPG, up to 25MB</div>
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
        <button type="submit" class="btn btn-primary"><i data-lucide="check" style="width:16px;height:16px;"></i> Publish Product</button>
      </div>
    </form>
  </div>

<script>
  try { if (window.lucide) { lucide.createIcons(); } } catch (e) { console.warn("Icon rendering failed:", e); }

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
