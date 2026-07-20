<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HerjaHub — Supporting Palestinian Crafts</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;1,6..72,500&family=Inter:wght@400;500;600;700&family=Tajawal:wght@400;500;700&display=swap" rel="stylesheet">
<style>
  :root{
    --white:#FFFFFF;
    --light-gray:#F8F9FA;
    --charcoal:#1F2937;
    --green:#198754;
    --green-dark:#146c43;
    --red:#D72638;
    --black:#111111;
    --line: rgba(31,41,55,0.10);
  }
  *{box-sizing:border-box;}
  html,body{margin:0;padding:0;}
  body{
    font-family:'Inter',sans-serif;
    color:var(--charcoal);
    background:var(--light-gray);
    min-height:100vh;
    overflow-x:hidden;
    position:relative;
  }
  .font-display{ font-family:'Newsreader', serif; }
  .font-ar{ font-family:'Tajawal', sans-serif; }

  .keffiyeh-bg{
    position:absolute; inset:0; pointer-events:none;
    background-image:
      repeating-linear-gradient(45deg, var(--charcoal) 0, var(--charcoal) 1px, transparent 1px, transparent 14px),
      repeating-linear-gradient(-45deg, var(--charcoal) 0, var(--charcoal) 1px, transparent 1px, transparent 14px);
    opacity:0.045;
  }
  .keffiyeh-corner{
    position:absolute; width:180px; height:180px; pointer-events:none; opacity:0.08;
    background-image:
      repeating-linear-gradient(45deg, var(--charcoal) 0, var(--charcoal) 1.5px, transparent 1.5px, transparent 10px),
      repeating-linear-gradient(-45deg, var(--charcoal) 0, var(--charcoal) 1.5px, transparent 1.5px, transparent 10px);
  }

  .tatreez-divider{
    display:flex; align-items:center; justify-content:center; gap:6px; margin: 22px 0;
  }
  .tatreez-divider .line{ flex:1; height:1px; background:var(--line); }
  .tatreez-divider svg{ flex-shrink:0; opacity:0.55; }

  .stage{
    position:relative;
    min-height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
    padding:32px;
  }

  .auth-shell{
    position:relative;
    width:100%;
    max-width:1180px;
    height:760px;
    max-height:92vh;
    border-radius:28px;
    overflow:hidden;
    box-shadow: 0 40px 80px -30px rgba(17,17,17,0.35), 0 0 0 1px rgba(255,255,255,0.6);
    display:flex;
    background:var(--white);
  }

  .panel{
    position:relative;
    width:50%;
    height:100%;
    flex-shrink:0;
    transition: transform 620ms cubic-bezier(.65,0,.35,1);
  }
  .panel-form{
    display:flex; align-items:center; justify-content:center;
    background:var(--white);
    padding:40px;
    z-index:2;
  }
  .panel-image{ overflow:hidden; }
  .auth-shell.swapped .panel-form{ transform: translateX(100%); }
  .auth-shell.swapped .panel-image{ transform: translateX(-100%); }

  .image-wrap{
    position:absolute; inset:10px;
    border-radius:20px;
    overflow:hidden;
  }
  .image-wrap img{
    width:100%; height:100%; object-fit:cover;
    transform: scale(1.02);
  }
  .image-gradient{
    position:absolute; inset:0;
    background: linear-gradient(180deg, rgba(17,17,17,0) 35%, rgba(17,17,17,0.15) 60%, rgba(17,17,17,0.78) 100%);
  }
  .image-wrap .keffiyeh-corner{ opacity:0.14; filter:brightness(0) invert(1); top:0; left:0; }

  .glass-card{
    position:absolute; left:24px; right:24px; bottom:24px;
    background: rgba(255,255,255,0.10);
    backdrop-filter: blur(14px);
    -webkit-backdrop-filter: blur(14px);
    border: 1px solid rgba(255,255,255,0.25);
    border-radius:18px;
    padding:22px 24px;
    box-shadow: 0 20px 40px -20px rgba(0,0,0,0.5);
    color:#fff;
  }
  .glass-card h3{ margin:0 0 6px; font-size:19px; font-weight:500; }
  .glass-card p{ margin:0; font-size:13.5px; line-height:1.5; color:rgba(255,255,255,0.85); }

  .flag-ribbon{
    position:absolute; top:22px; right:22px; z-index:3;
    display:flex; align-items:center; gap:8px;
    background:rgba(17,17,17,0.35);
    backdrop-filter: blur(6px);
    border:1px solid rgba(255,255,255,0.2);
    border-radius:999px;
    padding:6px 12px 6px 8px;
  }
  .flag-ribbon span{ color:#fff; font-size:12px; letter-spacing:0.04em; }

  .souq-label{
    position:absolute; top:24px; left:24px; z-index:3;
    color:#fff; font-size:12px; letter-spacing:0.14em; text-transform:uppercase;
    opacity:0.85;
  }

  .form-inner{ width:100%; max-width:380px; }

  .logo-row{ display:flex; align-items:center; gap:10px; margin-bottom:4px; }
  .logo-mark{
    width:34px; height:34px; border-radius:9px;
    background: linear-gradient(135deg, var(--green), var(--green-dark));
    display:flex; align-items:center; justify-content:center;
    color:#fff; font-family:'Newsreader',serif; font-size:18px; font-weight:600;
    flex-shrink:0;
  }
  .brand-name{ font-size:20px; font-weight:700; letter-spacing:-0.01em; }
  .subtitle{ font-size:13px; color:#6b7280; margin-top:2px; }

  .form-title{ font-size:28px; margin:22px 0 4px; font-weight:500; }
  .form-sub{ font-size:14px; color:#6b7280; margin-bottom:22px; }

  .field{ position:relative; margin-bottom:16px; }
  .field input, .field select{
    width:100%;
    padding:16px 14px 8px 42px;
    border:1px solid rgba(31,41,55,0.15);
    border-radius:12px;
    font-size:14.5px;
    background:var(--light-gray);
    color:var(--charcoal);
    outline:none;
    transition: border-color 250ms ease, box-shadow 250ms ease, background 250ms ease;
  }
  .field input:focus, .field select:focus{
    border-color:var(--green);
    background:#fff;
    box-shadow: 0 0 0 4px rgba(25,135,84,0.12);
  }
  .field label{
    position:absolute; left:42px; top:14px;
    font-size:14.5px; color:#8b93a1;
    pointer-events:none;
    transition: all 200ms ease;
  }
  .field input:focus + label,
  .field input:not(:placeholder-shown) + label{
    top:6px; font-size:11px; color:var(--green); font-weight:600;
  }
  .field .icon{
    position:absolute; left:14px; top:15px; width:16px; height:16px; color:#9aa2af; z-index:1;
  }
  .field input:focus ~ .icon{ color:var(--green); }
  .field.has-error input{ border-color:var(--red); background:#fff5f5; }
  .field.has-error input:focus{ box-shadow: 0 0 0 4px rgba(215,38,56,0.12); }
  .field input.field-error-input{ border-color:var(--red); background:#fff5f5; }
  .field input.field-error-input:focus{ box-shadow: 0 0 0 4px rgba(215,38,56,0.12); }

  .field-error{
    display:block; color:var(--red); font-size:12px; margin:-10px 0 12px 4px;
  }
  .global-error{
    background:rgba(215,38,56,0.08); border:1px solid rgba(215,38,56,0.25);
    color:var(--red); border-radius:10px; padding:10px 14px; font-size:13px; margin-bottom:16px;
  }

  .row-2{ display:grid; grid-template-columns:1fr 1fr; gap:12px; }

  .aux-row{ display:flex; align-items:center; justify-content:space-between; margin:2px 0 20px; font-size:13px; }
  .remember{ display:flex; align-items:center; gap:8px; color:#6b7280; }
  .remember input{ width:15px; height:15px; accent-color:var(--green); }
  .forgot{ color:var(--charcoal); text-decoration:none; font-weight:500; }
  .forgot:hover{ color:var(--green); }

  .btn-primary{
    width:100%; padding:14px; border:none; border-radius:12px;
    background:var(--green); color:#fff; font-size:15px; font-weight:600;
    cursor:pointer; transition: all 280ms cubic-bezier(.34,1.56,.64,1);
    box-shadow: 0 8px 20px -8px rgba(25,135,84,0.5);
  }
  .btn-primary:hover{ background:var(--green-dark); transform:translateY(-2px); box-shadow: 0 12px 24px -8px rgba(25,135,84,0.6); }
  .btn-primary:active{ transform:translateY(0); }

  .switch-line{ text-align:center; margin-top:20px; font-size:13.5px; color:#6b7280; }
  .switch-line button{
    background:none; border:none; color:var(--green); font-weight:700; cursor:pointer; font-size:13.5px;
    padding:0; margin-left:4px;
  }
  .switch-line button:hover{ text-decoration:underline; }

  .role-toggle{
    display:flex; background:var(--light-gray); border-radius:12px; padding:4px; margin-bottom:18px;
    position:relative; border:1px solid var(--line);
  }
  .role-toggle button{
    flex:1; position:relative; z-index:2; border:none; background:transparent;
    padding:10px 8px; font-size:13.5px; font-weight:600; color:#6b7280; cursor:pointer;
    border-radius:9px; transition: color 250ms ease;
  }
  .role-toggle button.active{ color:#fff; }
  .role-toggle .thumb{
    position:absolute; top:4px; left:4px; bottom:4px; width:calc(50% - 4px);
    background:var(--green); border-radius:9px;
    transition: transform 320ms cubic-bezier(.65,0,.35,1);
    box-shadow: 0 4px 12px -4px rgba(25,135,84,0.5);
  }
  .role-toggle.owner .thumb{ transform: translateX(100%); }

  .expand-wrap{
    max-height:0; overflow:hidden;
    transition: max-height 420ms cubic-bezier(.65,0,.35,1), opacity 320ms ease;
    opacity:0;
  }
  .expand-wrap.open{ max-height:500px; opacity:1; }

  .form-stack{ position:relative; width:100%; }
  .form-panel{
    transition: opacity 380ms ease, transform 420ms cubic-bezier(.65,0,.35,1);
  }
  .form-panel.login-panel{ position:relative; }
  .form-panel.register-panel{
    position:absolute; top:0; left:0; width:100%;
    opacity:0; transform:translateY(14px); pointer-events:none;
  }
  .auth-shell.swapped .register-panel{ position:relative; opacity:1; transform:translateY(0); pointer-events:auto; }
  .auth-shell.swapped .login-panel{ position:absolute; top:0; left:0; width:100%; opacity:0; transform:translateY(-14px); pointer-events:none; }

  .scroll-form{ max-height:100%; overflow-y:auto; padding-right:2px; }
  .scroll-form::-webkit-scrollbar{ width:4px; }
  .scroll-form::-webkit-scrollbar-thumb{ background:rgba(31,41,55,0.15); border-radius:4px; }

  @media (max-width: 860px){
    .stage{ padding:0; }
    .auth-shell{ height:auto; max-height:none; border-radius:0; flex-direction:column; min-height:100vh; }
    .panel{ width:100%; transition:none; }
    .panel-image{ height:280px; }
    .panel-form{ padding:28px 22px 48px; }
    .auth-shell.swapped .panel-form,
    .auth-shell.swapped .panel-image{ transform:none; }
  }
</style>
</head>
<body>

<div class="keffiyeh-bg"></div>

<div class="stage">
  <div class="auth-shell" id="authShell">

    <!-- FORM PANEL -->
    <div class="panel panel-form">
      <div class="form-inner">
        <div class="form-stack">

          <!-- LOGIN -->
          <div class="form-panel login-panel">
            <div class="logo-row">
              <div class="logo-mark">ه</div>
              <div>
                <div class="brand-name">HerjaHub</div>
              </div>
            </div>
            <div class="subtitle font-ar">دعمًا للحرفيين الفلسطينيين · Supporting Palestinian Crafts</div>

            <div class="tatreez-divider">
              <span class="line"></span>
              <svg width="60" height="10" viewBox="0 0 60 10"><path d="M0 5 L5 0 L10 5 L5 10 Z M15 5 L20 0 L25 5 L20 10 Z M30 5 L35 0 L40 5 L35 10 Z M45 5 L50 0 L55 5 L50 10 Z" fill="#198754"/></svg>
              <span class="line"></span>
            </div>

            <h1 class="form-title font-display">Welcome back</h1>
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
                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6l9 6 9-6M4 4h16a1 1 0 011 1v14a1 1 0 01-1 1H4a1 1 0 01-1-1V5a1 1 0 011-1z"/></svg>
                <form:input path="email" placeholder=" " autocomplete="username" cssErrorClass="field-error-input"/>
                <label>Email address</label>
              </div>
              <form:errors path="email" cssClass="field-error" element="span"/>

              <div class="field">
                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="11" width="16" height="9" rx="2"/><path d="M8 11V7a4 4 0 018 0v4"/></svg>
                <form:password path="password" placeholder=" " autocomplete="current-password" cssErrorClass="field-error-input"/>
                <label>Password</label>
              </div>
              <form:errors path="password" cssClass="field-error" element="span"/>

              <div class="aux-row">
                <label class="remember"><form:checkbox path="rememberMe"/> Remember me</label>
                <a href="#" class="forgot">Forgot password?</a>
              </div>
              <button class="btn-primary" type="submit">Log in</button>
            </form:form>

            <div class="switch-line">
              Don't have an account?
              <button type="button" onclick="setMode(true)">Register</button>
            </div>
          </div>

          <!-- REGISTER -->
          <div class="form-panel register-panel">
            <div class="scroll-form">
              <div class="logo-row">
                <div class="logo-mark">ه</div>
                <div class="brand-name">HerjaHub</div>
              </div>
              <div class="subtitle font-ar">إنشاء حساب جديد · Join the marketplace</div>

              <div class="tatreez-divider">
                <span class="line"></span>
                <svg width="60" height="10" viewBox="0 0 60 10"><path d="M0 5 L5 0 L10 5 L5 10 Z M15 5 L20 0 L25 5 L20 10 Z M30 5 L35 0 L40 5 L35 10 Z M45 5 L50 0 L55 5 L50 10 Z" fill="#198754"/></svg>
                <span class="line"></span>
              </div>

              <h1 class="form-title font-display" style="font-size:26px;">Create your account</h1>
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
                      <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 4-6 8-6s8 2 8 6"/></svg>
                      <form:input path="firstName" placeholder=" " cssErrorClass="field-error-input"/>
                      <label>First name</label>
                    </div>
                    <form:errors path="firstName" cssClass="field-error" element="span"/>
                  </div>
                  <div>
                    <div class="field">
                      <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 4-6 8-6s8 2 8 6"/></svg>
                      <form:input path="lastName" placeholder=" " cssErrorClass="field-error-input"/>
                      <label>Last name</label>
                    </div>
                    <form:errors path="lastName" cssClass="field-error" element="span"/>
                  </div>
                </div>

                <div class="field">
                  <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6l9 6 9-6M4 4h16a1 1 0 011 1v14a1 1 0 01-1 1H4a1 1 0 01-1-1V5a1 1 0 011-1z"/></svg>
                  <form:input path="email" placeholder=" " cssErrorClass="field-error-input"/>
                  <label>Email address</label>
                </div>
                <form:errors path="email" cssClass="field-error" element="span"/>

                <div class="row-2">
                  <div>
                    <div class="field">
                      <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="11" width="16" height="9" rx="2"/><path d="M8 11V7a4 4 0 018 0v4"/></svg>
                      <form:password path="password" placeholder=" " cssErrorClass="field-error-input"/>
                      <label>Password</label>
                    </div>
                    <form:errors path="password" cssClass="field-error" element="span"/>
                  </div>
                  <div>
                    <div class="field">
                      <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="11" width="16" height="9" rx="2"/><path d="M8 11V7a4 4 0 018 0v4"/></svg>
                      <form:password path="confirmPassword" placeholder=" " cssErrorClass="field-error-input"/>
                      <label>Confirm password</label>
                    </div>
                    <form:errors path="confirmPassword" cssClass="field-error" element="span"/>
                  </div>
                </div>

                <!-- Store owner extra fields -->
                <div class="expand-wrap" id="ownerFields">
                  <div class="field">
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l1-5h16l1 5M4 9h16v10a1 1 0 01-1 1H5a1 1 0 01-1-1V9z"/></svg>
                    <form:input path="storeName" placeholder=" " cssErrorClass="field-error-input"/>
                    <label>Store name</label>
                  </div>
                  <form:errors path="storeName" cssClass="field-error" element="span"/>

                  <div class="field">
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 6h16M4 12h16M4 18h10"/></svg>
                    <form:input path="description" placeholder=" "/>
                    <label>Store description</label>
                  </div>
                  <form:errors path="description" cssClass="field-error" element="span"/>

                  <div class="row-2">
                    <div>
                      <div class="field">
                        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.9v3a2 2 0 01-2.2 2 19.8 19.8 0 01-8.6-3 19.5 19.5 0 01-6-6 19.8 19.8 0 01-3-8.7A2 2 0 014.1 2h3a2 2 0 012 1.7c.1 1 .3 2 .6 3a2 2 0 01-.5 2L8 10a16 16 0 006 6l1.3-1.2a2 2 0 012-.5c1 .3 2 .5 3 .6a2 2 0 011.7 2z"/></svg>
                        <form:input path="phone" placeholder=" " cssErrorClass="field-error-input"/>
                        <label>Phone number</label>
                      </div>
                      <form:errors path="phone" cssClass="field-error" element="span"/>
                    </div>
                    <div>
                      <div class="field">
                        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 6-9 12-9 12s-9-6-9-12a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
                        <form:input path="address" placeholder=" " cssErrorClass="field-error-input"/>
                        <label>Address</label>
                      </div>
                      <form:errors path="address" cssClass="field-error" element="span"/>
                    </div>
                  </div>
                </div>

                <button class="btn-primary" type="submit" style="margin-top:6px;">Create account</button>
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
        <div class="keffiyeh-corner"></div>
        <div class="image-gradient"></div>

        <div class="souq-label font-ar">سوق الحرجة</div>

        <div class="flag-ribbon">
          <svg width="20" height="14" viewBox="0 0 30 20"><rect width="30" height="6.66" y="0" fill="#111111"/><rect width="30" height="6.66" y="6.66" fill="#FFFFFF"/><rect width="30" height="6.66" y="13.33" fill="#198754"/><path d="M0 0L10 10L0 20Z" fill="#D72638"/></svg>
          <span>Souq Al-Haraj</span>
        </div>

        <div class="glass-card">
          <h3 class="font-display">Supporting Palestinian Crafts</h3>
          <p>Every handmade product tells a story. Preserve our heritage by supporting local artisans.</p>
        </div>
      </div>
    </div>

  </div>
</div>

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
