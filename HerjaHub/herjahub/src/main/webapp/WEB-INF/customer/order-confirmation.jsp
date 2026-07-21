<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation — HerjaHub</title>
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

<div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-12 relative z-10">
    <div class="max-w-lg mx-auto">
        <div class="bg-card rounded-[28px] p-8 border border-border text-center">
            <%-- Success Icon --%>
            <div class="w-20 h-20 rounded-full bg-primary/20 flex items-center justify-center mx-auto mb-6">
                <svg class="w-10 h-10 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 11-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            </div>

            <h1 class="text-3xl font-serif font-semibold mb-2">Order Placed Successfully!</h1>
            <p class="text-muted-foreground mb-8">Thank you for supporting Palestinian artisans.</p>

            <%-- Calculate total --%>
            <c:set var="orderTotal" value="0" />
            <c:forEach var="item" items="${order.orderItems}">
                <c:set var="orderTotal" value="${orderTotal + (item.price * item.quantity)}" />
            </c:forEach>

            <%-- Order Details --%>
            <div class="bg-secondary rounded-xl p-6 mb-8 space-y-3 text-left">
                <div class="flex justify-between">
                    <span class="text-muted-foreground">Order #</span>
                    <span class="font-semibold">#<c:out value="${order.id}"/></span>
                </div>
                <div class="flex justify-between">
                    <span class="text-muted-foreground">Date</span>
                    <span class="font-semibold"><c:out value="${order.createdAt}"/></span>
                </div>
                <div class="border-t border-border pt-3 flex justify-between">
                    <span class="text-muted-foreground">Total</span>
                    <span class="font-semibold text-primary text-lg">$<c:out value="${orderTotal}"/></span>
                </div>
            </div>

            <%-- Actions --%>
            <div class="space-y-3">
                <a href="${pageContext.request.contextPath}/customer/orders" class="block w-full py-4 bg-primary text-primary-foreground rounded-full font-semibold hover:shadow-lg hover:-translate-y-0.5 transition-all">View My Orders</a>
                <a href="${pageContext.request.contextPath}/customer/products" class="block w-full py-4 border-2 border-border text-foreground rounded-full font-semibold hover:bg-secondary transition-all">Continue Shopping</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>
