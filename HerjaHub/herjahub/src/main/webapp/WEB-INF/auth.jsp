<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Log In or Register — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Poppins:wght@600;700;800&family=Tajawal:wght@400;500;700&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --red:#CE1126; --green:#007A3D; --white:#FFFFFF; --neutral-1:#F8F9FA; --neutral-2:#E9ECEF;
    --text-1:#1F2937; --text-2:#6B7280; --error-bg:#FBEAEA; --error-border:#F3CACA;
    --radius-lg:24px; --radius-md:18px; --radius-sm:12px;
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
    background-attachment:fixed; overflow-x:hidden;
  }
  a{ text-decoration:none; color:inherit; }
  .font-ar{ font-family:'Tajawal', sans-serif; }
  @keyframes fadeInUp{ from{opacity:0; transform:translateY(14px);} to{opacity:1; transform:translateY(0);} }

  .keffiyeh-corner-bg{ position:fixed; inset:0; z-index:0; pointer-events:none;
    background-image:url('${pageContext.request.contextPath}/resources/images/keffiyeh-pattern.png');
    background-repeat:no-repeat; background-position:bottom right; background-size:min(70vw, 900px); opacity:0.06;
    -webkit-mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%);
    mask-image:radial-gradient(circle at bottom right, black 0%, black 15%, transparent 65%); }

  /* ===== Top nav (same language as the landing page) ===== */
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
  .home-link{ display:inline-flex; align-items:center; gap:7px; padding:10px 20px; border-radius:999px; font-weight:700; font-size:13.5px; color:var(--text-1); border:1.5px solid var(--neutral-2); transition:all .2s var(--ease); }
  .home-link:hover{ border-color:var(--green); color:var(--green); }

  /* ===================== SIGNATURE: split shell, sliding form/image swap ===================== */
  .stage{ position:relative; min-height:calc(100vh - 100px); display:flex; align-items:center; justify-content:center; padding:32px; z-index:1; }

  .auth-shell{
    position:relative; width:100%; max-width:1160px; height:740px; max-height:88vh;
    border-radius:var(--radius-lg); overflow:hidden; display:flex;
    background:var(--white); border:1px solid rgba(255,255,255,0.6); box-shadow:var(--shadow-md);
  }
  .panel{ position:relative; width:50%; height:100%; flex-shrink:0; transition:transform 620ms cubic-bezier(.65,0,.35,1); }
  .panel-form{ display:flex; align-items:center; justify-content:center; background:var(--white); padding:36px; z-index:2; overflow-y:auto; }
  .panel-image{ overflow:hidden; }
  .auth-shell.swapped .panel-form{ transform:translateX(100%); }
  .auth-shell.swapped .panel-image{ transform:translateX(-100%); }

  .form-inner{ width:100%; max-width:380px; }
  .form-stack{ position:relative; }
  .form-panel{ width:100%; }
  .register-panel{ display:none; }
  .auth-shell.swapped .login-panel{ display:none; }
  .auth-shell.swapped .register-panel{ display:block; }

  .logo-row{ display:flex; align-items:center; gap:10px; margin-bottom:6px; }
  .logo-mark{ width:38px; height:38px; border-radius:12px; overflow:hidden; flex-shrink:0; background:linear-gradient(135deg, var(--red), var(--green)); }
  .logo-mark img{ width:100%; height:100%; object-fit:cover; }
  .brand-name{ font-family:'Poppins',sans-serif; font-weight:800; font-size:17px; }
  .brand-name .hub-accent{ background:linear-gradient(90deg, var(--red), var(--green)); -webkit-background-clip:text; background-clip:text; color:transparent; }
  .subtitle{ font-size:12.5px; color:var(--text-2); margin:10px 0 18px; }

  .form-title{ font-family:'Poppins',sans-serif; font-weight:800; font-size:26px; margin:0 0 6px; }
  .form-sub{ font-size:13.5px; color:var(--text-2); margin:0 0 22px; }

  /* role toggle pill, matching the filter-chip / nav-item pill language used elsewhere */
  .role-toggle{ position:relative; display:grid; grid-template-columns:1fr 1fr; background:var(--neutral-1); border:1px solid var(--neutral-2); border-radius:999px; padding:4px; margin-bottom:22px; }
  .role-toggle .thumb{ position:absolute; top:4px; left:4px; width:calc(50% - 4px); height:calc(100% - 8px); border-radius:999px; background:linear-gradient(135deg,var(--red),var(--green)); transition:transform .28s var(--ease); }
  .role-toggle.owner .thumb{ transform:translateX(100%); }
  .role-toggle button{ position:relative; z-index:1; border:none; background:none; padding:9px 10px; font-size:13px; font-weight:700; color:var(--text-2); border-radius:999px; cursor:pointer; transition:color .2s var(--ease); }
  .role-toggle button.active{ color:#fff; }

  .field{ position:relative; margin-bottom:16px; }
  .field .icon{ position:absolute; left:16px; top:50%; transform:translateY(-50%); color:var(--text-2); pointer-events:none; transition:color .2s var(--ease); z-index:1; }
  .field input{ width:100%; padding:16px 16px 16px 44px; border:1px solid var(--neutral-2); border-radius:14px; background:var(--neutral-1); font-size:14px; font-family:'Inter',sans-serif; transition:all .2s var(--ease); }
  .field input:focus{ outline:none; border-color:var(--green); background:var(--white); box-shadow:0 0 0 3px rgba(0,122,61,0.12); }
  .field input:focus ~ .icon{ color:var(--green); }
  .field input.field-error-input{ border-color:var(--red); background:var(--error-bg); }
  .field-error{ display:block; color:var(--red); font-size:12px; margin:-10px 0 12px 4px; }
  .global-error{ padding:12px 16px; border-radius:14px; background:var(--error-bg); border:1px solid var(--error-border); color:var(--red); font-size:13px; margin-bottom:16px; }

  .row-2{ display:grid; grid-template-columns:1fr 1fr; gap:12px; }

  .aux-row{ display:flex; align-items:center; justify-content:space-between; margin:-2px 0 20px; font-size:12.5px; }
  .remember{ display:flex; align-items:center; gap:7px; color:var(--text-2); cursor:pointer; }
  .remember input{ accent-color:var(--green); width:14px; height:14px; }
  .forgot{ color:var(--text-2); font-weight:600; transition:color .2s var(--ease); }
  .forgot:hover{ color:var(--green); }

  .btn-primary{
    display:flex; align-items:center; justify-content:center; gap:8px; width:100%; padding:15px; border:none; border-radius:999px;
    background:linear-gradient(135deg,var(--red),var(--green)); color:#fff; font-weight:700; font-size:14.5px;
    cursor:pointer; transition:all .2s var(--ease);
  }
  .btn-primary:hover{ transform:translateY(-2px); box-shadow:0 16px 30px -14px rgba(0,122,61,0.5); }

  .switch-line{ text-align:center; font-size:13px; color:var(--text-2); margin-top:20px; }
  .switch-line button{ border:none; background:none; color:var(--green); font-weight:700; cursor:pointer; font-size:13px; padding:0 0 0 4px; }
  .switch-line button:hover{ text-decoration:underline; }

  .expand-wrap{ max-height:0; overflow:hidden; opacity:0; transition:max-height .35s var(--ease), opacity .3s var(--ease); }
  .expand-wrap.open{ max-height:600px; opacity:1; }

  .scroll-form::-webkit-scrollbar{ width:6px; }
  .scroll-form::-webkit-scrollbar-thumb{ background:var(--neutral-2); border-radius:6px; }

  /* ===== Image panel ===== */
  .image-wrap{ position:absolute; inset:10px; border-radius:var(--radius-md); overflow:hidden; }
  .image-wrap img{ width:100%; height:100%; object-fit:cover; }
  .image-gradient{ position:absolute; inset:0; background:linear-gradient(180deg, rgba(17,17,17,0.05) 0%, rgba(17,17,17,0.15) 55%, rgba(17,17,17,0.65) 100%); }
  .souq-label{ position:absolute; top:22px; right:26px; color:rgba(255,255,255,0.92); font-size:15px; font-weight:700; text-shadow:0 2px 8px rgba(0,0,0,0.3); }
  .flag-ribbon{ position:absolute; top:22px; left:26px; display:flex; align-items:center; gap:8px; padding:7px 14px; border-radius:999px; background:rgba(255,255,255,0.16); backdrop-filter:blur(8px); border:1px solid rgba(255,255,255,0.25); color:#fff; font-size:12px; font-weight:700; }
  .glass-card{
    position:absolute; left:26px; right:26px; bottom:26px; padding:22px 24px; border-radius:var(--radius-md);
    background:rgba(255,255,255,0.14); backdrop-filter:blur(14px); -webkit-backdrop-filter:blur(14px);
    border:1px solid rgba(255,255,255,0.25); color:#fff;
  }
  .glass-card h3{ font-family:'Poppins',sans-serif; font-weight:800; font-size:19px; margin:0 0 8px; }
  .glass-card p{ font-size:13px; line-height:1.6; margin:0; color:rgba(255,255,255,0.88); }

  @media (max-width:900px){
    .auth-shell{ flex-direction:column; height:auto; max-height:none; border-radius:var(--radius-lg); }
    .panel{ width:100%; }
    .panel-image{ height:220px; order:-1; }
    .panel-form{ padding:32px 24px 40px; }
    .auth-shell.swapped .panel-form, .auth-shell.swapped .panel-image{ transform:none; }
    .stage{ padding:16px; align-items:flex-start; }
    .topbar{ margin:14px 16px 0; }
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
    <a class="home-link" href="${pageContext.request.contextPath}/"><i data-lucide="arrow-left" width="15" height="15"></i> Back to Home</a>
</div>

<div class="stage">
  <div class="auth-shell" id="authShell">

    <!-- FORM PANEL -->
    <div class="panel panel-form">
      <div class="form-inner">
        <div class="form-stack">

          <!-- LOGIN -->
          <div class="form-panel login-panel">
            <div class="logo-row">
              <div class="logo-mark"><img src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="HerjaHub" /></div>
              <div class="brand-name">Herja<span class="hub-accent">Hub</span></div>
            </div>
            <div class="subtitle font-ar">دعمًا للحرفيين الفلسطينيين · Supporting Palestinian Crafts</div>

            <h1 class="form-title">Welcome back</h1>
            <p class="form-sub">Sign in to continue supporting local artisans.</p>

            <div class="role-toggle" id="loginRoleToggle">
              <div class="thumb"></div>
              <button type="button" class="active" onclick="setLoginRole('customer')">Customer</button>
              <button type="button" onclick="setLoginRole('store')">Store Owner</button>
            </div>

            <form:form method="post" action="${pageContext.request.contextPath}/login" modelAttribute="loginForm">
              <form:hidden path="loginType" id="loginTypeInput"/>

              <c:if test="${not empty loginError}">
                <div class="global-error">${loginError}</div>
              </c:if>

              <div class="field">
                <i class="icon" data-lucide="mail" width="18" height="18"></i>
                <form:input path="email" placeholder="Email address" autocomplete="username" cssErrorClass="field-error-input"/>
              </div>
              <form:errors path="email" cssClass="field-error" element="span"/>

              <div class="field">
                <i class="icon" data-lucide="lock" width="18" height="18"></i>
                <form:password path="password" placeholder="Password" autocomplete="current-password" cssErrorClass="field-error-input"/>
              </div>
              <form:errors path="password" cssClass="field-error" element="span"/>

              <div class="aux-row">
                <label class="remember"><form:checkbox path="rememberMe"/> Remember me</label>
                <a href="#" class="forgot">Forgot password?</a>
              </div>
              <button class="btn-primary" type="submit"><i data-lucide="log-in" width="17" height="17"></i> Log in</button>
            </form:form>

            <div class="switch-line">
              Don't have an account?
              <button type="button" onclick="setMode(true)">Register</button>
            </div>
          </div>

          <!-- REGISTER -->
          <div class="form-panel register-panel">
            <div class="scroll-form" style="max-height:78vh; overflow-y:auto; padding-right:4px;">
              <div class="logo-row">
                <div class="logo-mark"><img src="${pageContext.request.contextPath}/resources/images/herjahub-logo.jpg" alt="HerjaHub" /></div>
                <div class="brand-name">Herja<span class="hub-accent">Hub</span></div>
              </div>
              <div class="subtitle font-ar">إنشاء حساب جديد · Join the marketplace</div>

              <h1 class="form-title" style="font-size:23px;">Create your account</h1>
              <p class="form-sub">Join a community built around Palestinian craftsmanship.</p>

              <div class="role-toggle" id="roleToggle">
                <div class="thumb"></div>
                <button type="button" class="active" onclick="setRole('customer')">Customer</button>
                <button type="button" onclick="setRole('owner')">Store Owner</button>
              </div>

              <form:form method="post" action="${pageContext.request.contextPath}/register" modelAttribute="registrationForm">
                <form:hidden path="accountType" id="accountTypeInput"/>

                <div class="row-2">
                  <div>
                    <div class="field">
                      <i class="icon" data-lucide="user" width="18" height="18"></i>
                      <form:input path="firstName" placeholder="First name" cssErrorClass="field-error-input"/>
                    </div>
                    <form:errors path="firstName" cssClass="field-error" element="span"/>
                  </div>
                  <div>
                    <div class="field">
                      <i class="icon" data-lucide="user" width="18" height="18"></i>
                      <form:input path="lastName" placeholder="Last name" cssErrorClass="field-error-input"/>
                    </div>
                    <form:errors path="lastName" cssClass="field-error" element="span"/>
                  </div>
                </div>

                <div class="field">
                  <i class="icon" data-lucide="mail" width="18" height="18"></i>
                  <form:input path="email" placeholder="Email address" cssErrorClass="field-error-input"/>
                </div>
                <form:errors path="email" cssClass="field-error" element="span"/>

                <div class="row-2">
                  <div>
                    <div class="field">
                      <i class="icon" data-lucide="lock" width="18" height="18"></i>
                      <form:password path="password" placeholder="Password" cssErrorClass="field-error-input"/>
                    </div>
                    <form:errors path="password" cssClass="field-error" element="span"/>
                  </div>
                  <div>
                    <div class="field">
                      <i class="icon" data-lucide="lock" width="18" height="18"></i>
                      <form:password path="confirmPassword" placeholder="Confirm password" cssErrorClass="field-error-input"/>
                    </div>
                    <form:errors path="confirmPassword" cssClass="field-error" element="span"/>
                  </div>
                </div>

                <!-- Store owner extra fields -->
                <div class="expand-wrap" id="ownerFields">
                  <div class="field">
                    <i class="icon" data-lucide="store" width="18" height="18"></i>
                    <form:input path="storeName" placeholder="Store name" cssErrorClass="field-error-input"/>
                  </div>
                  <form:errors path="storeName" cssClass="field-error" element="span"/>

                  <div class="field">
                    <i class="icon" data-lucide="align-left" width="18" height="18"></i>
                    <form:input path="description" placeholder="Store description"/>
                  </div>
                  <form:errors path="description" cssClass="field-error" element="span"/>

                  <div class="row-2">
                    <div>
                      <div class="field">
                        <i class="icon" data-lucide="phone" width="18" height="18"></i>
                        <form:input path="phone" placeholder="Phone number" cssErrorClass="field-error-input"/>
                      </div>
                      <form:errors path="phone" cssClass="field-error" element="span"/>
                    </div>
                    <div>
                      <div class="field">
                        <i class="icon" data-lucide="map-pin" width="18" height="18"></i>
                        <form:input path="address" placeholder="Address" cssErrorClass="field-error-input"/>
                      </div>
                      <form:errors path="address" cssClass="field-error" element="span"/>
                    </div>
                  </div>
                </div>

                <button class="btn-primary" type="submit" style="margin-top:6px;"><i data-lucide="check" width="17" height="17"></i> Create account</button>
              </form:form>

              <div class="switch-line">
                Already have an account?
                <button type="button" onclick="setMode(false)">Log in</button>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

    <!-- IMAGE PANEL -->
    <div class="panel panel-image">
      <div class="image-wrap">
        <img src="${pageContext.request.contextPath}/resources/images/souq-alharaj.jpg" alt="Souq Al-Haraj, Ramallah">
        <div class="image-gradient"></div>

        <div class="souq-label font-ar">سوق الحرجة</div>

        <div class="flag-ribbon">
          <i data-lucide="map-pin" width="14" height="14"></i>
          <span>Souq Al-Haraj</span>
        </div>

        <div class="glass-card">
          <h3>Supporting Palestinian Crafts</h3>
          <p>Every handmade product tells a story. Preserve our heritage by supporting local artisans.</p>
        </div>
      </div>
    </div>

  </div>
</div>

<script>lucide.createIcons();</script>

<script>
  const shell = document.getElementById('authShell');
  const roleToggle = document.getElementById('roleToggle');
  const ownerFields = document.getElementById('ownerFields');
  const loginRoleToggle = document.getElementById('loginRoleToggle');
  const accountTypeInput = document.getElementById('accountTypeInput');
  const loginTypeInput = document.getElementById('loginTypeInput');

  function setMode(registering){
    shell.classList.toggle('swapped', registering);
  }

  function setRole(role){
    const buttons = roleToggle.querySelectorAll('button');
    buttons.forEach(b => b.classList.remove('active'));
    if(role === 'owner'){
      roleToggle.classList.add('owner');
      buttons[1].classList.add('active');
      ownerFields.classList.add('open');
      accountTypeInput.value = 'store';
    } else {
      roleToggle.classList.remove('owner');
      buttons[0].classList.add('active');
      ownerFields.classList.remove('open');
      accountTypeInput.value = 'customer';
    }
  }

  function setLoginRole(role){
    const buttons = loginRoleToggle.querySelectorAll('button');
    buttons.forEach(b => b.classList.remove('active'));
    if(role === 'store'){
      loginRoleToggle.classList.add('owner');
      buttons[1].classList.add('active');
      loginTypeInput.value = 'store';
    } else {
      loginRoleToggle.classList.remove('owner');
      buttons[0].classList.add('active');
      loginTypeInput.value = 'customer';
    }
  }

  // Re-apply server-rendered state after a failed submit (which panel to show, which role was picked)
  window.addEventListener('DOMContentLoaded', function(){
    <c:if test="${showRegister}">
      setMode(true);
    </c:if>
    <c:choose>
      <c:when test="${registrationForm.accountType == 'store'}">
        setRole('owner');
      </c:when>
      <c:otherwise>
        setRole('customer');
      </c:otherwise>
    </c:choose>
    <c:choose>
      <c:when test="${loginForm.loginType == 'store'}">
        setLoginRole('store');
      </c:when>
      <c:otherwise>
        setLoginRole('customer');
      </c:otherwise>
    </c:choose>
  });
</script>

</body>
</html>
