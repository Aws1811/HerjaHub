<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Store Dashboard — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root{ --forest-dark:#123524; --forest:#1f5c3a; --leaf:#7ac74f; --cream:#f6f5ef; --white:#ffffff; --charcoal:#1b2420; --muted:#6f7a71; --border:rgba(18,53,36,0.1); }
  *{box-sizing:border-box;}
  body{ margin:0; font-family:'Inter',sans-serif; background:var(--cream); color:var(--charcoal); }
  .topbar{ display:flex; align-items:center; justify-content:space-between; padding:20px 32px; background:var(--forest-dark); }
  .brand{ display:flex; align-items:center; gap:10px; font-family:'Poppins',sans-serif; font-weight:800; font-size:18px; text-transform:uppercase; letter-spacing:0.03em; color:var(--leaf); }
  .logo-mark{ width:32px; height:32px; border-radius:50%; background:var(--leaf); color:var(--forest-dark); display:flex; align-items:center; justify-content:center; font-family:'Poppins',serif; font-weight:800; }
  .logout-link{ color:#dfe8df; text-decoration:none; font-weight:700; font-size:12px; text-transform:uppercase; letter-spacing:0.03em; padding:9px 18px; border:1px solid rgba(255,255,255,0.25); }
  .logout-link:hover{ background:rgba(255,255,255,0.1); }
  .content{ max-width:960px; margin:0 auto; padding:48px 24px; }
  .welcome-card{ background:var(--white); border:1px solid var(--border); padding:32px; }
  .welcome-card h1{ font-family:'Poppins',sans-serif; font-weight:800; text-transform:uppercase; margin:0 0 8px; font-size:24px; color:var(--forest-dark); letter-spacing:0.01em; }
  .welcome-card p{ color:var(--muted); margin:0; }

  .quick-links{ display:flex; gap:12px; margin:24px 0; }
  .quick-links a{ background:var(--white); border:1px solid var(--border); padding:10px 22px; font-family:'Poppins',sans-serif; font-weight:700; text-transform:uppercase; letter-spacing:0.03em; font-size:12px; color:var(--charcoal); text-decoration:none; }
  .quick-links a:hover{ background:var(--leaf); color:var(--forest-dark); border-color:var(--leaf); }

  .section-card{ background:var(--white); border:1px solid var(--border); padding:28px 30px; margin-bottom:24px; }
  .section-card h2{ font-family:'Poppins',sans-serif; font-weight:700; text-transform:uppercase; letter-spacing:0.03em; font-size:15px; color:var(--forest-dark); margin:0 0 16px; }

  table{ width:100%; border-collapse:collapse; }
  th{ text-align:left; font-size:11px; text-transform:uppercase; letter-spacing:0.04em; color:var(--muted); font-weight:700; padding:8px 10px; border-bottom:1px solid var(--border); }
  td{ padding:12px 10px; border-bottom:1px solid var(--border); font-size:14px; }
  tr:last-child td{ border-bottom:none; }
  td a{ color:var(--forest); font-weight:700; text-decoration:none; text-transform:uppercase; font-size:12px; }
  td a:hover{ color:var(--leaf); }
  .empty-note{ color:var(--muted); font-size:14px; }
</style>
</head>
<body>
  <div class="topbar">
    <div class="brand"><div class="logo-mark">ه</div> HerjaHub</div>
    <a class="logout-link" href="${pageContext.request.contextPath}/logout">Log out</a>
  </div>
  <div class="content">
    <div class="welcome-card">
      <h1 class="font-display">Welcome, ${store.storeName}!</h1>
      <p>You're logged in as a store owner (${store.firstName} ${store.lastName}). Manage your products from here.</p>
    </div>

    <div class="quick-links">
        <%-- Note: no dedicated "list my products" page exists yet - the table
             below on this same dashboard covers that for now --%>
        <a href="${pageContext.request.contextPath}/store/products/add">Add Product</a>

        <%-- Editing the store profile now goes to the real Edit Store page --%>
        <a href="${pageContext.request.contextPath}/store/profile/edit">Store Profile</a>
    </div>

    <%-- ===== My Products ===== --%>
    <div class="section-card">
        <h2>My Products</h2>

        <c:choose>
            <c:when test="${empty products}">
                <p class="empty-note">You haven't added any products yet.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <tr>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Quantity in Stock</th>
                        <th></th>
                    </tr>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td><c:out value="${product.productName}" /></td>
                            <td>$<c:out value="${product.price}" /></td>
                            <td><c:out value="${product.quantity}" /></td>
                            <td><a href="${pageContext.request.contextPath}/store/products/${product.id}">View / Edit</a></td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- ===== Product sales - how many units of each product have sold.
         No new query needed here: Product already has a list of its OrderItems
         (see Product.java), so we just add up the quantity from each one. ===== --%>
    <div class="section-card">
        <h2>Product Sales</h2>

        <c:choose>
            <c:when test="${empty products}">
                <p class="empty-note">No sales data yet.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <tr>
                        <th>Product</th>
                        <th>Units Sold</th>
                    </tr>
                    <c:forEach var="product" items="${products}">
                        <c:set var="unitsSold" value="0" />
                        <c:forEach var="item" items="${product.orderItems}">
                            <c:set var="unitsSold" value="${unitsSold + item.quantity}" />
                        </c:forEach>
                        <tr>
                            <td><c:out value="${product.productName}" /></td>
                            <td><c:out value="${unitsSold}" /></td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
  </div>
</body>
</html>
