<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Product — HerjaHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;0,6..72,700;1,6..72,500&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
<style>
  :root{
    --olive:#4B5D3A; --olive-dark:#39492B; --olive-light:#EEF1E6;
    --sage:#93A57F; --ivory:#FBF8F0; --white:#FFFFFF;
    --gold:#C9A227; --gold-light:#F8F0DA;
    --charcoal:#2B2A24; --muted:#7C7969;
    --border:#E9E4D6; --error:#B3483F; --error-bg:#FBEAE8;
    --radius-lg:20px; --radius-md:14px; --radius-sm:10px;
    --shadow-sm:0 2px 10px rgba(43,41,35,0.05);
    --shadow-md:0 16px 40px -18px rgba(43,41,35,0.22);
  }
  *{box-sizing:border-box;}
  body{ margin:0; font-family:'Inter',sans-serif; background:var(--ivory); color:var(--charcoal); }
  a{ color:inherit; }

  .topbar{ display:flex; align-items:center; justify-content:space-between; padding:16px 32px; background:var(--white); border-bottom:1px solid var(--border); }
  .brand{ display:flex; align-items:center; gap:10px; font-family:'Newsreader',serif; font-weight:600; font-size:20px; color:var(--olive-dark); }
  .brand .mark{ width:36px; height:36px; border-radius:11px; background:linear-gradient(155deg,var(--olive),var(--olive-dark)); color:var(--gold-light); display:flex; align-items:center; justify-content:center; }

  .page-wrap{ max-width:760px; margin:0 auto; padding:32px 24px 60px; }

  .page-header{ display:flex; align-items:center; gap:14px; margin-bottom:22px; }
  .back-link{ width:38px; height:38px; border-radius:11px; border:1px solid var(--border); background:var(--white); display:flex; align-items:center; justify-content:center; color:var(--muted); text-decoration:none; }
  .back-link:hover{ background:var(--olive-light); color:var(--olive-dark); }
  .page-header h1{ font-family:'Newsreader',serif; font-weight:600; font-size:27px; margin:0; }
  .page-header p{ margin:2px 0 0; color:var(--muted); font-size:14px; }

  .error-banner{ display:flex; align-items:center; gap:10px; color:var(--error); font-size:13.5px; background:var(--error-bg); border:1px solid #f0c9c4; border-radius:var(--radius-md); padding:12px 16px; margin-bottom:18px; }

  .card{ background:var(--white); border:1px solid var(--border); border-radius:var(--radius-lg); padding:26px; box-shadow:var(--shadow-sm); margin-bottom:20px; }
  .card-title{ display:flex; align-items:center; gap:10px; margin-bottom:18px; }
  .card-title .ic{ width:36px; height:36px; border-radius:10px; background:var(--olive-light); color:var(--olive-dark); display:flex; align-items:center; justify-content:center; }
  .card-title h2{ font-family:'Newsreader',serif; font-size:18px; margin:0; }

  label{ display:block; font-size:13px; font-weight:700; margin:0 0 6px; }
  .field{ margin-bottom:16px; }
  .field:last-child{ margin-bottom:0; }
  input[type=text], input[type=number], textarea{ width:100%; padding:11px 13px; border:1px solid var(--border); border-radius:var(--radius-sm); font-size:14px; font-family:'Inter',sans-serif; background:var(--ivory); transition:all .15s ease; }
  input[type=text]:focus, input[type=number]:focus, textarea:focus{ outline:none; border-color:var(--olive); background:var(--white); box-shadow:0 0 0 3px var(--olive-light); }
  textarea{ min-height:100px; resize:vertical; }
  .price-input-wrap{ position:relative; }
  .price-input-wrap span{ position:absolute; left:13px; top:50%; transform:translateY(-50%); color:var(--muted); font-weight:600; }
  .price-input-wrap input{ padding-left:28px; }

  .dropzone{ border:2px dashed var(--sage); border-radius:var(--radius-md); background:var(--olive-light); padding:34px 20px; text-align:center; cursor:pointer; transition:all .18s ease; }
  .dropzone:hover, .dropzone.dragover{ background:#E4EBDA; border-color:var(--olive); }
  .dropzone i{ color:var(--olive); }
  .dropzone .dz-title{ font-weight:700; margin:10px 0 4px; }
  .dropzone .dz-sub{ font-size:12.5px; color:var(--muted); }
  .dropzone input[type=file]{ display:none; }
  .preview-wrap{ margin-top:14px; display:none; align-items:center; gap:14px; }
  .preview-wrap img{ width:84px; height:84px; object-fit:contain; border-radius:12px; border:1px solid var(--border); background:var(--white); }
  .preview-remove{ font-size:13px; color:var(--error); cursor:pointer; font-weight:700; background:none; border:none; }

  .actions-bar{ display:flex; justify-content:flex-end; gap:10px; margin-top:6px; }
  .btn{ border:none; border-radius:var(--radius-sm); padding:12px 22px; font-weight:700; font-size:14px; cursor:pointer; font-family:'Inter',sans-serif; display:inline-flex; align-items:center; gap:8px; transition:transform .15s ease, box-shadow .15s ease; }
  .btn-primary{ background:var(--olive); color:#fff; box-shadow:var(--shadow-sm); }
  .btn-primary:hover{ background:var(--olive-dark); transform:translateY(-1px); box-shadow:var(--shadow-md); }
  .btn-ghost{ background:var(--white); color:var(--charcoal); border:1px solid var(--border); }
  .btn-ghost:hover{ background:var(--olive-light); }

  @media (max-width:600px){ .page-wrap{ padding:20px 14px 40px; } }
</style>
</head>
<body>
  
</body>
</html>
