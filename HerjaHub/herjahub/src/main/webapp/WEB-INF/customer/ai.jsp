<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Gift Assistant — HerjaHub</title>
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
                    borderRadius: { DEFAULT: '1.5rem' },
                },
            },
        };
    </script>
    <style>
        :root{ --sidebar-w:250px; --topbar-h:68px; --ease:cubic-bezier(.4,0,.2,1); }
        html,body{ height:100%; }
        body{ margin:0; }

        /* ===== Reusable app shell - same system as the Products page ===== */
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
        .side-link.active{
            background:linear-gradient(90deg, rgba(206,17,38,0.1), rgba(0,122,61,0.1));
            box-shadow:inset 0 0 0 1px rgba(0,122,61,0.15);
        }
        .side-link.active svg{ opacity:1; color:#007A3D; }
        .side-link.active::before{
            content:""; position:absolute; left:-16px; top:8px; bottom:8px; width:4px; border-radius:4px;
            background:linear-gradient(180deg, #CE1126, #007A3D);
        }
        .sidebar-footer{ margin-top:auto; padding-top:14px; border-top:1px solid #E9ECEF; }

        .main-area{ margin-left:var(--sidebar-w); min-height:100%; display:flex; flex-direction:column; position:relative; z-index:1; }

        .topbar{
            position:sticky; top:0; z-index:20; height:var(--topbar-h);
            display:flex; align-items:center; justify-content:space-between; gap:16px; padding:0 28px;
            background:rgba(255,255,255,0.65); backdrop-filter:blur(18px); -webkit-backdrop-filter:blur(18px);
            border-bottom:1px solid rgba(255,255,255,0.5);
        }
        .topbar-title{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; }
        .user-chip{ display:flex; align-items:center; gap:10px; padding:6px 14px 6px 6px; border-radius:999px; background:#fff; border:1px solid #E9ECEF; }
        .user-avatar{
            width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center;
            background:linear-gradient(135deg, #CE1126, #007A3D); color:#fff; font-weight:700; font-size:13px; flex-shrink:0;
        }
        .logout-btn{ display:flex; align-items:center; gap:6px; padding:9px 14px; border-radius:999px; background:#fff; border:1px solid #E9ECEF; font-size:13px; font-weight:600; color:#6B7280; transition:all .2s var(--ease); text-decoration:none; }
        .logout-btn:hover{ color:#CE1126; border-color:#CE1126; }

        /* ===== Real keffiyeh pattern, corner-anchored, faded - identical treatment to the Products page ===== */
        .keffiyeh-corner-bg{
            position:fixed; inset:0; z-index:0; pointer-events:none;
            background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
            background-repeat:no-repeat;
            background-position:bottom right;
            background-size:min(70vw, 900px);
            opacity:0.07;
            -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
            mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
        }

        @keyframes fadeInUp{ from{opacity:0; transform:translateY(10px);} to{opacity:1; transform:translateY(0);} }

        /* ===== Hero band - color flare lives on the right edge and fades to the
             page's own neutral color toward the center/left. A white buffer stop
             sits between the red and green so they never blend directly into each
             other - straight red-to-green interpolation in CSS produces a muddy
             gray/brown, since the two colors are near-opposite in RGB space. ===== */
        .hero{
            position:relative; overflow:hidden; border-radius:24px;
            padding:36px 40px 44px; margin-bottom:24px;
            background:#FFFFFF; border:1px solid #E9ECEF;
            box-shadow:0 18px 40px -16px rgba(31,41,55,0.14);
            animation:fadeInUp .5s var(--ease);
        }
        .hero::before{
            /* the vivid flare: solid at the right edge, fades to transparent by ~62% across */
            content:""; position:absolute; inset:0; z-index:0;
            background: linear-gradient(to left,
                #CE1126 0%,
                #CE1126 6%,
                #e0596b 14%,
                #c87777 27%,
                #2f9160 38%,
                #007A3D 48%,
                rgba(0,122,61,0) 62%
            );
        }
        .hero::after{
            /* the real pattern, confined to the same flare region via a matching mask
               so it never washes over the readable text area on the left */
            content:""; position:absolute; inset:0; z-index:1;
            background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
            background-repeat:no-repeat; background-position:right center; background-size:460px;
            opacity:0.16; mix-blend-mode:multiply;
            -webkit-mask-image:linear-gradient(to left, black 0%, black 40%, transparent 65%);
            mask-image:linear-gradient(to left, black 0%, black 40%, transparent 65%);
        }
        .hero-icon{
            position:absolute; z-index:2; top:50%; right:38px; transform:translateY(-50%);
            width:64px; height:64px; border-radius:20px;
            background:rgba(255,255,255,0.22); backdrop-filter:blur(6px);
            border:1px solid rgba(255,255,255,0.4);
            display:flex; align-items:center; justify-content:center; color:#fff;
        }
        .hero-content{ position:relative; z-index:2; max-width:560px; }
        .hero-eyebrow{ color:#007A3D; font-weight:700; font-size:12px; letter-spacing:.08em; text-transform:uppercase; margin:0 0 6px; }
        .hero h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:28px; color:#1F2937; margin:0; }
        .hero p{ color:#6B7280; margin:6px 0 0; font-size:13.5px; }

        .messages-scroll::-webkit-scrollbar { width: 4px; }
        .messages-scroll::-webkit-scrollbar-thumb { background: rgba(31,41,55,0.15); border-radius: 4px; }

        @media (max-width: 900px){
            .sidebar{ transform:translateX(-100%); }
            .main-area{ margin-left:0; }
        }
    </style>
</head>
<body class="bg-background text-foreground font-sans">

<%-- ===== Real keffiyeh pattern, fading in from the bottom-right corner, behind everything ===== --%>
<div class="keffiyeh-corner-bg"></div>

<%-- ===================== SIDEBAR (reusable shell) ===================== --%>
<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
        <div class="mark">ه</div>
        <div class="name">HerjaHub</div>
    </a>

    <div class="side-label">Shop</div>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/dashboard">
        <i data-lucide="layout-dashboard" width="18" height="18"></i> Dashboard
    </a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/products">
        <i data-lucide="shopping-bag" width="18" height="18"></i> Products
    </a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/stores">
        <i data-lucide="store" width="18" height="18"></i> Stores
    </a>
    <a class="side-link active" href="${pageContext.request.contextPath}/customer/ai">
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

    <%-- ===================== TOPBAR (reusable shell) ===================== --%>
    <div class="topbar">
        <div class="topbar-title">AI Assistant</div>
        <div class="flex items-center gap-3">
            <div class="user-chip">
                <div class="user-avatar">A</div>
            </div>
            <a class="logout-btn" href="${pageContext.request.contextPath}/logout">
                <i data-lucide="log-out" width="14" height="14"></i> Log out
            </a>
        </div>
    </div>

    <div class="w-full px-7 py-6">

        <%-- ===== Hero ===== --%>
        <div class="hero">
            <div class="hero-icon">
                <i data-lucide="sparkles" width="30" height="30"></i>
            </div>
            <div class="hero-content">
                <p class="hero-eyebrow">Gift Assistant</p>
                <h1>Find the Perfect Palestinian Craft</h1>
                <p>Tell the assistant who it's for, and it'll recommend products from our artisans.</p>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

            <%-- Chat Panel --%>
            <div class="lg:col-span-2 flex flex-col bg-card rounded-[28px] border border-border overflow-hidden shadow-sm">
                <%-- Chat Header --%>
                <div class="p-6 border-b border-border flex items-center gap-3">
                    <div class="w-12 h-12 rounded-full flex items-center justify-center text-white" style="background:linear-gradient(135deg,#CE1126,#007A3D);">
                        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>
                    </div>
                    <div>
                        <h2 class="font-semibold font-display">HerjaHub AI Assistant</h2>
                        <p class="text-xs text-muted-foreground">Always here to help</p>
                    </div>
                </div>

                <%-- Messages --%>
                <div class="flex-1 overflow-y-auto p-6 space-y-6 messages-scroll" id="messages" style="min-height:380px;">
                    <div class="flex justify-start">
                        <div class="max-w-xs lg:max-w-md px-6 py-4 rounded-[28px] bg-secondary text-foreground rounded-bl-none">
                            <p class="text-sm leading-relaxed">Hello! I'm HerjaHub's AI assistant. I'm here to help you discover authentic Palestinian crafts. What are you looking for today?</p>
                        </div>
                    </div>
                </div>

                <%-- Input --%>
                <div class="border-t border-border p-6">
                    <form class="flex gap-3" id="chatForm">
                        <input class="chat-input flex-1 px-4 py-3 rounded-full border border-border bg-secondary focus:bg-card focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all" id="messageInput" type="text" placeholder="Ask me anything about Palestinian crafts..." autocomplete="off" required>
                        <button type="submit" class="send-button w-12 h-12 rounded-full bg-primary text-primary-foreground flex items-center justify-center hover:shadow-lg hover:-translate-y-0.5 active:scale-95 transition-all flex-shrink-0" id="sendButton">
                            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
                        </button>
                    </form>
                </div>
            </div>

            <%-- Recommendations Sidebar --%>
            <div class="lg:col-span-1">
                <div class="bg-card rounded-[28px] border border-border p-6 sticky top-24 shadow-sm" id="recommendationsSection" hidden>
                    <h3 class="font-semibold mb-6 flex items-center gap-2 font-display">
                        <svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9.66 3.1a1 1 0 011.68 0l1.38 2.32a1 1 0 00.84.48h2.68a1 1 0 01.63 1.78l-2.16 1.57a1 1 0 00-.36 1.12l.83 2.55a1 1 0 01-1.54 1.12L11.5 12.46a1 1 0 00-1 0l-2.16 1.58a1 1 0 01-1.54-1.12l.83-2.55a1 1 0 00-.36-1.12L5.11 8.68a1 1 0 01.63-1.78h2.68a1 1 0 00.84-.48z"/></svg>
                        AI Recommendations
                    </h3>
                    <div class="space-y-4" id="productGrid"></div>
                    <a href="${pageContext.request.contextPath}/customer/products" class="block w-full mt-6 py-3 bg-primary text-primary-foreground rounded-full font-semibold hover:shadow-lg hover:-translate-y-0.5 transition-all text-center">View All</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>lucide.createIcons();</script>

<script>
    const contextPath = "${pageContext.request.contextPath}";
    const chatForm = document.getElementById("chatForm");
    const messageInput = document.getElementById("messageInput");
    const messages = document.getElementById("messages");
    const sendButton = document.getElementById("sendButton");
    const recommendationsSection = document.getElementById("recommendationsSection");
    const productGrid = document.getElementById("productGrid");

    chatForm.addEventListener("submit", async function(event) {
        event.preventDefault();
        const message = messageInput.value.trim();
        if (message === "") return;

        addMessage(message, "user");
        messageInput.value = "";
        sendButton.disabled = true;
        sendButton.innerHTML = '<svg class="w-5 h-5 animate-spin" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-dashoffset="10"/></svg>';

        try {
            const response = await fetch(contextPath + "/api/ai/chat", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ message: message })
            });
            if (response.status === 401) { window.location.href = contextPath + "/auth"; return; }
            const data = await response.json();
            if (!response.ok) { addMessage(data.reply || "Something went wrong.", "error"); return; }
            addMessage(data.reply, "assistant");
            showRecommendations(data.recommendations || []);
        } catch (error) {
            addMessage("The server could not be reached. Please try again.", "error");
        } finally {
            sendButton.disabled = false;
            sendButton.innerHTML = '<svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>';
            messageInput.focus();
        }
    });

    function addMessage(text, type) {
        const row = document.createElement("div");
        row.className = "flex " + (type === "user" ? "justify-end" : "justify-start");
        const bubble = document.createElement("div");
        bubble.className = "max-w-xs lg:max-w-md px-6 py-4 rounded-[28px] text-sm leading-relaxed";
        if (type === "user") {
            bubble.classList.add("bg-primary", "text-primary-foreground", "rounded-br-none");
        } else if (type === "error") {
            bubble.classList.add("bg-red-50", "text-destructive", "rounded-bl-none");
        } else {
            bubble.classList.add("bg-secondary", "text-foreground", "rounded-bl-none");
        }
        bubble.textContent = text;
        row.appendChild(bubble);
        messages.appendChild(row);
        messages.scrollTop = messages.scrollHeight;
    }

    function showRecommendations(products) {
        productGrid.replaceChildren();
        if (products.length === 0) { recommendationsSection.hidden = true; return; }
        products.forEach(function(product) {
            const card = document.createElement("div");
            card.className = "p-4 rounded-2xl bg-secondary hover:bg-secondary/80 cursor-pointer transition-all group";
            const top = document.createElement("div");
            top.className = "flex items-start gap-3 mb-3";
            const icon = document.createElement("div");
            icon.className = "w-12 h-12 rounded-lg bg-primary/20 flex items-center justify-center flex-shrink-0";
            icon.innerHTML = '<svg class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>';
            const info = document.createElement("div");
            info.className = "flex-1 min-w-0";
            const name = document.createElement("h4");
            name.className = "font-semibold text-sm group-hover:text-primary transition-colors truncate";
            name.textContent = product.productName || "Unnamed Product";
            const cat = document.createElement("p");
            cat.className = "text-xs text-muted-foreground";
            cat.textContent = product.description ? product.description.substring(0, 40) + "..." : "No description";
            info.appendChild(name); info.appendChild(cat);
            top.appendChild(icon); top.appendChild(info);
            card.appendChild(top);
            const bottom = document.createElement("div");
            bottom.className = "flex items-center justify-between";
            const price = document.createElement("span");
            price.className = "font-semibold text-primary text-sm";
            price.textContent = product.price + " \u20AA";
            const arrow = document.createElement("button");
            arrow.className = "text-primary hover:text-primary/80 transition-colors";
            arrow.textContent = "\u2192";
            bottom.appendChild(price); bottom.appendChild(arrow);
            card.appendChild(bottom);
            productGrid.appendChild(card);
        });
        recommendationsSection.hidden = false;
    }
</script>

</body>
</html>
