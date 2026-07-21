<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HerjaHub — Authentic Palestinian Crafts</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --red:#CE1126; --green:#007A3D; --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF;
    --text-1:#1F2937; --text-2:#6B7280;
    --radius-lg:24px; --radius-md:18px; --radius-sm:12px;
    --shadow-sm:0 4px 16px rgba(31,41,55,0.06); --shadow-md:0 18px 40px -16px rgba(31,41,55,0.18);
    --ease:cubic-bezier(.4,0,.2,1);
  }
  *{box-sizing:border-box;}
  body{
    margin:0; font-family:'Inter',sans-serif; color:var(--text-1); background:var(--neutral-1);
    background-image:
      radial-gradient(700px 480px at -10% -10%, rgba(206,17,38,0.05), transparent 60%),
      radial-gradient(700px 480px at 110% 0%, rgba(0,122,61,0.06), transparent 60%);
    background-attachment:fixed;
  }
  a{ text-decoration:none; color:inherit; }
  @keyframes fadeInUp{ from{opacity:0; transform:translateY(14px);} to{opacity:1; transform:translateY(0);} }

  .keffiyeh-corner-bg{ position:fixed; inset:0; z-index:0; pointer-events:none;
    background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
    background-repeat:no-repeat; background-position:bottom right; background-size:min(70vw, 900px); opacity:0.06;
    -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
    mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%); }

  /* ===== Top nav ===== */
  .topbar{
    display:flex; align-items:center; gap:8px; max-width:1160px; margin:20px auto 0; padding:12px 20px;
    background:rgba(255,255,255,0.72); backdrop-filter:blur(16px); -webkit-backdrop-filter:blur(16px);
    border:1px solid rgba(255,255,255,0.5); border-radius:999px; box-shadow:var(--shadow-sm);
    position:relative; z-index:2;
  }
  .brand{ display:inline-flex; align-items:center; gap:9px; margin-right:auto; padding:4px 10px 4px 4px; }
  .brand-icon{ width:32px; height:32px; border-radius:50%; object-fit:cover; flex-shrink:0; border:1px solid rgba(255,255,255,0.6); }
  .brand-text{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; }
  .brand-text .hub-accent{ background:linear-gradient(90deg, var(--red), var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }
  .login-link{ padding:10px 20px; border-radius:999px; font-weight:700; font-size:13.5px; color:var(--text-1); border:1.5px solid var(--neutral-2); transition:all .2s var(--ease); }
  .login-link:hover{ border-color:var(--green); color:var(--green); }

  /* ===== Hero ===== */
  .hero{ max-width:760px; margin:0 auto; padding:90px 24px 60px; text-align:center; position:relative; z-index:1; animation:fadeInUp .5s var(--ease); }
  .hero-eyebrow{ display:inline-flex; align-items:center; gap:7px; padding:7px 16px; border-radius:999px; background:rgba(0,122,61,0.1); color:var(--green); font-size:12.5px; font-weight:700; margin-bottom:20px; }
  .hero h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:44px; line-height:1.15; margin:0 0 14px; }
  .hero-highlight{ font-family:'Poppins',sans-serif; font-weight:700; font-size:18px; margin:0 0 16px;
    background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }
  .hero p{ color:var(--text-2); font-size:16px; line-height:1.7; max-width:560px; margin:0 auto 34px; }

  .cta-row{ display:flex; flex-direction:column; align-items:center; gap:14px; }
  .btn-start{
    display:inline-flex; align-items:center; gap:10px; padding:17px 40px; border-radius:999px; border:none;
    background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:16px;
    cursor:pointer; transition:all .22s var(--ease); box-shadow:0 18px 34px -14px rgba(0,122,61,0.5);
  }
  .btn-start:hover{ transform:translateY(-3px); box-shadow:0 22px 40px -14px rgba(0,122,61,0.6); }
  .cta-sub{ font-size:13px; color:var(--text-2); }
  .cta-sub a{ font-weight:700; color:var(--green); }
  .cta-sub a:hover{ text-decoration:underline; }

  /* ===== Mission section ===== */
  .team-section{ max-width:1000px; margin:20px auto 90px; padding:0 24px; position:relative; z-index:1; }
  .team-head{ text-align:center; margin-bottom:34px; animation:fadeInUp .5s var(--ease) .05s backwards; }
  .team-head p.eyebrow{ font-size:12.5px; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--text-2); margin:0 0 8px; }
  .team-head h2{ font-family:'Poppins',sans-serif; font-weight:800; font-size:26px; margin:0; }

  .team-grid{ display:grid; grid-template-columns:repeat(3, 1fr); gap:20px; }
  .team-card{
    background:rgba(255,255,255,0.85); backdrop-filter:blur(10px); -webkit-backdrop-filter:blur(10px);
    border:1px solid rgba(255,255,255,0.6); border-radius:var(--radius-lg); padding:28px 24px; text-align:center;
    box-shadow:var(--shadow-sm); transition:all .25s var(--ease); animation:fadeInUp .45s var(--ease) backwards;
  }
  .team-card:hover{ transform:translateY(-6px); box-shadow:var(--shadow-md); }
  .team-avatar{
    width:60px; height:60px; margin:0 auto 16px; border-radius:18px;
    background:linear-gradient(135deg,var(--red),var(--green)); color:#fff;
    display:flex; align-items:center; justify-content:center;
  }
  .team-name{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; margin:0 0 6px; }
  .team-role{ font-size:13px; color:var(--text-2); line-height:1.6; margin:0; }

  /* ===== Footer ===== */
  .footer{ text-align:center; padding:28px 20px 40px; color:var(--text-2); font-size:12.5px; position:relative; z-index:1; }

  /* ===== About Us / team section - distinct card language from the mission cards above ===== */
  .about-section{ max-width:1000px; margin:10px auto 90px; padding:0 24px; position:relative; z-index:1; }
  .about-grid{ display:grid; grid-template-columns:repeat(3, 1fr); gap:20px; }
  .about-card{
    position:relative; overflow:hidden; background:var(--white); border:1px solid var(--neutral-2);
    border-radius:var(--radius-lg); padding:30px 24px 26px; text-align:center;
    box-shadow:var(--shadow-sm); transition:all .25s var(--ease); animation:fadeInUp .45s var(--ease) backwards;
  }
  .about-card::before{ content:""; position:absolute; top:0; left:0; right:0; height:5px; background:linear-gradient(90deg,var(--red),#111,var(--green)); }
  .about-card:hover{ transform:translateY(-6px); box-shadow:var(--shadow-md); }
  .about-index{ position:absolute; top:16px; right:18px; font-family:'Poppins',sans-serif; font-weight:800; font-size:12px; color:var(--neutral-2); }
  .about-avatar{
    width:76px; height:76px; margin:6px auto 16px; border-radius:50%;
    background:linear-gradient(135deg,var(--red),var(--green)); color:#fff;
    font-family:'Poppins',sans-serif; font-weight:800; font-size:26px;
    display:flex; align-items:center; justify-content:center;
    box-shadow:0 10px 22px -10px rgba(0,122,61,0.45);
  }
  .about-name{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16.5px; margin:0 0 8px; }
  .about-role{ display:inline-block; padding:4px 13px; border-radius:999px; background:rgba(0,122,61,0.1); color:var(--green); font-size:11.5px; font-weight:700; margin-bottom:14px; }
  .about-desc{ font-size:13px; color:var(--text-2); line-height:1.6; margin:0; }

  @media (max-width:760px){
    .hero h1{ font-size:32px; }
    .team-grid{ grid-template-columns:1fr; }
    .about-grid{ grid-template-columns:1fr; }
  }
</style>
</head>
<body>

<div class="keffiyeh-corner-bg"></div>

<div class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/">
        <img class="brand-icon" src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="" />
        <span class="brand-text">Herja<span class="hub-accent">Hub</span></span>
    </a>
    <a class="login-link" href="${pageContext.request.contextPath}/auth">Log In</a>
</div>

<div class="hero">
    <div class="hero-eyebrow"><i data-lucide="sparkles" width="14" height="14"></i> Supporting Palestinian artisans</div>
    <h1>Discover Palestinian makers. Support local dreams.</h1>
    <p class="hero-highlight">Handmade products created by artisans and startups across Palestine.</p>
    <p>HerjaHub connects customers directly with Palestinian artisans, handmade businesses, and emerging startups. Every purchase supports independent makers, preserves local craftsmanship, and helps strengthen Palestine's creative economy.</p>

    <div class="cta-row">
        <a class="btn-start" href="${pageContext.request.contextPath}/auth">
            <i data-lucide="arrow-right" width="18" height="18"></i> Explore Local Makers
        </a>
        <p class="cta-sub">Already have an account? <a href="${pageContext.request.contextPath}/auth">Log in</a></p>
    </div>
</div>

<div class="team-section">
    <div class="team-head">
        <p class="eyebrow">Why HerjaHub</p>
        <h2>Our Mission</h2>
    </div>
    <div class="team-grid">
        <div class="team-card" style="animation-delay:0.05s">
            <div class="team-avatar"><i data-lucide="store" width="26" height="26"></i></div>
            <p class="team-name">Support Local Businesses</p>
            <p class="team-role">Help Palestinian artisans and handmade startups reach customers across Palestine and beyond through a modern digital marketplace.</p>
        </div>
        <div class="team-card" style="animation-delay:0.1s">
            <div class="team-avatar"><i data-lucide="palette" width="26" height="26"></i></div>
            <p class="team-name">Preserve Palestinian Craftsmanship</p>
            <p class="team-role">Celebrate traditional handmade products such as embroidery, olive wood, ceramics, jewelry, textiles, and other authentic Palestinian crafts.</p>
        </div>
        <div class="team-card" style="animation-delay:0.15s">
            <div class="team-avatar"><i data-lucide="heart-handshake" width="26" height="26"></i></div>
            <p class="team-name">Empower the Community</p>
            <p class="team-role">Every purchase directly supports real makers, family businesses, and entrepreneurs while encouraging sustainable local economic growth.</p>
        </div>
    </div>
</div>

<div class="about-section">
    <div class="team-head">
        <p class="eyebrow">The Team</p>
        <h2>Who Built HerjaHub</h2>
    </div>
    <div class="about-grid">
        <div class="about-card" style="animation-delay:0.05s">
            <span class="about-index">01</span>
            <div class="about-avatar">A</div>
            <p class="about-name">Aws Sleebi</p>
            <span class="about-role">Customer Experience</span>
            <p class="about-desc">Built the entire customer side of HerjaHub — browsing, product pages, cart, and checkout.</p>
        </div>
        <div class="about-card" style="animation-delay:0.1s">
            <span class="about-index">02</span>
            <div class="about-avatar">H</div>
            <p class="about-name">Hosni Ahmad</p>
            <span class="about-role">Store Owner Tools</span>
            <p class="about-desc">Built everything store owners use to manage their shop, list products, and track sales.</p>
        </div>
        <div class="about-card" style="animation-delay:0.15s">
            <span class="about-index">03</span>
            <div class="about-avatar">A</div>
            <p class="about-name">Abdallah Awad</p>
            <span class="about-role">AI &amp; Platform</span>
            <p class="about-desc">Built the AI shopping assistant, the login system, and this landing page.</p>
        </div>
    </div>
</div>

<div class="footer">
    &copy; <span id="year"></span> HerjaHub. Made with care for Palestinian artisans.
</div>

<script>
  lucide.createIcons();
  document.getElementById('year').textContent = new Date().getFullYear();
</script>

</body>
</html>
