<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile — HerjaHub</title>
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
        .field-error-input { border-color: #D72638 !important; background-color: #FFF5F5 !important; }
        .field-error { color: #D72638; font-size: 12px; display: block; margin-top: 4px; }
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
            <a href="${pageContext.request.contextPath}/customer/profile/edit" class="w-10 h-10 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-semibold">${editProfileForm.firstName.substring(0,1)}</a>
        </div>
    </div>
</nav>

<div class="w-full max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-12 relative z-10">
    <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">

        <%-- Sidebar --%>
        <div class="lg:col-span-1">
            <div class="bg-card rounded-[28px] p-6 border border-border sticky top-20">
                <nav class="space-y-2">
                    <a href="${pageContext.request.contextPath}/customer/profile/edit" class="w-full flex items-center gap-3 px-4 py-3 rounded-lg bg-primary text-primary-foreground transition-all">
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        <span class="font-semibold">Profile</span>
                    </a>
                    <a href="#" class="w-full flex items-center gap-3 px-4 py-3 rounded-lg text-foreground hover:bg-secondary transition-all">
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="11" width="16" height="9" rx="2"/><path d="M8 11V7a4 4 0 018 0v4"/></svg>
                        <span class="font-semibold">Security</span>
                    </a>
                    <a href="#" class="w-full flex items-center gap-3 px-4 py-3 rounded-lg text-foreground hover:bg-secondary transition-all">
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 01-3.46 0"/></svg>
                        <span class="font-semibold">Notifications</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="w-full flex items-center gap-3 px-4 py-3 rounded-lg text-muted-foreground hover:text-foreground hover:bg-secondary transition-all">
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                        <span class="font-semibold">Log out</span>
                    </a>
                </nav>
            </div>
        </div>

        <%-- Main Content --%>
        <div class="lg:col-span-3">

            <%-- Profile Header --%>
            <div class="bg-card rounded-[28px] p-8 border border-border mb-8">
                <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between mb-8">
                    <div class="flex items-center gap-6 mb-6 sm:mb-0">
                        <div class="w-24 h-24 rounded-full bg-gradient-to-br from-primary to-primary/80 flex items-center justify-center text-white text-3xl font-serif font-bold">${editProfileForm.firstName.substring(0,1)}</div>
                        <div>
                            <h1 class="text-3xl font-serif font-semibold mb-2"><c:out value="${editProfileForm.firstName} ${editProfileForm.lastName}"/></h1>
                            <p class="text-muted-foreground"><c:out value="${editProfileForm.email}"/></p>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Personal Information Form --%>
            <div class="bg-card rounded-[28px] p-8 border border-border mb-8">
                <h2 class="text-2xl font-serif font-semibold mb-8 flex items-center gap-2">
                    <svg class="w-6 h-6 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    Personal Information
                </h2>

                <form:form id="editProfileForm" action="/customer/profile/edit" method="post" modelAttribute="editProfileForm">
                    <div class="space-y-6">
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                            <div>
                                <form:label path="firstName" class="block text-sm font-semibold mb-3">First Name</form:label>
                                <form:input path="firstName" cssClass="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all" cssErrorClass="field-error-input"/>
                                <form:errors path="firstName" cssClass="field-error" element="span"/>
                            </div>
                            <div>
                                <form:label path="lastName" class="block text-sm font-semibold mb-3">Last Name</form:label>
                                <form:input path="lastName" cssClass="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all" cssErrorClass="field-error-input"/>
                                <form:errors path="lastName" cssClass="field-error" element="span"/>
                            </div>
                        </div>

                        <div>
                            <form:label path="email" class="block text-sm font-semibold mb-3 flex items-center gap-2">
                                <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6l9 6 9-6M4 4h16a1 1 0 011 1v14a1 1 0 01-1 1H4a1 1 0 01-1-1V5a1 1 0 011-1z"/></svg>
                                Email Address
                            </form:label>
                            <form:input path="email" cssClass="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all" cssErrorClass="field-error-input"/>
                            <form:errors path="email" cssClass="field-error" element="span"/>
                        </div>

                        <div>
                            <form:label path="newPassword" class="block text-sm font-semibold mb-3 flex items-center gap-2">
                                <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="11" width="16" height="9" rx="2"/><path d="M8 11V7a4 4 0 018 0v4"/></svg>
                                New Password
                            </form:label>
                            <form:password path="newPassword" placeholder="Leave blank to keep current password" cssClass="w-full px-4 py-3 rounded-xl border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all" cssErrorClass="field-error-input"/>
                            <form:errors path="newPassword" cssClass="field-error" element="span"/>
                        </div>

                        <button type="submit" class="w-full sm:w-auto px-8 py-3 bg-primary text-primary-foreground rounded-full font-semibold hover:shadow-lg hover:-translate-y-0.5 active:scale-95 transition-all">Save Changes</button>
                    </div>
                </form:form>
            </div>

            <%-- Security Settings --%>
            <div class="bg-card rounded-[28px] p-8 border border-border mb-8">
                <h2 class="text-2xl font-serif font-semibold mb-8 flex items-center gap-2">
                    <svg class="w-6 h-6 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="11" width="16" height="9" rx="2"/><path d="M8 11V7a4 4 0 018 0v4"/></svg>
                    Security Settings
                </h2>
                <div class="space-y-4">
                    <div class="flex items-center justify-between p-4 rounded-xl border border-border hover:bg-secondary transition-colors cursor-pointer">
                        <div><h4 class="font-semibold mb-1">Password</h4><p class="text-sm text-muted-foreground">Set a new password</p></div>
                        <svg class="w-5 h-5 text-muted-foreground" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
                    </div>
                    <div class="flex items-center justify-between p-4 rounded-xl border border-border hover:bg-secondary transition-colors cursor-pointer">
                        <div><h4 class="font-semibold mb-1">Two-Factor Authentication</h4><p class="text-sm text-muted-foreground">Not enabled</p></div>
                        <svg class="w-5 h-5 text-muted-foreground" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
                    </div>
                </div>
            </div>

            <%-- Notification Preferences --%>
            <div class="bg-card rounded-[28px] p-8 border border-border">
                <h2 class="text-2xl font-serif font-semibold mb-8 flex items-center gap-2">
                    <svg class="w-6 h-6 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 01-3.46 0"/></svg>
                    Notification Preferences
                </h2>
                <div class="space-y-4">
                    <div class="flex items-center justify-between p-4 rounded-xl border border-border hover:bg-secondary transition-colors">
                        <div><h4 class="font-semibold mb-1">Order Updates</h4><p class="text-sm text-muted-foreground">Get notified about your orders</p></div>
                        <input type="checkbox" checked class="w-5 h-5 rounded accent-primary"/>
                    </div>
                    <div class="flex items-center justify-between p-4 rounded-xl border border-border hover:bg-secondary transition-colors">
                        <div><h4 class="font-semibold mb-1">New Products</h4><p class="text-sm text-muted-foreground">Be the first to know about new crafts</p></div>
                        <input type="checkbox" checked class="w-5 h-5 rounded accent-primary"/>
                    </div>
                    <div class="flex items-center justify-between p-4 rounded-xl border border-border hover:bg-secondary transition-colors">
                        <div><h4 class="font-semibold mb-1">Special Offers</h4><p class="text-sm text-muted-foreground">Receive exclusive deals and promotions</p></div>
                        <input type="checkbox" checked class="w-5 h-5 rounded accent-primary"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
