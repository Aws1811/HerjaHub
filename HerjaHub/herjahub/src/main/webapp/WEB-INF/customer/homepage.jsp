<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products — HerjaHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;1,6..72,500&family=Inter:wght@400;500;600;700&family=Tajawal:wght@400;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        background: '#FAF8F3',
                        foreground: '#1F2937',
                        card: '#FFFFFF',
                        primary: '#198754',
                        'primary-foreground': '#FFFFFF',
                        secondary: '#F8F9FA',
                        muted: '#F1F1EE',
                        'muted-foreground': '#6B7280',
                        border: '#E5E5E2',
                        destructive: '#D72638',
                    },
                    fontFamily: {
                        serif: ['Newsreader', 'serif'],
                        sans: ['Inter', 'sans-serif'],
                        ar: ['Tajawal', 'sans-serif'],
                    },
                    borderRadius: {
                        DEFAULT: '1.75rem',
                    },
                    animation: {
                        'fade-in': 'fadeIn 400ms ease-out',
                        'slide-up': 'slideUp 500ms ease-out',
                    },
                },
            },
        };
    </script>
    <style>
        .keffiyeh-bg {
            position: fixed; inset: 0; pointer-events: none; z-index: 0;
            background-image:
                repeating-linear-gradient(45deg, currentColor 0, currentColor 1px, transparent 1px, transparent 14px),
                repeating-linear-gradient(-45deg, currentColor 0, currentColor 1px, transparent 1px, transparent 14px);
            opacity: 0.05;
        }
        .tatreez-divider::before,
        .tatreez-divider::after {
            content: ''; flex: 1; height: 1px; background-color: #E5E5E2;
        }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .animate-fade-in { animation: fadeIn 400ms ease-out; }
        .animate-slide-up { animation: slideUp 500ms ease-out; }
        .product-card:hover .product-img { transform: scale(1.05); }
        .product-card:hover { box-shadow: 0 20px 40px rgba(0,0,0,0.1); }
        .product-card .wishlist-btn { opacity: 0; transition: opacity 300ms; }
        .product-card:hover .wishlist-btn { opacity: 1; }
    </style>
</head>
<body class="bg-background text-foreground font-sans min-h-screen relative text-[#1F2937]">

<div class="keffiyeh-bg"></div>

<%-- ===== Navbar ===== --%>
<nav class="sticky top-0 z-50 bg-card/80 backdrop-blur-lg border-b border-border">
    <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-16">
        <a href="/home" class="flex items-center gap-3">
            <div class="flex items-center justify-center rounded-lg bg-gradient-to-br from-primary to-primary/80 text-white font-serif font-bold w-7 h-7" style="font-size:1.05rem;">ه</div>
            <div>
                <div class="font-serif font-bold text-lg leading-tight">HerjaHub</div>
                <div class="text-xs text-muted-foreground">Palestinian Crafts</div>
            </div>
        </a>
        <div class="flex items-center gap-4">
            <a href="/cart" class="w-10 h-10 rounded-full bg-secondary hover:bg-primary/10 flex items-center justify-center transition-colors">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
            </a>
            <a href="/profile" class="w-10 h-10 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-semibold">A</a>
        </div>
    </div>
</nav>

<%-- ===== Page Header ===== --%>
<section class="py-12 border-b border-border">
    <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="text-4xl font-serif font-semibold mb-2">All Products</h1>
        <p class="text-muted-foreground">Browse our collection of authentic Palestinian crafts</p>
    </div>
</section>

<%-- ===== Content ===== --%>
<div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-8 grid grid-cols-1 lg:grid-cols-4 gap-8 relative z-10">

    <%-- Sidebar Filters --%>
    <div class="lg:col-span-1">
        <div class="bg-card rounded-[28px] p-6 border border-border sticky top-20">
            <h3 class="font-semibold mb-6 flex items-center gap-2">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
                Filters
            </h3>

            <c:if test="${not empty stores}">
            <%-- Store Filter --%>
            <div class="mb-8">
                <h4 class="font-semibold text-sm mb-4">Store</h4>
                <div class="space-y-3">
                    <c:forEach var="store" items="${stores}">
                        <label class="flex items-center gap-3 cursor-pointer">
                            <input type="checkbox" name="storeId" value="${store.id}" class="w-4 h-4 rounded accent-primary"/>
                            <span class="text-sm"><c:out value="${store.storeName}"/></span>
                        </label>
                    </c:forEach>
                </div>
            </div>
            </c:if>

            <%-- Category Filter --%>
            <div class="mb-8">
                <h4 class="font-semibold text-sm mb-4">Category</h4>
                <div class="space-y-3">
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <span class="text-sm">Embroidery</span>
                    </label>
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <span class="text-sm">Olive Wood</span>
                    </label>
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <span class="text-sm">Pottery</span>
                    </label>
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <span class="text-sm">Jewelry</span>
                    </label>
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <span class="text-sm">Textiles</span>
                    </label>
                </div>
            </div>

            <%-- Price Range --%>
            <div class="mb-8">
                <h4 class="font-semibold text-sm mb-4">Price Range</h4>
                <div class="space-y-3">
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <span class="text-sm">Under $50</span>
                    </label>
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <span class="text-sm">$50 - $100</span>
                    </label>
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <span class="text-sm">$100 - $200</span>
                    </label>
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <span class="text-sm">Over $200</span>
                    </label>
                </div>
            </div>

            <%-- Rating --%>
            <div class="mb-8">
                <h4 class="font-semibold text-sm mb-4">Rating</h4>
                <div class="space-y-3">
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <div class="flex gap-0.5">
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                        </div>
                        <span class="text-sm text-muted-foreground">& up</span>
                    </label>
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <div class="flex gap-0.5">
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 text-border" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                        </div>
                        <span class="text-sm text-muted-foreground">& up</span>
                    </label>
                    <label class="flex items-center gap-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 rounded accent-primary"/>
                        <div class="flex gap-0.5">
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 text-border" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            <svg class="w-3.5 h-3.5 text-border" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                        </div>
                        <span class="text-sm text-muted-foreground">& up</span>
                    </label>
                </div>
            </div>

            <button class="w-full py-2 border border-border rounded-lg text-sm font-semibold hover:bg-secondary transition-colors">Clear Filters</button>
        </div>
    </div>

    <%-- Products Grid --%>
    <div class="lg:col-span-3">
        <%-- Search & Sort --%>
        <div class="flex gap-4 mb-8">
            <div class="flex-1 relative">
                <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                <input type="text" placeholder="Search products..." class="w-full pl-12 pr-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all"/>
            </div>
            <select class="px-4 py-3 rounded-xl border border-border bg-card font-semibold">
                <option>Newest</option>
                <option>Price: Low to High</option>
                <option>Price: High to Low</option>
                <option>Most Popular</option>
            </select>
        </div>

        <c:choose>
            <c:when test="${empty products}">
                <p class="text-muted-foreground text-center py-16">There are no products yet.</p>
            </c:when>
            <c:otherwise>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-12">
                    <c:forEach var="product" items="${products}" varStatus="status">
                        <a href="/products/${product.id}" class="product-card group cursor-pointer animate-slide-up" style="animation-delay: ${status.index % 6 * 50}ms">
                            <div class="relative h-64 rounded-[28px] overflow-hidden shadow-lg mb-4 bg-secondary">
                                <c:choose>
                                    <c:when test="${not empty product.image}">
                                        <img src="${product.image}" alt="${product.productName}" class="product-img w-full h-full object-cover transition-transform duration-300"/>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-full h-full bg-gradient-to-br from-primary/10 to-primary/5 flex items-center justify-center product-img transition-transform duration-300">
                                            <svg class="w-12 h-12 text-primary/30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <button class="wishlist-btn absolute top-4 right-4 w-10 h-10 rounded-full bg-white/90 hover:bg-white flex items-center justify-center shadow-lg transition-all">
                                    <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
                                </button>
                            </div>
                            <h3 class="font-semibold mb-2 group-hover:text-primary transition-colors"><c:out value="${product.productName}"/></h3>
                            <p class="text-sm text-muted-foreground mb-3">By Store</p>
                            <div class="flex items-center justify-between">
                                <span class="font-semibold text-primary text-lg">$<c:out value="${product.price}"/></span>
                                <div class="flex gap-0.5">
                                    <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                    <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                    <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                    <svg class="w-3.5 h-3.5 fill-primary text-primary" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                    <svg class="w-3.5 h-3.5 text-border" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <%-- Pagination --%>
        <div class="flex items-center justify-center gap-4">
            <button class="w-10 h-10 rounded-full border border-border hover:bg-secondary flex items-center justify-center transition-colors">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
            </button>
            <c:forEach var="page" begin="1" end="5">
                <button class="w-10 h-10 rounded-full font-semibold transition-all border border-border hover:bg-secondary">${page}</button>
            </c:forEach>
            <button class="w-10 h-10 rounded-full border border-border hover:bg-secondary flex items-center justify-center transition-colors">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
            </button>
        </div>
    </div>
</div>

<%-- Tatreez Divider --%>
<div class="tatreez-divider flex items-center justify-center gap-3 my-12"></div>

<%-- Footer --%>
<footer class="bg-card border-t border-border py-12">
    <div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 text-center text-muted-foreground text-sm">
        <p>&copy; 2024 HerjaHub. Supporting Palestinian artisans worldwide.</p>
    </div>
</footer>

</body>
</html>
