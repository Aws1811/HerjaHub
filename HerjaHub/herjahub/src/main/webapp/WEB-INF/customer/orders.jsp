<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders — HerjaHub</title>
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
                },
            },
        };
    </script>
    <style>
        .keffiyeh-bg { position: fixed; inset: 0; pointer-events: none; z-index: 0;
            background-image: repeating-linear-gradient(45deg,currentColor 0,currentColor 1px,transparent 1px,transparent 14px),
            repeating-linear-gradient(-45deg,currentColor 0,currentColor 1px,transparent 1px,transparent 14px); opacity: 0.05; }
        .tatreez-divider::before,.tatreez-divider::after { content:''; flex:1; height:1px; background-color:#E5E5E2; }
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

<%-- Page Header --%>
<section class="py-12 border-b border-border">
    <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="text-4xl font-serif font-semibold mb-2">My Orders</h1>
        <p class="text-muted-foreground">Track and manage your purchases</p>
    </div>
</section>

<div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-12 relative z-10">

    <c:choose>
        <c:when test="${empty orders}">
            <div class="text-center py-16">
                <div class="w-24 h-24 rounded-full bg-secondary flex items-center justify-center mx-auto mb-6">
                    <svg class="w-12 h-12 text-muted-foreground" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/></svg>
                </div>
                <h2 class="text-2xl font-serif font-semibold mb-2">No orders yet</h2>
                <p class="text-muted-foreground mb-8">Start shopping to see your orders here</p>
                <a href="${pageContext.request.contextPath}/customer/products" class="px-8 py-3 bg-primary text-primary-foreground rounded-full font-semibold hover:shadow-lg hover:-translate-y-0.5 transition-all inline-block">Browse Products</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="space-y-6">
                <c:forEach var="order" items="${orders}">
                    <c:set var="orderTotal" value="0" />
                    <c:forEach var="item" items="${order.orderItems}">
                        <c:set var="orderTotal" value="${orderTotal + (item.price * item.quantity)}" />
                    </c:forEach>

                    <div class="bg-card rounded-[28px] p-6 border border-border hover:shadow-lg transition-all">
                        <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                            <div>
                                <div class="flex items-center gap-3 mb-2">
                                    <h3 class="font-semibold text-lg">Order #<c:out value="${order.id}"/></h3>
                                    <span class="px-3 py-1 rounded-full text-xs font-semibold bg-yellow-100 text-yellow-700">Pending</span>
                                </div>
                                <p class="text-sm text-muted-foreground">Placed on <c:out value="${order.createdAt}"/></p>
                            </div>
                            <div class="flex items-center gap-6">
                                <div class="text-right">
                                    <div class="font-semibold text-primary text-lg">$<c:out value="${orderTotal}"/></div>
                                    <div class="text-sm text-muted-foreground">Total</div>
                                </div>
                                <a href="/customer/orders/${order.id}/confirmation" class="px-6 py-2 border-2 border-primary text-primary rounded-full font-semibold hover:bg-primary/5 transition-all">View</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<div class="tatreez-divider flex items-center justify-center gap-3 my-12"></div>

<%-- Footer --%>
<footer class="bg-card border-t border-border py-12">
    <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 text-center text-muted-foreground text-sm">
        <p>&copy; 2024 HerjaHub. Supporting Palestinian artisans worldwide.</p>
    </div>
</footer>

</body>
</html>
