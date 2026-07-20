<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details — HerjaHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;1,6..72,500&family=Inter:wght@400;500;600;700&family=Tajawal:wght@400;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        background: '#FAF8F3', foreground: '#1F2937', card: '#FFFFFF',
                        primary: '#198754', 'primary-foreground': '#FFFFFF', secondary: '#F8F9FA',
                        muted: '#F1F1EE', 'muted-foreground': '#6B7280', border: '#E5E5E2',
                        destructive: '#D72638',
                    },
                    fontFamily: { serif: ['Newsreader','serif'], sans: ['Inter','sans-serif'], ar: ['Tajawal','sans-serif'] },
                    borderRadius: { DEFAULT: '1.75rem' },
                    animation: { 'fade-in': 'fadeIn 400ms ease-out', 'slide-up': 'slideUp 500ms ease-out' },
                },
            },
        };
    </script>
    <style>
        .keffiyeh-bg { position: fixed; inset: 0; pointer-events: none; z-index: 0;
            background-image: repeating-linear-gradient(45deg,currentColor 0,currentColor 1px,transparent 1px,transparent 14px),
            repeating-linear-gradient(-45deg,currentColor 0,currentColor 1px,transparent 1px,transparent 14px); opacity: 0.05; }
        .tatreez-divider::before,.tatreez-divider::after { content:''; flex:1; height:1px; background-color:#E5E5E2; }
        @keyframes fadeIn { from{opacity:0} to{opacity:1} }
        @keyframes slideUp { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
        .animate-fade-in { animation: fadeIn 400ms ease-out; }
        .animate-slide-up { animation: slideUp 500ms ease-out; }
    </style>
</head>
<body class="bg-background text-foreground font-sans min-h-screen relative text-[#1F2937]">

<div class="keffiyeh-bg"></div>

<%-- Navbar --%>
<nav class="sticky top-0 z-50 bg-card/80 backdrop-blur-lg border-b border-border">
    <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
        <a href="${pageContext.request.contextPath}/customer/dashboard" class="flex items-center gap-3">
            <div class="flex items-center justify-center rounded-lg bg-gradient-to-br from-primary to-primary/80 text-white font-serif font-bold w-7 h-7" style="font-size:1.05rem;">ه</div>
            <div><div class="font-serif font-bold text-lg leading-tight">HerjaHub</div><div class="text-xs text-muted-foreground">Palestinian Crafts</div></div>
        </a>
        <div class="flex items-center gap-4">
            <a href="${pageContext.request.contextPath}/customer/cart" class="w-10 h-10 rounded-full bg-secondary hover:bg-primary/10 flex items-center justify-center transition-colors">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
            </a>
            <a href="${pageContext.request.contextPath}/customer/profile/edit" class="w-10 h-10 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-semibold">A</a>
        </div>
    </div>
</nav>

<%-- Breadcrumb --%>
<div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-6 flex items-center gap-2 text-sm text-muted-foreground">
    <a href="${pageContext.request.contextPath}/customer/dashboard" class="hover:text-primary">Home</a>
    <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
    <a href="${pageContext.request.contextPath}/customer/products" class="hover:text-primary">Products</a>
    <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
    <span class="text-foreground"><c:out value="${product.productName}"/></span>
</div>

<%-- Product Section --%>
<section class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-8 grid grid-cols-1 lg:grid-cols-2 gap-12 relative z-10">

    <%-- Gallery --%>
    <div>
        <div class="relative h-96 lg:h-full rounded-[28px] overflow-hidden shadow-xl mb-4 bg-secondary">
            <c:choose>
                <c:when test="${not empty product.image}">
                    <img src="${product.image}" alt="${product.productName}" class="w-full h-full object-cover"/>
                </c:when>
                <c:otherwise>
                    <div class="w-full h-full bg-gradient-to-br from-primary/10 to-primary/5 flex items-center justify-center">
                        <svg class="w-20 h-20 text-primary/20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%-- Product Info --%>
    <div>
        <div class="mb-6">
            <div class="inline-block px-3 py-1 bg-primary/10 text-primary rounded-full text-sm font-semibold mb-4">In Stock</div>
            <h1 class="text-4xl font-serif font-semibold mb-4"><c:out value="${product.productName}"/></h1>

            <c:if test="${reviewCount > 0}">
            <div class="flex items-center gap-4 mb-6">
                <div class="flex gap-1">
                    <c:forEach begin="1" end="5" varStatus="i">
                        <c:choose>
                            <c:when test="${i.index &lt; (avgRating > 4 ? 5 : (avgRating > 3 ? 4 : (avgRating > 2 ? 3 : (avgRating > 1 ? 2 : 1))))}">
                                <svg class="w-5 h-5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            </c:when>
                            <c:otherwise>
                                <svg class="w-5 h-5 text-border" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <span class="text-muted-foreground">(<c:out value="${reviewCount}"/> reviews)</span>
            </div>
            </c:if>
        </div>

        <div class="mb-8">
            <div class="text-4xl font-serif font-semibold text-primary mb-2">$<c:out value="${product.price}"/></div>
            <p class="text-muted-foreground"><c:out value="${product.description}"/></p>
        </div>

        <%-- Quantity --%>
        <div class="space-y-6 mb-8">
            <div>
                <label class="block text-sm font-semibold mb-3">Quantity</label>
                <div class="flex items-center gap-4">
                    <button type="button" id="qtyDec" class="w-10 h-10 border border-border rounded-lg hover:bg-secondary flex items-center justify-center text-lg">&minus;</button>
                    <span class="text-xl font-semibold" id="qtyVal">1</span>
                    <button type="button" id="qtyInc" class="w-10 h-10 border border-border rounded-lg hover:bg-secondary flex items-center justify-center text-lg">+</button>
                </div>
            </div>
        </div>

        <%-- Add to Cart Form --%>
        <div class="flex gap-4 mb-8">
            <form action="${pageContext.request.contextPath}/customer/cart/add/${product.id}" method="post" class="flex-1 flex gap-4">
                <input type="hidden" name="quantity" id="cartQty" value="1"/>
                <button type="submit" class="flex-1 py-4 bg-primary text-primary-foreground rounded-full font-semibold hover:shadow-lg hover:-translate-y-1 transition-all flex items-center justify-center gap-2">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
                    Add to Cart
                </button>
            </form>
            <button class="w-14 h-14 border-2 border-border rounded-full hover:bg-secondary flex items-center justify-center transition-all">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
            </button>
            <button class="w-14 h-14 border-2 border-border rounded-full hover:bg-secondary flex items-center justify-center transition-all">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>
            </button>
        </div>

        <%-- Shipping Info --%>
        <div class="bg-secondary rounded-2xl p-4 space-y-3 text-sm">
            <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center flex-shrink-0">&check;</div>
                <span>Free shipping on orders over $50</span>
            </div>
            <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center flex-shrink-0">&check;</div>
                <span>30-day money-back guarantee</span>
            </div>
            <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center flex-shrink-0">&check;</div>
                <span>Handmade with authentic Palestinian techniques</span>
            </div>
        </div>
    </div>
</section>

<div class="tatreez-divider flex items-center justify-center gap-3 my-12"></div>

<%-- Reviews --%>
<section class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-16 lg:py-24 relative z-10">
    <h2 class="text-4xl font-serif font-semibold mb-8">Customer Reviews</h2>

    <c:choose>
        <c:when test="${empty comments}">
            <p class="text-muted-foreground">No reviews yet.</p>
        </c:when>
        <c:otherwise>
            <div class="space-y-6">
                <c:forEach var="existingComment" items="${comments}">
                    <div class="bg-card rounded-[28px] p-6 border border-border">
                        <div class="flex items-start justify-between mb-4">
                            <div>
                                <h4 class="font-semibold mb-1"><c:out value="${existingComment.customerName}"/></h4>
                                <c:if test="${not empty existingComment.rating}">
                                <div class="flex gap-0.5">
                                    <c:forEach begin="1" end="5" varStatus="i">
                                        <c:choose>
                                            <c:when test="${i.index &lt;= existingComment.rating}">
                                                <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                            </c:when>
                                            <c:otherwise>
                                                <svg class="w-3.5 h-3.5 text-border" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                </c:if>
                            </div>
                        </div>
                        <p class="text-muted-foreground leading-relaxed"><c:out value="${existingComment.comment}"/></p>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    <c:if test="${not empty errorMessage}">
        <div class="mt-6 p-4 rounded-xl bg-red-50 border border-red-200 text-destructive text-sm"><c:out value="${errorMessage}"/></div>
    </c:if>

    <h3 class="text-2xl font-serif font-semibold mt-12 mb-6">Leave a Review</h3>
    <form:form action="${pageContext.request.contextPath}/customer/products/${product.id}/reviews" method="post" modelAttribute="reviewForm" class="bg-card rounded-[28px] p-8 border border-border">
        <div class="space-y-6">
            <div>
                <form:label path="rating" class="block text-sm font-semibold mb-3">Rating (1-5)</form:label>
                <form:input path="rating" type="number" min="1" max="5" class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
                <form:errors path="rating" cssClass="text-destructive text-sm mt-1 block"/>
            </div>
            <div>
                <form:label path="comment" class="block text-sm font-semibold mb-3">Review</form:label>
                <form:textarea path="comment" rows="4" class="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all resize-none"/>
                <form:errors path="comment" cssClass="text-destructive text-sm mt-1 block"/>
            </div>
            <button type="submit" class="w-full py-3 rounded-full bg-primary text-primary-foreground font-semibold hover:shadow-lg hover:-translate-y-0.5 active:scale-95 transition-all">Post Review</button>
        </div>
    </form:form>
</section>

<div class="tatreez-divider flex items-center justify-center gap-3 my-12"></div>

<%-- Footer --%>
<footer class="bg-card border-t border-border py-12">
    <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 text-center text-muted-foreground text-sm">
        <p>&copy; 2024 HerjaHub. Supporting Palestinian artisans worldwide.</p>
    </div>
</footer>

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
