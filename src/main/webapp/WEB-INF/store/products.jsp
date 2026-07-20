<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Products — HerjaHub</title>
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
    --success:#4F7A3D; --success-bg:#EAF2E1; --warn:#B07A1E; --warn-bg:#FBF1DE;
    --radius-lg:20px; --radius-md:14px; --radius-sm:10px;
    --shadow-sm:0 2px 10px rgba(43,41,35,0.05);
    --shadow-md:0 16px 40px -18px rgba(43,41,35,0.22);
  }
  *{box-sizing:border-box;}
  body{ margin:0; font-family:'Inter',sans-serif; background:var(--ivory); color:var(--charcoal); }
  a{ color:inherit; }

  .topbar{ display:flex; align-items:center; justify-content:space-between; padding:16px 32px; background:var(--white); border-bottom:1px solid var(--border); position:sticky; top:0; z-index:20; }
  .brand{ display:flex; align-items:center; gap:10px; font-family:'Newsreader',serif; font-weight:600; font-size:20px; color:var(--olive-dark); }
  .brand .mark{ width:36px; height:36px; border-radius:11px; background:linear-gradient(155deg,var(--olive),var(--olive-dark)); color:var(--gold-light); display:flex; align-items:center; justify-content:center; }

  .shell{ display:flex; max-width:1360px; margin:0 auto; }
  .sidebar{ width:236px; flex-shrink:0; padding:28px 16px; }
  .side-label{ font-size:11px; text-transform:uppercase; letter-spacing:.08em; color:var(--muted); font-weight:700; padding:0 12px 8px; }
  .nav-link{ display:flex; align-items:center; gap:11px; padding:11px 12px; margin-bottom:3px; border-radius:var(--radius-sm); text-decoration:none; font-weight:600; font-size:14px; color:var(--charcoal); }
  .nav-link:hover{ background:var(--olive-light); }
  .nav-link.active{ background:var(--olive); color:var(--white); }
  .nav-link.logout{ color:var(--error); }
  .nav-link.logout:hover{ background:var(--error-bg); }

  .main{ flex:1; min-width:0; padding:28px 32px 56px; }

  .page-header{ display:flex; align-items:center; justify-content:space-between; margin-bottom:20px; flex-wrap:wrap; gap:12px; }
  .page-header h1{ font-family:'Newsreader',serif; font-weight:600; font-size:27px; margin:0; }
  .page-header p{ margin:4px 0 0; color:var(--muted); font-size:14px; }

  .btn{ border:none; border-radius:var(--radius-sm); padding:11px 20px; font-weight:700; font-size:14px; cursor:pointer; font-family:'Inter',sans-serif; display:inline-flex; align-items:center; gap:8px; transition:transform .15s ease, box-shadow .15s ease; }
  .btn-primary{ background:var(--olive); color:#fff; box-shadow:var(--shadow-sm); }
  .btn-primary:hover{ background:var(--olive-dark); transform:translateY(-1px); box-shadow:var(--shadow-md); }
  .btn-ghost{ background:var(--white); color:var(--charcoal); border:1px solid var(--border); }
  .btn-ghost:hover{ background:var(--olive-light); }
  .btn-danger{ background:var(--white); color:var(--error); border:1px solid #f0c9c4; }
  .btn-danger:hover{ background:var(--error-bg); }
  .btn-sm{ padding:7px 13px; font-size:13px; }

  .toolbar{ display:flex; gap:12px; margin-bottom:18px; flex-wrap:wrap; align-items:center; }
  .search-box{ position:relative; flex:1; min-width:220px; }
  .search-box input{ width:100%; padding:11px 14px 11px 40px; border:1px solid var(--border); border-radius:var(--radius-sm); font-size:14px; font-family:'Inter',sans-serif; background:var(--white); }
  .search-box input:focus{ outline:none; border-color:var(--olive); box-shadow:0 0 0 3px var(--olive-light); }
  .search-box svg{ position:absolute; left:13px; top:50%; transform:translateY(-50%); color:var(--muted); }
  select.sort-select{ padding:11px 14px; border:1px solid var(--border); border-radius:var(--radius-sm); font-size:14px; background:var(--white); font-family:'Inter',sans-serif; color:var(--charcoal); }
  .filter-chips{ display:flex; gap:8px; }
  .chip{ padding:8px 14px; border-radius:999px; border:1px solid var(--border); background:var(--white); font-size:13px; font-weight:600; cursor:pointer; color:var(--muted); transition:all .15s ease; }
  .chip.active{ background:var(--olive); color:#fff; border-color:var(--olive); }

  .table-panel{ background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); box-shadow:var(--shadow-sm); overflow:hidden; }
  table{ width:100%; border-collapse:collapse; }
  thead th{ text-align:left; font-size:12px; text-transform:uppercase; letter-spacing:.05em; color:var(--muted); font-weight:700; padding:14px 16px; border-bottom:1px solid var(--border); cursor:pointer; user-select:none; white-space:nowrap; }
  thead th:hover{ color:var(--olive-dark); }
  thead th .sort-arrow{ font-size:10px; margin-left:4px; opacity:.5; }
  tbody tr{ border-bottom:1px solid var(--border); transition:background .12s ease; }
  tbody tr:last-child{ border-bottom:none; }
  tbody tr:hover{ background:var(--ivory); }
  tbody td{ padding:12px 16px; font-size:14px; vertical-align:middle; }
  .prod-cell{ display:flex; align-items:center; gap:12px; }
  .prod-thumb{ width:48px; height:48px; border-radius:10px; background:var(--olive-light) center/contain no-repeat; border:1px solid var(--border); flex-shrink:0; display:flex; align-items:center; justify-content:center; color:var(--sage); }
  .prod-name{ font-weight:700; }
  .prod-desc{ font-size:12px; color:var(--muted); max-width:240px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }

  .badge{ display:inline-flex; align-items:center; gap:5px; padding:5px 11px; border-radius:999px; font-size:12px; font-weight:700; }
  .badge.in-stock{ background:var(--success-bg); color:var(--success); }
  .badge.low-stock{ background:var(--warn-bg); color:var(--warn); }
  .badge.out-of-stock{ background:var(--error-bg); color:var(--error); }

  .row-actions{ display:flex; gap:6px; }
  .icon-action{ width:32px; height:32px; border-radius:9px; border:1px solid var(--border); background:var(--white); display:flex; align-items:center; justify-content:center; cursor:pointer; color:var(--muted); transition:all .15s ease; }
  .icon-action:hover{ background:var(--olive-light); color:var(--olive-dark); }
  .icon-action.danger:hover{ background:var(--error-bg); color:var(--error); border-color:#f0c9c4; }

  .empty-state{ text-align:center; padding:70px 20px; color:var(--muted); }
  .empty-state svg{ color:var(--sage); margin-bottom:14px; }
  .empty-state h3{ font-family:'Newsreader',serif; font-size:20px; color:var(--charcoal); margin:0 0 6px; }

  .skeleton-row td{ padding:14px 16px; }
  .skeleton{ background:linear-gradient(90deg,#EFEBDF 25%,#F6F3E9 37%,#EFEBDF 63%); background-size:400% 100%; animation:shimmer 1.4s ease infinite; border-radius:8px; height:14px; }
  @keyframes shimmer{ 0%{background-position:100% 0;} 100%{background-position:0 0;} }

  .pagination{ display:flex; align-items:center; justify-content:center; gap:6px; padding:18px; }
  .page-btn{ width:34px; height:34px; border-radius:9px; border:1px solid var(--border); background:var(--white); cursor:pointer; font-size:13px; font-weight:700; color:var(--charcoal); }
  .page-btn.active{ background:var(--olive); color:#fff; border-color:var(--olive); }
  .page-btn:disabled{ opacity:.4; cursor:not-allowed; }

  .modal-overlay{ display:none; position:fixed; inset:0; background:rgba(43,41,35,0.45); backdrop-filter:blur(3px); align-items:center; justify-content:center; z-index:60; }
  .modal-overlay.active{ display:flex; }
  .modal{ background:var(--white); border-radius:var(--radius-lg); padding:26px; width:100%; max-width:400px; box-shadow:var(--shadow-md); }
  .modal h3{ font-family:'Newsreader',serif; margin:0 0 8px; font-size:19px; display:flex; align-items:center; gap:10px; color:var(--error); }
  .modal p{ color:var(--muted); font-size:14px; margin:0 0 20px; }
  .modal-actions{ display:flex; gap:10px; justify-content:flex-end; }

  @media (max-width: 760px){
    .shell{ flex-direction:column; }
    .sidebar{ width:100%; padding:14px 16px 0; }
    .main{ padding:20px 16px 40px; }
    .prod-desc{ display:none; }
  }
</style>
</head>
<body>
  <c:set var="mn" value="${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']}"/>
  <div class="topbar">
    <div class="brand"><div class="mark"><i data-lucide="leaf" style="width:19px;height:19px;"></i></div> HerjaHub</div>
  </div>

  <div class="shell">
    <div class="sidebar">
      <div class="side-label">Overview</div>
      <a class="nav-link" href="${pageContext.request.contextPath}/store/dashboard"><i data-lucide="layout-dashboard" style="width:17px;height:17px;"></i> Dashboard</a>
      <div class="side-label" style="margin-top:16px;">Manage</div>
      <a class="nav-link active" href="${pageContext.request.contextPath}/store/products"><i data-lucide="package" style="width:17px;height:17px;"></i> Products</a>
      <a class="nav-link" href="${pageContext.request.contextPath}/store/edit"><i data-lucide="store" style="width:17px;height:17px;"></i> Store Profile</a>
      <div style="margin-top:16px;">
        <a class="nav-link logout" href="${pageContext.request.contextPath}/logout"><i data-lucide="log-out" style="width:17px;height:17px;"></i> Logout</a>
      </div>
    </div>

    <div class="main">
      <div class="page-header">
        <div>
          <h1>Products</h1>
          <p>Manage your catalog — <span id="product-count">${fn:length(products)}</span> item<c:if test="${fn:length(products) != 1}">s</c:if> total.</p>
        </div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/store/products/add"><i data-lucide="plus" style="width:16px;height:16px;"></i> Add Product</a>
      </div>

      <c:if test="${not empty products}">
        <div class="toolbar">
          <div class="search-box">
            <i data-lucide="search" style="width:16px;height:16px;"></i>
            <input type="text" id="search-input" placeholder="Search products by name...">
          </div>
          <div class="filter-chips" id="filter-chips">
            <div class="chip active" data-filter="all">All</div>
            <div class="chip" data-filter="in-stock">In Stock</div>
            <div class="chip" data-filter="low-stock">Low Stock</div>
            <div class="chip" data-filter="out-of-stock">Out of Stock</div>
          </div>
          <select class="sort-select" id="sort-select">
            <option value="created-desc">Newest First</option>
            <option value="created-asc">Oldest First</option>
            <option value="name-asc">Name (A–Z)</option>
            <option value="name-desc">Name (Z–A)</option>
            <option value="price-desc">Price (High–Low)</option>
            <option value="price-asc">Price (Low–High)</option>
          </select>
        </div>
      </c:if>

      <div class="table-panel">
        <c:choose>
          <c:when test="${not empty products}">
            <table id="products-table">
              <thead>
                <tr>
                  <th>Product</th>
                  <th>Price</th>
                  <th>Quantity</th>
                  <th>Units Sold</th>
                  <th>Revenue</th>
                  <th>Created</th>
                  <th>Status</th>
                  <th style="text-align:right;">Actions</th>
                </tr>
              </thead>
              <tbody id="products-tbody">
                <c:forEach var="p" items="${products}">
                  <tr class="product-row"
                      data-name="<c:out value='${p.productName}'/>"
                      data-price="${p.price}"
                      data-created="${p.createdAt}"
                      data-status="<c:choose><c:when test='${p.quantity == 0}'>out-of-stock</c:when><c:when test='${p.quantity lt 5}'>low-stock</c:when><c:otherwise>in-stock</c:otherwise></c:choose>">
                    <td>
                      <div class="prod-cell">
                        <c:choose>
                          <c:when test="${not empty p.image}">
                            <div class="prod-thumb" style="background-image:url('${p.image}')"></div>
                          </c:when>
                          <c:otherwise>
                            <div class="prod-thumb"><i data-lucide="image" style="width:18px;height:18px;"></i></div>
                          </c:otherwise>
                        </c:choose>
                        <div>
                          <div class="prod-name"><c:out value="${p.productName}"/></div>
                          <div class="prod-desc"><c:out value="${p.description}"/></div>
                        </div>
                      </div>
                    </td>
                    <td>$<fmt:formatNumber value="${p.price}" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td>${p.quantity}</td>
                    <td>${p.unitsSold}</td>
                    <td>$<fmt:formatNumber value="${p.revenue}" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td>${mn[p.createdAt.monthValue - 1]} ${p.createdAt.dayOfMonth}, ${p.createdAt.year}</td>
                    <td>
                      <c:choose>
                        <c:when test="${p.quantity == 0}"><span class="badge out-of-stock"><i data-lucide="x-circle" style="width:12px;height:12px;"></i> Out of Stock</span></c:when>
                        <c:when test="${p.quantity lt 5}"><span class="badge low-stock"><i data-lucide="alert-triangle" style="width:12px;height:12px;"></i> Low Stock</span></c:when>
                        <c:otherwise><span class="badge in-stock"><i data-lucide="check-circle" style="width:12px;height:12px;"></i> In Stock</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <div class="row-actions" style="justify-content:flex-end;">
                        <a class="icon-action" href="${pageContext.request.contextPath}/store/products/${p.id}/edit" title="Edit"><i data-lucide="pencil" style="width:15px;height:15px;"></i></a>
                        <div class="icon-action danger" title="Delete" onclick="openDeleteModal(${p.id}, '<c:out value="${p.productName}"/>')"><i data-lucide="trash-2" style="width:15px;height:15px;"></i></div>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
            <div class="pagination" id="pagination"></div>
          </c:when>
          <c:otherwise>
            <div class="empty-state">
              <i data-lucide="package-open" style="width:52px;height:52px;"></i>
              <h3>No products yet</h3>
              <p>Add your first handmade product to start selling on HerjaHub.</p>
              <br>
              <a class="btn btn-primary" href="${pageContext.request.contextPath}/store/products/add"><i data-lucide="plus" style="width:16px;height:16px;"></i> Add Your First Product</a>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <!-- DELETE CONFIRMATION MODAL -->
  <div class="modal-overlay" id="delete-modal-overlay">
    <div class="modal">
      <h3><i data-lucide="alert-triangle" style="width:20px;height:20px;"></i> Delete Product</h3>
      <p>Are you sure you want to delete "<span id="delete-product-name"></span>"? This cannot be undone.</p>
      <form id="delete-form" method="post" action="">
        <div class="modal-actions">
          <button type="button" class="btn btn-ghost" onclick="closeDeleteModal()">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete Product</button>
        </div>
      </form>
    </div>
  </div>

<script>
  try { if (window.lucide) { lucide.createIcons(); } } catch (e) { console.warn("Icon rendering failed:", e); }
  var ctx = "${pageContext.request.contextPath}";

  function openDeleteModal(id, name) {
    document.getElementById('delete-product-name').textContent = name;
    document.getElementById('delete-form').action = ctx + '/store/products/' + id + '/delete';
    document.getElementById('delete-modal-overlay').classList.add('active');
  }
  function closeDeleteModal() {
    document.getElementById('delete-modal-overlay').classList.remove('active');
  }
  document.getElementById('delete-modal-overlay').addEventListener('click', function (e) {
    if (e.target === this) closeDeleteModal();
  });

  // ---------- client-side search / filter / sort / pagination ----------
  (function () {
    var tbody = document.getElementById('products-tbody');
    if (!tbody) return;

    var allRows = Array.prototype.slice.call(tbody.querySelectorAll('.product-row'));
    var searchInput = document.getElementById('search-input');
    var chips = document.querySelectorAll('.chip');
    var sortSelect = document.getElementById('sort-select');
    var pagination = document.getElementById('pagination');
    var pageSize = 8;
    var currentPage = 1;
    var currentFilter = 'all';

    function getFiltered() {
      var term = (searchInput.value || '').toLowerCase().trim();
      return allRows.filter(function (row) {
        var matchesTerm = row.dataset.name.toLowerCase().indexOf(term) !== -1;
        var matchesFilter = currentFilter === 'all' || row.dataset.status === currentFilter;
        return matchesTerm && matchesFilter;
      });
    }

    function getSorted(rows) {
      var mode = sortSelect.value;
      var sorted = rows.slice();
      sorted.sort(function (a, b) {
        switch (mode) {
          case 'name-asc': return a.dataset.name.localeCompare(b.dataset.name);
          case 'name-desc': return b.dataset.name.localeCompare(a.dataset.name);
          case 'price-asc': return parseFloat(a.dataset.price) - parseFloat(b.dataset.price);
          case 'price-desc': return parseFloat(b.dataset.price) - parseFloat(a.dataset.price);
          case 'created-asc': return a.dataset.created.localeCompare(b.dataset.created);
          default: return b.dataset.created.localeCompare(a.dataset.created);
        }
      });
      return sorted;
    }

    function render() {
      allRows.forEach(function (r) { r.style.display = 'none'; });
      var rows = getSorted(getFiltered());
      var totalPages = Math.max(1, Math.ceil(rows.length / pageSize));
      if (currentPage > totalPages) currentPage = totalPages;

      var start = (currentPage - 1) * pageSize;
      var pageRows = rows.slice(start, start + pageSize);
      pageRows.forEach(function (r) {
        r.style.display = '';
        tbody.appendChild(r); // re-order into place
      });

      document.getElementById('product-count').textContent = rows.length;

      pagination.innerHTML = '';
      if (totalPages > 1) {
        for (var i = 1; i <= totalPages; i++) {
          var btn = document.createElement('button');
          btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
          btn.textContent = i;
          btn.addEventListener('click', (function (page) {
            return function () { currentPage = page; render(); };
          })(i));
          pagination.appendChild(btn);
        }
      }
    }

    

    render();
  })();
</script>
</body>
</html>
