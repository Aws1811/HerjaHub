<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} — HerjaHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        background: '#F8F9FA', foreground: '#1F2937', card: '#FFFFFF',
                        primary: '#007A3D', 'primary-foreground': '#FFFFFF', secondary: '#F1F3F4',
                        muted: '#F1F1EE', 'muted-foreground': '#6B7280', border: '#E9ECEF',
                        destructive: '#CE1126',
                    },
                    fontFamily: { display: ['Poppins','sans-serif'], sans: ['Inter','sans-serif'] },
                },
            },
        };
    </script>
    <style>
        :root{ --sidebar-w:250px; --topbar-h:68px; --ease:cubic-bezier(.4,0,.2,1); }
        html,body{ height:100%; }
        body{ margin:0; }

        /* ===== Reusable app shell ===== */
        .sidebar{
            position:fixed; top:0; left:0; bottom:0; width:var(--sidebar-w); z-index:30;
            background:rgba(255,255,255,0.7); backdrop-filter:blur(20px); -webkit-backdrop-filter:blur(20px);
            border-right:1px solid rgba(255,255,255,0.6);
            display:flex; flex-direction:column; padding:22px 16px;
        }
        .sidebar-brand{ display:flex; align-items:center; gap:10px; padding:6px 10px 26px; text-decoration:none; color:inherit; }
        .sidebar-brand .mark{
            width:38px; height:38px; border-radius:12px; flex-shrink:0;
            background:linear-gradient(135deg, #CE1126, #007A3D);
            display:flex; align-items:center; justify-content:center; color:#fff; font-family:'Poppins',sans-serif; font-weight:800;
        }
        .sidebar-brand .name{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; color:#1F2937; }
        .side-label{ font-size:10.5px; font-weight:700; text-transform:uppercase; letter-spacing:.08em; color:#6B7280; padding:14px 12px 8px; }
        .side-link{
            display:flex; align-items:center; gap:12px; padding:11px 12px; border-radius:12px;
            font-weight:600; font-size:14px; color:#1F2937; margin-bottom:3px; transition:all .22s var(--ease);
            position:relative; text-decoration:none;
        }
        .side-link svg{ flex-shrink:0; opacity:.8; }
        .side-link:hover{ background:#E9ECEF; }
        .side-link.active{ background:linear-gradient(90deg, rgba(206,17,38,0.1), rgba(0,122,61,0.1)); box-shadow:inset 0 0 0 1px rgba(0,122,61,0.15); }
        .side-link.active svg{ opacity:1; color:#007A3D; }
        .side-link.active::before{ content:""; position:absolute; left:-16px; top:8px; bottom:8px; width:4px; border-radius:4px; background:linear-gradient(180deg, #CE1126, #007A3D); }
        .sidebar-footer{ margin-top:auto; padding-top:14px; border-top:1px solid #E9ECEF; }

        .main-area{ margin-left:var(--sidebar-w); min-height:100%; position:relative; z-index:1; }

        .topbar{
            position:sticky; top:0; z-index:20; height:var(--topbar-h);
            display:flex; align-items:center; justify-content:space-between; gap:16px; padding:0 28px;
            background:rgba(255,255,255,0.65); backdrop-filter:blur(18px); -webkit-backdrop-filter:blur(18px);
            border-bottom:1px solid rgba(255,255,255,0.5);
        }
        .crumb{ display:flex; align-items:center; gap:6px; font-size:13px; color:#6B7280; }
        .crumb a{ color:#6B7280; text-decoration:none; }
        .crumb a:hover{ color:#007A3D; }
        .crumb .current{ color:#1F2937; font-weight:600; }
        .logout-btn{ display:flex; align-items:center; gap:6px; padding:9px 14px; border-radius:999px; background:#fff; border:1px solid #E9ECEF; font-size:13px; font-weight:600; color:#6B7280; transition:all .2s var(--ease); text-decoration:none; }
        .logout-btn:hover{ color:#CE1126; border-color:#CE1126; }

        .keffiyeh-corner-bg{
            position:fixed; inset:0; z-index:0; pointer-events:none;
            background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
            background-repeat:no-repeat; background-position:bottom right; background-size:min(70vw, 900px);
            opacity:0.06;
            -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
            mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
        }

        @keyframes fadeInUp{ from{opacity:0; transform:translateY(14px);} to{opacity:1; transform:translateY(0);} }

        /* ===================== IMAGE-LED PRODUCT STAGE (unique to this page) ===================== */
        .stage{ padding:32px 40px 60px; }

        .product-layout{ display:grid; grid-template-columns:minmax(0,1fr) minmax(0,1fr); gap:44px; align-items:start; max-width:1160px; margin:0 auto; }

        /* Full-bleed-feeling image with a floating price tag overlapping its corner */
        .gallery{ position:relative; animation:fadeInUp .5s var(--ease); }
        .gallery-frame{
            position:relative; aspect-ratio:1/1; border-radius:28px; overflow:hidden;
            background:#fff; box-shadow:0 24px 50px -20px rgba(31,41,55,0.22);
        }
        .gallery-frame img{ width:100%; height:100%; object-fit:cover; }
        .gallery-frame .placeholder{ width:100%; height:100%; display:flex; align-items:center; justify-content:center; background:linear-gradient(135deg, rgba(0,122,61,0.08), rgba(206,17,38,0.06)); color:#9CA3AF; }
        .price-tag{
            position:absolute; bottom:-22px; right:28px; z-index:5;
            background:linear-gradient(135deg, #CE1126, #007A3D); color:#fff;
            padding:16px 26px; border-radius:20px; box-shadow:0 16px 32px -12px rgba(0,122,61,0.45);
            font-family:'Poppins',sans-serif; font-weight:800; font-size:24px;
        }
        .price-tag .cur{ font-size:13px; opacity:.8; font-weight:600; margin-right:2px; }

        /* Info column */
        .info{ padding-top:6px; animation:fadeInUp .5s var(--ease) .08s backwards; }
        .info .stock-pill{ display:inline-flex; align-items:center; gap:6px; padding:6px 14px; border-radius:999px; background:rgba(0,122,61,0.1); color:#007A3D; font-size:12px; font-weight:700; margin-bottom:16px; }
        .info h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:30px; color:#1F2937; margin:0 0 12px; line-height:1.15; }
        .rating-row{ display:flex; align-items:center; gap:10px; margin-bottom:18px; }
        .stars{ display:flex; gap:2px; color:#007A3D; }
        .stars svg.empty{ color:#E9ECEF; }
        .info .desc{ color:#6B7280; font-size:14.5px; line-height:1.7; margin:0 0 28px; }

        .qty-row{ display:flex; align-items:center; gap:16px; margin-bottom:22px; }
        .qty-row label{ font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:.05em; color:#6B7280; }
        .qty-stepper{ display:flex; align-items:center; gap:14px; background:#fff; border:1px solid #E9ECEF; border-radius:999px; padding:6px; }
        .qty-btn{ width:34px; height:34px; border-radius:50%; border:none; background:#F1F3F4; font-size:16px; font-weight:700; cursor:pointer; display:flex; align-items:center; justify-content:center; transition:background .2s var(--ease); }
        .qty-btn:hover{ background:#E9ECEF; }
        .qty-val{ min-width:18px; text-align:center; font-weight:700; }

        .action-row{ display:flex; gap:12px; margin-bottom:28px; }
        .btn-add{ flex:1; display:flex; align-items:center; justify-content:center; gap:10px; padding:16px; border:none; border-radius:999px; background:linear-gradient(135deg, #CE1126, #007A3D); color:#fff; font-weight:700; font-size:14.5px; cursor:pointer; transition:all .2s var(--ease); box-shadow:0 14px 28px -14px rgba(0,122,61,0.5); }
        .btn-add:hover{ transform:translateY(-2px); box-shadow:0 18px 34px -14px rgba(0,122,61,0.6); }
        .icon-btn{ width:54px; height:54px; border-radius:50%; border:1.5px solid #E9ECEF; background:#fff; display:flex; align-items:center; justify-content:center; cursor:pointer; transition:all .2s var(--ease); color:#1F2937; flex-shrink:0; }
        .icon-btn:hover{ border-color:#CE1126; color:#CE1126; }

        .assurance{ background:#fff; border:1px solid #E9ECEF; border-radius:20px; padding:18px 20px; display:flex; flex-direction:column; gap:12px; }
        .assurance-row{ display:flex; align-items:center; gap:12px; font-size:13.5px; color:#374151; }
        .assurance-row .check{ width:26px; height:26px; border-radius:50%; background:rgba(0,122,61,0.14); color:#007A3D; display:flex; align-items:center; justify-content:center; flex-shrink:0; }

        /* ===================== REVIEWS (own section, distinct rhythm from the hero above) ===================== */
        .reviews-section{ max-width:1160px; margin:70px auto 0; padding:0 0 60px; }
        .reviews-heading{ display:flex; align-items:baseline; gap:12px; margin-bottom:28px; }
        .reviews-heading h2{ font-family:'Poppins',sans-serif; font-weight:800; font-size:24px; color:#1F2937; margin:0; }
        .reviews-heading .count{ color:#6B7280; font-size:14px; }

        .review-card{ background:#fff; border:1px solid #E9ECEF; border-radius:20px; padding:20px 24px; margin-bottom:14px; }
        .review-card .who{ font-weight:700; font-size:14px; color:#1F2937; margin:0 0 4px; }
        .review-card .stars{ margin-bottom:8px; }
        .review-card p.body{ color:#6B7280; font-size:13.5px; line-height:1.6; margin:0; }
        .muted{ color:#6B7280; font-size:13.5px; }

        .review-form-card{ background:#fff; border:1px solid #E9ECEF; border-radius:24px; padding:28px; margin-top:20px; }
        .review-form-card h3{ font-family:'Poppins',sans-serif; font-weight:700; font-size:17px; margin:0 0 18px; color:#1F2937; }
        .field-label{ display:block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.05em; color:#6B7280; margin-bottom:8px; }
        .field-input{ width:100%; padding:12px 16px; border:1px solid #E9ECEF; border-radius:14px; background:#F8F9FA; font-size:14px; font-family:'Inter',sans-serif; }
        .field-input:focus{ outline:none; border-color:#007A3D; background:#fff; box-shadow:0 0 0 3px rgba(0,122,61,0.12); }
        .error-text{ color:#CE1126; font-size:12px; margin-top:5px; display:block; }
        .submit-review{ width:100%; margin-top:18px; padding:14px; border:none; border-radius:999px; background:linear-gradient(135deg, #CE1126, #007A3D); color:#fff; font-weight:700; font-size:14px; cursor:pointer; transition:all .2s var(--ease); }
        .submit-review:hover{ transform:translateY(-1px); box-shadow:0 14px 26px -14px rgba(0,122,61,0.5); }

        @media (max-width: 900px){
            .sidebar{ transform:translateX(-100%); }
            .main-area{ margin-left:0; }
            .product-layout{ grid-template-columns:1fr; }
            .stage{ padding:24px 20px 50px; }
        }
    </style>
</head>
<body class="bg-background text-foreground font-sans">

<div class="keffiyeh-corner-bg"></div>

<%-- ===================== SIDEBAR ===================== --%>
<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
        <div class="mark">ه</div>
        <div class="name">HerjaHub</div>
    </a>

    <div class="side-label">Shop</div>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/dashboard">
        <i data-lucide="layout-dashboard" width="18" height="18"></i> Dashboard
    </a>
    <a class="side-link active" href="${pageContext.request.contextPath}/customer/products">
        <i data-lucide="shopping-bag" width="18" height="18"></i> Products
    </a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/stores">
        <i data-lucide="store" width="18" height="18"></i> Stores
    </a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/ai">
        <i data-lucide="sparkles" width="18" height="18"></i> AI Assistant
    </a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/cart">
        <i data-lucide="shopping-cart" width="18" height="18"></i> Cart
    </a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/orders">
        <i data-lucide="package" width="18" height="18"></i> My Orders
    </a>

    <div class="side-label">Account</div>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/profile/edit">
        <i data-lucide="user" width="18" height="18"></i> Edit Profile
    </a>

    <div class="sidebar-footer">
        <a class="side-link" href="${pageContext.request.contextPath}/logout" style="color:#CE1126;">
            <i data-lucide="log-out" width="18" height="18"></i> Log out
        </a>
    </div>
</aside>

<div class="main-area">

    <%-- ===================== TOPBAR with breadcrumb ===================== --%>
    <div class="topbar">
        <div class="crumb">
            <a href="${pageContext.request.contextPath}/customer/dashboard">Home</a>
            <i data-lucide="chevron-right" width="14" height="14"></i>
            <a href="${pageContext.request.contextPath}/customer/products">Products</a>
            <i data-lucide="chevron-right" width="14" height="14"></i>
            <span class="current"><c:out value="${product.productName}"/></span>
        </div>
<div class="topbar-right">
    <div class="user-chip">
        <div class="user-avatar"><c:out value="${fn:substring(customer.firstName, 0, 1)}" /></div>
        <span class="u-name"><c:out value="${customer.firstName}" /></span>
    </div>
</div>
    </div>

    <div class="stage">

        <%-- ===== Image-led product layout ===== --%>
        <div class="product-layout">

            <div class="gallery">
                <div class="gallery-frame">
                    <c:choose>
                        <c:when test="${not empty product.image}">
                            <img src="${pageContext.request.contextPath}${product.image}" alt="${product.productName}"/>
                        </c:when>
                        <c:otherwise>
                            <div class="placeholder"><i data-lucide="image" width="56" height="56"></i></div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="price-tag"><span class="cur">$</span><c:out value="${product.price}"/></div>
            </div>

            <div class="info">
                <div class="stock-pill"><i data-lucide="check-circle-2" width="13" height="13"></i> In Stock</div>
                <h1><c:out value="${product.productName}"/></h1>

                <c:if test="${reviewCount > 0}">
                <div class="rating-row">
                    <div class="stars">
                        <c:forEach begin="1" end="5" varStatus="i">
                            <c:choose>
                                <c:when test="${i.index <= avgRating}">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                </c:when>
                                <c:otherwise>
                                    <svg class="empty" width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                    <span class="muted">(<c:out value="${reviewCount}"/> reviews)</span>
                </div>
                </c:if>

                <p class="desc"><c:out value="${product.description}"/></p>

                <div class="qty-row">
                    <label>Quantity</label>
                    <div class="qty-stepper">
                        <button type="button" id="qtyDec" class="qty-btn">&minus;</button>
                        <span class="qty-val" id="qtyVal">1</span>
                        <button type="button" id="qtyInc" class="qty-btn">+</button>
                    </div>
                </div>

                <div class="action-row">
                    <form action="${pageContext.request.contextPath}/customer/cart/add/${product.id}" method="post" style="flex:1; display:flex;">
                        <input type="hidden" name="quantity" id="cartQty" value="1"/>
                        <button type="submit" class="btn-add">
                            <i data-lucide="shopping-cart" width="17" height="17"></i> Add to Cart
                        </button>
                    </form>
                    <button type="button" class="icon-btn" title="Save for later">
                        <i data-lucide="heart" width="18" height="18"></i>
                    </button>
                    <button type="button" class="icon-btn" title="Share">
                        <i data-lucide="share-2" width="18" height="18"></i>
                    </button>
                </div>

                <div class="assurance">
                    <div class="assurance-row"><span class="check"><i data-lucide="check" width="14" height="14"></i></span> Free shipping on orders over $50</div>
                    <div class="assurance-row"><span class="check"><i data-lucide="check" width="14" height="14"></i></span> 30-day money-back guarantee</div>
                    <div class="assurance-row"><span class="check"><i data-lucide="check" width="14" height="14"></i></span> Handmade with authentic Palestinian techniques</div>
                </div>
            </div>
        </div>

        <%-- ===== Reviews ===== --%>
        <div class="reviews-section">
            <div class="reviews-heading">
                <h2>Customer Reviews</h2>
                <span class="count"><c:out value="${reviewCount}"/> total</span>
            </div>

            <c:choose>
                <c:when test="${empty comments}">
                    <p class="muted">No reviews yet.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="existingComment" items="${comments}">
                        <div class="review-card">
                            <p class="who"><c:out value="${existingComment.customerName}"/></p>
                            <c:if test="${not empty existingComment.rating}">
                                <div class="stars">
                                    <c:forEach begin="1" end="5" varStatus="i">
                                        <c:choose>
                                            <c:when test="${i.index <= existingComment.rating}">
                                                <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                            </c:when>
                                            <c:otherwise>
                                                <svg class="empty" width="13" height="13" viewBox="0 0 24 24" fill="currentColor"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                            </c:if>
                            <p class="body"><c:out value="${existingComment.comment}"/></p>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            <c:if test="${not empty errorMessage}">
                <div style="margin-top:14px; padding:14px 18px; border-radius:14px; background:#FBEAEA; border:1px solid #F3CACA; color:#CE1126; font-size:13.5px;">
                    <c:out value="${errorMessage}"/>
                </div>
            </c:if>

            <div class="review-form-card">
                <h3>Leave a Review</h3>
                <form:form action="${pageContext.request.contextPath}/customer/products/${product.id}/reviews" method="post" modelAttribute="reviewForm">
                    <form:label path="rating" cssClass="field-label">Rating (1-5)</form:label>
                    <form:input path="rating" type="number" min="1" max="5" cssClass="field-input"/>
                    <form:errors path="rating" cssClass="error-text"/>

                    <div style="height:16px;"></div>

                    <form:label path="comment" cssClass="field-label">Review</form:label>
                    <form:textarea path="comment" rows="4" cssClass="field-input" style="resize:vertical;"/>
                    <form:errors path="comment" cssClass="error-text"/>

                    <button type="submit" class="submit-review">Post Review</button>
                </form:form>
            </div>
        </div>
    </div>
</div>

<script>lucide.createIcons();</script>

<script>
    (function() {
        var qty = 1;
        var qtyVal = document.getElementById('qtyVal');
        var cartQty = document.getElementById('cartQty');
        document.getElementById('qtyDec').addEventListener('click', function() { if (qty > 1) { qty--; qtyVal.textContent = qty; cartQty.value = qty; } });
        document.getElementById('qtyInc').addEventListener('click', function() { qty++; qtyVal.textContent = qty; cartQty.value = qty; });
    })();
</script>

</body>
</html>
