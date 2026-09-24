<?php $ACTIVE='team'; require __DIR__."/lib.php"; $ST=site_stats(); ?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>کادر مدیریت | یونیک رول پلی</title>
<meta name="description" content="با کادر مدیریت و گیم‌مسترهای شهر یونیک آشنا شو.">
<meta name="theme-color" content="#050505">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpath d='M16 8v28a16 16 0 0 0 32 0V8' fill='none' stroke='%23ffc107' stroke-width='11' stroke-linecap='round'/%3E%3C/svg%3E">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;500;600;700;800;900&display=swap">
<link rel="stylesheet" href="style.css">
<style>
.roles{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:14px;margin-top:30px}
.rolec{background:linear-gradient(165deg,var(--panel),#0a0906);border:1px solid var(--line2);border-radius:var(--r-sm);padding:16px 18px;display:flex;align-items:center;gap:12px}
.rolec .dotc{width:10px;height:10px;border-radius:50%;flex:none}
.rolec b{display:block;font-size:.95rem}
.rolec span{color:var(--mut);font-size:.78rem}
.empty{text-align:center;padding:50px 20px;border:1px dashed var(--line2);border-radius:var(--r);background:var(--panel);color:var(--mut)}
</style>
</head>
<body>
<?php require __DIR__.'/inc/head-nav.php'; ?>

<main>
<section class="pagehero">
 <div class="orbp a"></div><div class="orbp b"></div>
 <div class="wrap">
  <div class="crumb"><a href="index.php">خانه</a><span>/</span><span>کادر مدیریت</span></div>
  <h1>کادر مدیریت شهر</h1>
  <p>با افرادی آشنا شو که پشت صحنه، تجربه‌ی رول‌پلی شهر رو می‌سازن و بهش نظم می‌دن.</p>
 </div>
</section>

<section style="padding-top:10px"><div class="wrap rv">
 <div class="eyebrow">ساختار مدیریتی</div>
 <h2>سلسله‌مراتب کادر</h2>
 <p class="sub">از مالک شهر تا گیم‌مسترها؛ هرکس یه نقش مشخص برای اداره‌ی شهر داره.</p>
 <div class="roles">
  <div class="rolec"><span class="dotc" style="background:#ff6b6b"></span><div><b>مالک</b><span>تصمیم‌گیری نهایی و مدیریت کلی سرور</span></div></div>
  <div class="rolec"><span class="dotc" style="background:#ffc107"></span><div><b>مدیر ارشد</b><span>نظارت بر تیم مدیریت و رویدادها</span></div></div>
  <div class="rolec"><span class="dotc" style="background:#ffc107"></span><div><b>ادمین</b><span>رسیدگی به گزارش‌ها و تخلفات</span></div></div>
  <div class="rolec"><span class="dotc" style="background:#e6a400"></span><div><b>مدیر</b><span>پشتیبانی روزمره‌ی شهروندان</span></div></div>
  <div class="rolec"><span class="dotc" style="background:#3ddc84"></span><div><b>گیم مستر</b><span>اجرای رویدادها و داستان‌های شهر</span></div></div>
 </div>
</div></section>

<section style="background:var(--bg2)"><div class="wrap rv">
 <div class="eyebrow">اعضای کادر</div>
 <h2>کادر مدیریت فعال</h2>
 <p class="sub">لیست زیر به‌صورت لحظه‌ای از دیتابیس سرور خونده می‌شه.</p>
 <?php if (empty($ST['staff'])): ?>
  <div class="empty">فعلاً عضوی برای نمایش ثبت نشده.</div>
 <?php else: ?>
  <div class="grid" id="staff"></div>
 <?php endif; ?>
</div></section>
</main>

<?php
$J = JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP;
$STAFF = json_encode($ST['staff'], $J);
$EXTRA_JS = <<<JS
const STAFF=$STAFF;
const staffEl=document.getElementById("staff");
if(staffEl){
 staffEl.innerHTML=STAFF.map(s=>`<div class="card rec"><div class="av">\${esc(s[0][0])}</div><h3>\${esc(s[0])}</h3><small style="color:var(--gold)">\${esc(s[1])}</small></div>`).join("");
}
JS;
require __DIR__.'/inc/foot.php';
?>
</body>
</html>
