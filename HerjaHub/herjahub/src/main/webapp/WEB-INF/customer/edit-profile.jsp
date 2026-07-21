<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Profile — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --red:#CE1126; --green:#007A3D; --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF;
    --text-1:#1F2937; --text-2:#6B7280;
    --radius-lg:24px; --radius-md:18px; --radius-sm:12px;
    --shadow-sm:0 4px 16px rgba(31,41,55,0.06); --shadow-md:0 18px 40px -16px rgba(31,41,55,0.18);
    --ease:cubic-bezier(.4,0,.2,1); --sidebar-w:250px; --topbar-h:68px;
  }
  *{box-sizing:border-box;}
  html,body{ height:100%; }
  body{
    margin:0; font-family:'Inter',sans-serif; color:var(--text-1); background:var(--neutral-1);
    background-image:
      radial-gradient(700px 480px at -10% -10%, rgba(206,17,38,0.05), transparent 60%),
      radial-gradient(700px 480px at 110% 0%, rgba(0,122,61,0.06), transparent 60%);
    background-attachment:fixed;
  }
  a{ text-decoration:none; color:inherit; }
  @keyframes fadeInUp{ from{opacity:0; transform:translateY(10px);} to{opacity:1; transform:translateY(0);} }

  .sidebar{ position:fixed; top:0; left:0; bottom:0; width:var(--sidebar-w); z-index:30; background:rgba(255,255,255,0.7); backdrop-filter:blur(20px); -webkit-backdrop-filter:blur(20px); border-right:1px solid rgba(255,255,255,0.6); display:flex; flex-direction:column; padding:22px 16px; }
  .sidebar-brand{ display:flex; align-items:center; gap:10px; padding:6px 10px 26px; }
  .sidebar-brand .mark{ width:38px; height:38px; border-radius:12px; flex-shrink:0; background:linear-gradient(135deg, var(--red), var(--green)); display:flex; align-items:center; justify-content:center; color:var(--white); font-family:'Poppins',sans-serif; font-weight:800; }
  .sidebar-brand .name{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; }
  .side-label{ font-size:10.5px; font-weight:700; text-transform:uppercase; letter-spacing:.08em; color:var(--text-2); padding:14px 12px 8px; }
  .side-link{ display:flex; align-items:center; gap:12px; padding:11px 12px; border-radius:var(--radius-sm); font-weight:600; font-size:14px; color:var(--text-1); margin-bottom:3px; transition:all .22s var(--ease); position:relative; }
  .side-link svg{ flex-shrink:0; opacity:.8; }
  .side-link:hover{ background:var(--neutral-2); }
  .side-link.active{ background:linear-gradient(90deg, rgba(206,17,38,0.1), rgba(0,122,61,0.1)); box-shadow:inset 0 0 0 1px rgba(0,122,61,0.15); }
  .side-link.active svg{ opacity:1; color:var(--green); }
  .side-link.active::before{ content:""; position:absolute; left:-16px; top:8px; bottom:8px; width:4px; border-radius:4px; background:linear-gradient(180deg, var(--red), var(--green)); }
  .sidebar-footer{ margin-top:auto; padding-top:14px; border-top:1px solid var(--neutral-2); }

  .main-area{ margin-left:var(--sidebar-w); min-height:100%; position:relative; z-index:1; }
  .topbar{ position:sticky; top:0; z-index:20; height:var(--topbar-h); display:flex; align-items:center; justify-content:space-between; gap:16px; padding:0 28px; background:rgba(255,255,255,0.65); backdrop-filter:blur(18px); -webkit-backdrop-filter:blur(18px); border-bottom:1px solid rgba(255,255,255,0.5); }
  .topbar-title{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; }
  .logout-btn{ display:flex; align-items:center; gap:6px; padding:9px 14px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); font-size:13px; font-weight:600; color:var(--text-2); transition:all .2s var(--ease); }
  .logout-btn:hover{ color:var(--red); border-color:var(--red); }

  .keffiyeh-corner-bg{ position:fixed; inset:0; z-index:0; pointer-events:none;
    background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
    background-repeat:no-repeat; background-position:bottom right; background-size:min(70vw, 900px); opacity:0.06;
    -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
    mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%); }

  .page{ max-width:760px; padding:36px 32px 60px; }

  /* ===================== SIGNATURE: single centered "profile hub" card, avatar overlapping a banner ===================== */
  .profile-card{ background:var(--white); border:1px solid var(--neutral-2); border-radius:28px; overflow:hidden; box-shadow:var(--shadow-md); animation:fadeInUp .5s var(--ease); }

  .profile-banner{ height:120px; background:linear-gradient(120deg,var(--red),var(--green)); position:relative; }
  .profile-banner::after{ content:""; position:absolute; inset:0; background:radial-gradient(circle at 85% 20%, rgba(255,255,255,0.18), transparent 55%); }

  .profile-identity{ display:flex; align-items:flex-end; gap:18px; padding:0 32px; margin-top:-40px; position:relative; z-index:2; }
  .profile-avatar{ width:88px; height:88px; border-radius:24px; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-family:'Poppins',sans-serif; font-weight:800; font-size:32px; display:flex; align-items:center; justify-content:center; border:5px solid var(--white); box-shadow:var(--shadow-sm); flex-shrink:0; }
  .profile-identity h1{ font-family:'Poppins',sans-serif; font-weight:800; font-size:22px; margin:0 0 20px; color:var(--text-1); }
  .profile-identity .email{ display:block; font-size:13px; color:var(--text-2); font-weight:500; margin-top:-14px; }

  .profile-form{ padding:32px; }
  .form-section-title{ font-family:'Poppins',sans-serif; font-weight:700; font-size:16px; margin:0 0 4px; }
  .form-section-sub{ color:var(--text-2); font-size:13px; margin:0 0 22px; padding-bottom:18px; border-bottom:1px solid var(--neutral-2); }

  .field-grid{ display:grid; grid-template-columns:1fr 1fr; gap:18px 20px; margin-bottom:18px; }
  .field-label{ display:block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.05em; color:var(--text-2); margin-bottom:8px; }
  .field-input{ width:100%; padding:12px 16px; border:1px solid var(--neutral-2); border-radius:14px; background:var(--neutral-1); font-size:14px; font-family:'Inter',sans-serif; transition:all .2s var(--ease); }
  .field-input:focus{ outline:none; border-color:var(--green); background:var(--white); box-shadow:0 0 0 3px rgba(0,122,61,0.12); }
  .field-error-input{ border-color:var(--red) !important; background:#FBEAEA !important; }
  .field-error{ color:var(--red); font-size:12px; display:block; margin-top:6px; }
  .field-full{ grid-column:1 / -1; }

  .save-btn{ margin-top:6px; padding:14px 30px; border:none; border-radius:999px; background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:14px; cursor:pointer; display:inline-flex; align-items:center; gap:8px; transition:all .2s var(--ease); }
  .save-btn:hover{ transform:translateY(-2px); box-shadow:0 14px 26px -14px rgba(0,122,61,0.5); }

  @media (max-width: 900px){
    .sidebar{ transform:translateX(-100%); }
    .main-area{ margin-left:0; }
  }
  @media (max-width: 560px){
    .field-grid{ grid-template-columns:1fr; }
    .profile-identity{ flex-direction:column; align-items:flex-start; gap:10px; }
    .profile-identity h1{ margin-bottom:2px; }
    .profile-identity .email{ margin-top:0; }
  }
  .topbar-right{ display:flex; align-items:center; gap:12px; }
  .user-chip{ display:flex; align-items:center; gap:10px; padding:6px 14px 6px 6px; border-radius:999px; background:var(--white); border:1px solid var(--neutral-2); }
  .user-avatar{ width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center; background:linear-gradient(135deg, var(--red), var(--green)); color:#fff; font-weight:700; font-size:13px; flex-shrink:0; }
  .u-name{ font-size:13px; font-weight:600; }
</style>
</head>
<body>

<div class="keffiyeh-corner-bg"></div>

<aside class="sidebar">
    <a class="sidebar-brand" href="${pageContext.request.contextPath}/customer/dashboard">
        <div class="mark">ه</div><div class="name">HerjaHub</div>
    </a>
    <div class="side-label">Shop</div>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/dashboard"><i data-lucide="layout-dashboard" width="18" height="18"></i> Dashboard</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/products"><i data-lucide="shopping-bag" width="18" height="18"></i> Products</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/stores"><i data-lucide="store" width="18" height="18"></i> Stores</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/ai"><i data-lucide="sparkles" width="18" height="18"></i> AI Assistant</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/cart"><i data-lucide="shopping-cart" width="18" height="18"></i> Cart</a>
    <a class="side-link" href="${pageContext.request.contextPath}/customer/orders"><i data-lucide="package" width="18" height="18"></i> My Orders</a>
    <div class="side-label">Account</div>
    <a class="side-link active" href="${pageContext.request.contextPath}/customer/profile/edit"><i data-lucide="user" width="18" height="18"></i> Edit Profile</a>
    <div class="sidebar-footer">
        <a class="side-link" href="${pageContext.request.contextPath}/logout" style="color:var(--red);"><i data-lucide="log-out" width="18" height="18"></i> Log out</a>
    </div>
</aside>

<div class="main-area">
    <div class="topbar">
        <div class="topbar-title">Edit Profile</div>
<div class="topbar-right">
    <div class="user-chip">
        <div class="user-avatar"><c:out value="${fn:substring(customer.firstName, 0, 1)}" /></div>
        <span class="u-name"><c:out value="${customer.firstName}" /></span>
    </div>
</div>
    </div>

    <div class="page">
        <div class="profile-card">

            <div class="profile-banner"></div>

            <div class="profile-identity">
                <div class="profile-avatar"><c:out value="${fn:substring(editProfileForm.firstName, 0, 1)}" /></div>
                <div>
                    <h1><c:out value="${editProfileForm.firstName} ${editProfileForm.lastName}" /></h1>
                    <span class="email"><c:out value="${editProfileForm.email}" /></span>
                </div>
            </div>

            <div class="profile-form">
                <h2 class="form-section-title">Personal Information</h2>
                <p class="form-section-sub">Update your name, email, or password.</p>

                <form:form id="editProfileForm" action="${pageContext.request.contextPath}/customer/profile/edit" method="post" modelAttribute="editProfileForm">

                    <div class="field-grid">
                        <div>
                            <form:label path="firstName" cssClass="field-label">First Name</form:label>
                            <form:input path="firstName" cssClass="field-input" cssErrorClass="field-input field-error-input" />
                            <form:errors path="firstName" cssClass="field-error" element="span" />
                        </div>
                        <div>
                            <form:label path="lastName" cssClass="field-label">Last Name</form:label>
                            <form:input path="lastName" cssClass="field-input" cssErrorClass="field-input field-error-input" />
                            <form:errors path="lastName" cssClass="field-error" element="span" />
                        </div>

                        <div class="field-full">
                            <form:label path="email" cssClass="field-label">Email Address</form:label>
                            <form:input path="email" cssClass="field-input" cssErrorClass="field-input field-error-input" />
                            <form:errors path="email" cssClass="field-error" element="span" />
                        </div>

                        <div class="field-full">
                            <form:label path="newPassword" cssClass="field-label">New Password</form:label>
                            <form:password path="newPassword" placeholder="Leave blank to keep current password" cssClass="field-input" cssErrorClass="field-input field-error-input" />
                            <form:errors path="newPassword" cssClass="field-error" element="span" />
                        </div>
                    </div>

                    <button type="submit" class="save-btn">
                        <i data-lucide="check" width="16" height="16"></i> Save Changes
                    </button>
                </form:form>
            </div>
        </div>
    </div>
</div>

<script>lucide.createIcons();</script>
</body>
</html>
