<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Store Dashboard — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;1,6..72,500&family=Inter:wght@400;500;600;700&family=Tajawal:wght@400;500;700&display=swap" rel="stylesheet">
<style>
  :root{ --white:#FFFFFF; --light-gray:#F8F9FA; --charcoal:#1F2937; --green:#198754; --green-dark:#146c43; }
  *{box-sizing:border-box;}
  body{ margin:0; font-family:'Inter',sans-serif; background:var(--light-gray); color:var(--charcoal); }
  .topbar{ display:flex; align-items:center; justify-content:space-between; padding:18px 32px; background:#fff; border-bottom:1px solid rgba(31,41,55,0.08); }
  .brand{ display:flex; align-items:center; gap:10px; font-weight:700; font-size:18px; }
  .logo-mark{ width:32px; height:32px; border-radius:9px; background:linear-gradient(135deg,var(--green),var(--green-dark)); color:#fff; display:flex; align-items:center; justify-content:center; font-family:'Newsreader',serif; font-weight:600; }
  .logout-link{ color:var(--charcoal); text-decoration:none; font-weight:600; font-size:14px; padding:8px 16px; border:1px solid rgba(31,41,55,0.15); border-radius:10px; }
  .logout-link:hover{ background:var(--light-gray); }
  .content{ max-width:960px; margin:0 auto; padding:48px 24px; }
  .welcome-card{ background:#fff; border-radius:20px; padding:32px; box-shadow:0 20px 40px -30px rgba(17,17,17,0.25); }
  .welcome-card h1{ font-family:'Newsreader',serif; font-weight:500; margin:0 0 8px; font-size:28px; }
  .welcome-card p{ color:#6b7280; margin:0; }
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

    <%-- ===== Sidebar-style links, kept plain until real styling is added ===== --%>
    <div>
        <%-- Note: no dedicated "list my products" page exists yet - the table
             below on this same dashboard covers that for now --%>
        <a href="${pageContext.request.contextPath}/store/products/add">Add Product</a>
        &nbsp;|&nbsp;

        <%-- Note: editing the store profile isn't built yet - placeholder link --%>
        <a href="#">Store Profile</a>
    </div>

    <%-- ===== My Products ===== --%>
    <h2>My Products</h2>

    <c:choose>
        <c:when test="${empty products}">
            <p>You haven't added any products yet.</p>
        </c:when>
        <c:otherwise>
            <table border="1">
                <tr>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Quantity in Stock</th>
                </tr>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td><c:out value="${product.productName}" /></td>
                        <td>$<c:out value="${product.price}" /></td>
                        <td><c:out value="${product.quantity}" /></td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>

    <%-- ===== Product sales - how many units of each product have sold.
         No new query needed here: Product already has a list of its OrderItems
         (see Product.java), so we just add up the quantity from each one. ===== --%>
    <h2>Product Sales</h2>

    <c:choose>
        <c:when test="${empty products}">
            <p>No sales data yet.</p>
        </c:when>
        <c:otherwise>
            <table border="1">
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
</body>
</html>
