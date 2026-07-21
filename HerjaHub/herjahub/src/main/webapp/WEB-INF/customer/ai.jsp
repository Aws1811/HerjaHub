<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

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
                },
            },
        };
    </script>
    <style>
        :root{ --red:#CE1126; --green:#007A3D; --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF; --text-1:#1F2937; --text-2:#6B7280; --sidebar-w:250px; --topbar-h:68px; --ease:cubic-bezier(.4,0,.2,1); }
        html,body{ height:100%; }
        body{ margin:0; overflow:hidden; }

        /* ===== Reusable app shell ===== */
        .sidebar{
            position:fixed; top:0; left:0; bottom:0; width:var(--sidebar-w); z-index:30;
            background:rgba(255,255,255,0.7); backdrop-filter:blur(20px); -webkit-backdrop-filter:blur(20px);
            border-right:1px solid rgba(255,255,255,0.6);
            display:flex; flex-direction:column; padding:22px 16px;
        }
        .sidebar-brand{ display:flex; align-items:center; gap:10px; padding:6px 10px 26px; text-decoration:none; color:inherit; }
        .sidebar-brand .mark{
            width:38px; height:38px; border-radius:12px; flex-shrink:0; overflow:hidden;
            background:linear-gradient(135deg, #CE1126, #007A3D);
            display:flex; align-items:center; justify-content:center; color:#fff; font-family:'Poppins',sans-serif; font-weight:800;
        }
        .sidebar-brand .mark img{ width:100%; height:100%; object-fit:cover; }
        .sidebar-brand .name{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; color:#1F2937; }
  .sidebar-brand .name .hub-accent{ background:linear-gradient(90deg, #CE1126, #007A3D); -webkit-background-clip:text; background-clip:text; color:transparent; }
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

        .main-area{ margin-left:var(--sidebar-w); height:100%; display:flex; flex-direction:column; position:relative; z-index:1; }

        .topbar{
            flex-shrink:0; height:var(--topbar-h); z-index:20;
            display:flex; align-items:center; justify-content:space-between; gap:16px; padding:0 28px;
            background:rgba(255,255,255,0.65); backdrop-filter:blur(18px); -webkit-backdrop-filter:blur(18px);
            border-bottom:1px solid rgba(255,255,255,0.5);
        }
        .topbar-title{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; }
        .logout-btn{ display:flex; align-items:center; gap:6px; padding:9px 14px; border-radius:999px; background:#fff; border:1px solid #E9ECEF; font-size:13px; font-weight:600; color:#6B7280; transition:all .2s var(--ease); text-decoration:none; }
        .logout-btn:hover{ color:#CE1126; border-color:#CE1126; }

        /* Real keffiyeh pattern, corner-anchored and faded */
        .keffiyeh-corner-bg{
            position:fixed; inset:0; z-index:0; pointer-events:none;
            background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
            background-repeat:no-repeat; background-position:bottom right; background-size:min(70vw, 900px);
            opacity:0.06;
            -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
            mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
        }

        @keyframes fadeInUp{ from{opacity:0; transform:translateY(14px);} to{opacity:1; transform:translateY(0);} }
        @keyframes popIn{ from{opacity:0; transform:scale(.94) translateY(6px);} to{opacity:1; transform:scale(1) translateY(0);} }

        /* ===================== IMMERSIVE CHAT (unique to this page - no hero band) ===================== */
        .chat-stage{ flex:1; min-height:0; display:flex; flex-direction:column; position:relative; }

        .chat-scroll{ flex:1; min-height:0; overflow-y:auto; padding:0 8%; }
        .chat-scroll::-webkit-scrollbar{ width:5px; }
        .chat-scroll::-webkit-scrollbar-thumb{ background:rgba(31,41,55,0.14); border-radius:4px; }

        /* Centered intro state - the page's signature moment */
        .intro{ max-width:640px; margin:0 auto; padding:56px 20px 30px; text-align:center; animation:fadeInUp .5s var(--ease); }
        .intro-orb{
            width:64px; height:64px; margin:0 auto 18px; border-radius:20px;
            background:linear-gradient(135deg, #CE1126, #007A3D); color:#fff;
            display:flex; align-items:center; justify-content:center;
            box-shadow:0 16px 30px -12px rgba(0,122,61,0.4);
        }
        .intro h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:26px; color:#1F2937; margin:0 0 8px; }
        .intro p{ color:#6B7280; font-size:14px; margin:0 0 26px; }
        .suggest-row{ display:flex; flex-wrap:wrap; gap:9px; justify-content:center; }
        .suggest-chip{
            padding:10px 16px; border-radius:999px; background:#fff; border:1px solid #E9ECEF;
            font-size:13px; font-weight:600; color:#1F2937; cursor:pointer; transition:all .2s var(--ease);
        }
        .suggest-chip:hover{ border-color:#007A3D; background:rgba(0,122,61,0.06); transform:translateY(-1px); }

        /* Message rows - borderless, floating directly on the ambient background */
        .msg-row{ display:flex; margin:0 0 20px; animation:popIn .3s var(--ease) backwards; }
        .msg-row.user{ justify-content:flex-end; }
        .msg-bubble{ max-width:min(560px, 78%); padding:14px 20px; font-size:14px; line-height:1.6; }
        .msg-row.user .msg-bubble{
            background:linear-gradient(135deg, #CE1126, #007A3D); color:#fff;
            border-radius:22px 22px 4px 22px; box-shadow:0 10px 24px -12px rgba(0,122,61,0.35);
        }
        .msg-row.assistant .msg-bubble{
            background:rgba(255,255,255,0.9); backdrop-filter:blur(10px); color:#1F2937;
            border:1px solid rgba(255,255,255,0.7); border-radius:22px 22px 22px 4px; box-shadow:0 4px 16px rgba(31,41,55,0.06);
        }
        .msg-row.error .msg-bubble{ background:#FBEAEA; color:#CE1126; border-radius:22px 22px 22px 4px; }

        /* Horizontal recommendation rail, appears inline in the chat stream */
        .rec-rail-wrap{ margin:4px 0 24px; animation:fadeInUp .35s var(--ease); }
        .rec-rail-label{ font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.06em; color:#6B7280; margin:0 0 10px; display:flex; align-items:center; gap:6px; }
        .rec-rail{ display:flex; gap:12px; overflow-x:auto; padding-bottom:6px; }
        .rec-rail::-webkit-scrollbar{ height:5px; }
        .rec-rail::-webkit-scrollbar-thumb{ background:rgba(31,41,55,0.14); border-radius:4px; }

        /* Sticky glass input bar - the page's other signature element */
        .input-dock{ flex-shrink:0; padding:16px 8% 24px; }
        .input-shell{
            max-width:820px; margin:0 auto; display:flex; align-items:center; gap:10px;
            background:rgba(255,255,255,0.85); backdrop-filter:blur(20px); -webkit-backdrop-filter:blur(20px);
            border:1px solid rgba(255,255,255,0.7); border-radius:999px; padding:8px 8px 8px 22px;
            box-shadow:0 18px 40px -16px rgba(31,41,55,0.2);
        }
        .input-shell input{ flex:1; border:none; outline:none; background:transparent; font-size:14px; color:#1F2937; font-family:'Inter',sans-serif; }
        .input-shell input::placeholder{ color:#9CA3AF; }
        .send-btn{
            width:42px; height:42px; border-radius:50%; border:none; flex-shrink:0; cursor:pointer;
            background:linear-gradient(135deg, #CE1126, #007A3D); color:#fff;
            display:flex; align-items:center; justify-content:center; transition:all .2s var(--ease);
        }
        .send-btn:hover{ transform:scale(1.06); box-shadow:0 8px 18px -6px rgba(0,122,61,0.5); }
        .send-btn:disabled{ opacity:.6; cursor:default; transform:none; }

        @media (max-width: 900px){
            .sidebar{ transform:translateX(-100%); transition:transform .3s ease; }
    .sidebar.open{ transform:translateX(0); }
    .menu-btn{ display:flex; }
    .sidebar-overlay.show{ display:block; }
            .main-area{ margin-left:0; }
            .chat-scroll{ padding:0 5%; }
            .input-dock{ padding:14px 5% 20px; }
        }
    
  .menu-btn{ display:flex; width:40px; height:40px; border-radius:12px; border:1px solid var(--neutral-2); background:var(--white); color:var(--text-1); align-items:center; justify-content:center; cursor:pointer; flex-shrink:0; }
  .sidebar-overlay{ display:none; position:fixed; inset:0; z-index:25; background:rgba(17,17,17,0.35); }

    .topbar-right{ display:flex; align-items:center; gap:12px; }
  .cart-btn{ position:relative; margin-left:auto; width:40px; height:40px; border-radius:50%; background:var(--white); border:1px solid var(--neutral-2); display:flex; align-items:center; justify-content:center; color:var(--text-1); transition:all .2s ease; flex-shrink:0; }
  .user-chip{ display:flex; align-items:center; gap:10px; padding:6px 14px 6px 6px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); }
  .user-avatar{ width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center; background:linear-gradient(135deg, var(--red), var(--green)); color:#fff; font-weight:700; font-size:13px; flex-shrink:0; }
  .u-name{ font-size:13px; font-weight:600; }
  .cart-btn:hover{ border-color:var(--green); color:var(--green); }
  .cart-count{ position:absolute; top:-4px; right:-4px; min-width:17px; height:17px; padding:0 4px; border-radius:999px; background:var(--red); color:#fff; font-size:10px; font-weight:700; display:flex; align-items:center; justify-content:center; }

  /* ===== Sidebar toggle - works at any screen size, higher specificity beats the responsive defaults above ===== */
  .sidebar, .main-area{ transition:transform .28s ease, margin-left .28s ease; }
  body.sidebar-hidden .sidebar{ transform:translateX(-100%); }
  body.sidebar-hidden .main-area{ margin-left:0; }
  body:not(.sidebar-hidden) .sidebar{ transform:translateX(0); }
  @media (min-width:901px){
    body:not(.sidebar-hidden) .main-area{ margin-left:var(--sidebar-w); }
  }
  @media (max-width:900px){
    body:not(.sidebar-hidden) .sidebar-overlay{ display:block; }
  }
</style>
</head>
<body class="bg-background text-foreground font-sans">

<div class="keffiyeh-corner-bg"></div>

<%-- ===================== SIDEBAR ===================== --%>
<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
        <div class="mark"><img src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="HerjaHub" /></div>
        <div class="name">Herja<span class="hub-accent">Hub</span></div>
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

<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="main-area">

    <%-- ===================== TOPBAR ===================== --%>
    <div class="topbar">
        <button class="menu-btn" id="menuBtn" type="button" aria-label="Toggle sidebar"><i data-lucide="menu" width="20" height="20"></i></button>
        <div class="topbar-title">AI Assistant</div>
<div class="topbar-right">
    <a class="cart-btn" href="${pageContext.request.contextPath}/customer/cart" title="View cart"><i data-lucide="shopping-cart" width="18" height="18"></i><c:if test="${not empty sessionScope.cart}"><span class="cart-count">${fn:length(sessionScope.cart)}</span></c:if></a>
        <div class="user-chip">
        <div class="user-avatar"><c:out value="${fn:substring(customer.firstName, 0, 1)}" /></div>
        <span class="u-name"><c:out value="${customer.firstName}" /></span>
    </div>
</div>
    </div>

    <%-- ===================== IMMERSIVE CHAT STAGE ===================== --%>
    <div class="chat-stage">

        <div class="chat-scroll" id="chatScroll">

            <div class="intro">
                <div class="intro-orb"><i data-lucide="sparkles" width="28" height="28"></i></div>
                <h1>Let's find the perfect gift</h1>
                <p>Tell me who it's for, the occasion, or a budget - I'll recommend real products from our artisans.</p>
                <div class="suggest-row">
                    <div class="suggest-chip" data-fill="A wedding gift under $50">A wedding gift under $50</div>
                    <div class="suggest-chip" data-fill="Something made with olive wood">Something with olive wood</div>
                    <div class="suggest-chip" data-fill="A gift for my mother">A gift for my mother</div>
                    <div class="suggest-chip" data-fill="Traditional embroidery">Traditional embroidery</div>
                </div>
            </div>

            <div id="messages">
                <div class="msg-row assistant">
                    <div class="msg-bubble">Hello! I'm HerjaHub's AI assistant. I'm here to help you discover authentic Palestinian crafts. What are you looking for today?</div>
                </div>
            </div>

            <%-- Recommendations rail - shown/hidden by the same JS as before, now styled as a horizontal rail --%>
            <div class="rec-rail-wrap" id="recommendationsSection" hidden>
                <p class="rec-rail-label"><i data-lucide="sparkles" width="13" height="13"></i> Recommended for you</p>
                <div class="rec-rail" id="productGrid"></div>
            </div>

        </div>

        <%-- ===== Sticky glass input dock ===== --%>
        <div class="input-dock">
            <form class="input-shell" id="chatForm">
                <input id="messageInput" type="text" placeholder="Ask me anything about Palestinian crafts..." autocomplete="off" required>
                <button type="submit" class="send-btn" id="sendButton">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
                </button>
            </form>
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
    const chatScroll = document.getElementById("chatScroll");

    /* suggestion chips just fill the input - a click still requires the person to hit send */
    document.querySelectorAll(".suggest-chip").forEach(function(chip){
        chip.addEventListener("click", function(){
            messageInput.value = chip.getAttribute("data-fill");
            messageInput.focus();
        });
    });

    chatForm.addEventListener("submit", async function(event) {
        event.preventDefault();
        const message = messageInput.value.trim();
        if (message === "") return;

        addMessage(message, "user");
        messageInput.value = "";
        sendButton.disabled = true;
        sendButton.innerHTML = '<svg class="animate-spin" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-dashoffset="10"/></svg>';

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
            sendButton.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>';
            messageInput.focus();
        }
    });

    function addMessage(text, type) {
        const row = document.createElement("div");
        row.className = "msg-row " + type;
        const bubble = document.createElement("div");
        bubble.className = "msg-bubble";
        bubble.textContent = text;
        row.appendChild(bubble);
        messages.appendChild(row);
        chatScroll.scrollTop = chatScroll.scrollHeight;
    }

    function showRecommendations(products) {
        productGrid.replaceChildren();
        if (products.length === 0) { recommendationsSection.hidden = true; return; }
        products.forEach(function(product) {
            const card = document.createElement("div");
            card.style.cssText = "flex:0 0 220px; background:rgba(255,255,255,0.9); border:1px solid #E9ECEF; border-radius:18px; padding:14px; cursor:pointer; transition:transform .2s ease, box-shadow .2s ease;";
            card.onmouseenter = function(){ card.style.transform = "translateY(-3px)"; card.style.boxShadow = "0 12px 24px -12px rgba(31,41,55,0.2)"; };
            card.onmouseleave = function(){ card.style.transform = "none"; card.style.boxShadow = "none"; };
            if (product.id) {
                card.onclick = function(){ window.location.href = "${pageContext.request.contextPath}/customer/products/" + product.id; };
            }

            const icon = document.createElement("div");
            icon.style.cssText = "width:40px; height:40px; border-radius:10px; background:rgba(0,122,61,0.12); display:flex; align-items:center; justify-content:center; margin-bottom:10px;";
            icon.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#007A3D" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>';

            const name = document.createElement("h4");
            name.style.cssText = "font-weight:700; font-size:13.5px; margin:0 0 4px; color:#1F2937; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;";
            name.textContent = product.productName || "Unnamed Product";

            const desc = document.createElement("p");
            desc.style.cssText = "font-size:12px; color:#6B7280; margin:0 0 10px; min-height:32px;";
            desc.textContent = product.description ? product.description.substring(0, 50) + "..." : "No description";

            const bottom = document.createElement("div");
            bottom.style.cssText = "display:flex; align-items:center; justify-content:space-between;";
            const price = document.createElement("span");
            price.style.cssText = "font-weight:800; font-size:13px; background:linear-gradient(90deg,#CE1126,#007A3D); -webkit-background-clip:text; background-clip:text; color:transparent;";
            price.textContent = "$" + (typeof product.price === "number" ? product.price.toFixed(2) : product.price);
            const arrow = document.createElement("span");
            arrow.style.cssText = "color:#007A3D; font-weight:700;";
            arrow.textContent = "\u2192";
            bottom.appendChild(price); bottom.appendChild(arrow);

            card.appendChild(icon);
            card.appendChild(name);
            card.appendChild(desc);
            card.appendChild(bottom);
            productGrid.appendChild(card);
        });
        recommendationsSection.hidden = false;
        chatScroll.scrollTop = chatScroll.scrollHeight;
    }
</script>


<script>
  (function(){
    var btn = document.getElementById('menuBtn'), overlay = document.getElementById('sidebarOverlay');
    function isMobile(){ return window.matchMedia('(max-width:900px)').matches; }
    if (isMobile()) { document.body.classList.add('sidebar-hidden'); } // start closed on small screens only
    if (btn) btn.addEventListener('click', function(){ document.body.classList.toggle('sidebar-hidden'); });
    if (overlay) overlay.addEventListener('click', function(){ document.body.classList.add('sidebar-hidden'); });
  })();
</script>
</body>
</html>
