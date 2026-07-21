<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Access Denied — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --red:#CE1126; --green:#007A3D; --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF;
    --text-1:#1F2937; --text-2:#6B7280;
    --radius-lg:24px; --radius-md:18px;
    --shadow-sm:0 4px 16px rgba(31,41,55,0.06); --shadow-md:0 18px 40px -16px rgba(31,41,55,0.18);
    --ease:cubic-bezier(.4,0,.2,1);
  }
  *{box-sizing:border-box;}
  html,body{ margin:0; height:100%; }
  body{
    font-family:'Inter',sans-serif; color:var(--text-1); background:var(--neutral-1);
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

  .topbar{
    display:flex; align-items:center; gap:8px; max-width:1160px; margin:20px auto 0; padding:12px 20px;
    background:rgba(255,255,255,0.72); backdrop-filter:blur(16px); -webkit-backdrop-filter:blur(16px);
    border:1px solid rgba(255,255,255,0.5); border-radius:999px; box-shadow:var(--shadow-sm);
    position:relative; z-index:2;
  }
  .brand{ display:inline-flex; align-items:center; gap:9px; padding:4px 10px 4px 4px; }
  .brand-icon{ width:32px; height:32px; border-radius:50%; object-fit:cover; flex-shrink:0; border:1px solid rgba(255,255,255,0.6); }
  .brand-text{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; }
  .brand-text .hub-accent{ background:linear-gradient(90deg, var(--red), var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }

  .stage{ position:relative; min-height:calc(100vh - 100px); display:flex; align-items:center; justify-content:center; padding:32px; z-index:1; }
  .error-card{ max-width:520px; width:100%; text-align:center; background:var(--white); border:1px solid var(--neutral-2); border-radius:var(--radius-lg); padding:48px 40px; box-shadow:var(--shadow-md); animation:fadeInUp .5s var(--ease); }
  .error-icon{ width:76px; height:76px; margin:0 auto 22px; border-radius:50%; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; display:flex; align-items:center; justify-content:center; }
  .error-code{ font-family:'Poppins',sans-serif; font-weight:800; font-size:64px; line-height:1; margin:0 0 8px; background:linear-gradient(90deg,var(--red),var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }
  .error-title{ font-family:'Poppins',sans-serif; font-weight:800; font-size:22px; margin:0 0 10px; }
  .error-desc{ color:var(--text-2); font-size:14px; line-height:1.7; margin:0 0 6px; }
  .error-path{ display:inline-block; margin:8px 0 26px; padding:6px 14px; border-radius:999px; background:var(--neutral-1); border:1px solid var(--neutral-2); color:var(--text-2); font-size:12px; font-family:monospace; word-break:break-all; }
  .error-actions{ display:flex; gap:12px; justify-content:center; flex-wrap:wrap; }
  .btn-primary{ display:inline-flex; align-items:center; gap:8px; padding:14px 26px; border:none; border-radius:999px; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:14px; cursor:pointer; transition:all .2s var(--ease); }
  .btn-primary:hover{ transform:translateY(-2px); box-shadow:0 16px 30px -14px rgba(0,122,61,0.5); }
  .btn-secondary{ display:inline-flex; align-items:center; gap:8px; padding:14px 26px; border-radius:999px; border:1.5px solid var(--neutral-2); font-weight:700; font-size:14px; color:var(--text-1); transition:all .2s var(--ease); }
  .btn-secondary:hover{ background:var(--neutral-1); }
</style>
</head>
<body>

<div class="keffiyeh-corner-bg"></div>

<div class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/">
        <img class="brand-icon" src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="" />
        <span class="brand-text">Herja<span class="hub-accent">Hub</span></span>
    </a>
</div>

<div class="stage">
    <div class="error-card">
        <div class="error-icon"><i data-lucide="shield-alert" width="34" height="34"></i></div>
        <p class="error-code">403</p>
        <h1 class="error-title">Access Denied</h1>
        <p class="error-desc">You don't have permission to view this page. If you're signed in as a customer, this may be a store-owner-only area (or the other way around).</p>
        <c:if test="${not empty path}">
            <span class="error-path">${path}</span>
        </c:if>
        <div class="error-actions">
            <button class="btn-primary" onclick="history.back()"><i data-lucide="arrow-left" width="16" height="16"></i> Go Back</button>
            <a class="btn-secondary" href="${pageContext.request.contextPath}/"><i data-lucide="home" width="16" height="16"></i> Back to Home</a>
        </div>
    </div>
</div>

<script>lucide.createIcons();</script>
</body>
</html>
