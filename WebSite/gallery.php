<?php $ACTIVE='gallery'; require __DIR__."/lib.php"; ?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>گالری | یونیک رول پلی</title>
<meta name="description" content="لحظه‌های ثبت‌شده توسط شهروندان شهر یونیک؛ عکس‌های شهر، خودروها، گنگ‌ها و رویدادها.">
<meta name="theme-color" content="#05070d">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpath d='M16 8v28a16 16 0 0 0 32 0V8' fill='none' stroke='%23ffc107' stroke-width='11' stroke-linecap='round'/%3E%3C/svg%3E">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;500;600;700;800;900&display=swap">
<link rel="stylesheet" href="style.css">
<style>
.gal{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:16px;margin-top:32px}
.shot{aspect-ratio:16/10;border-radius:var(--r);border:1px solid var(--line2);position:relative;overflow:hidden;display:flex;align-items:flex-end;padding:16px;font-size:.85rem;color:#fff;transition:transform .4s var(--ease),opacity .3s}
.shot::after{content:"";position:absolute;inset:0;background:linear-gradient(0deg,#000c,transparent 55%)}
.shot:hover{transform:scale(1.03)}
.shot span{position:relative;text-shadow:0 1px 8px #000;z-index:1;font-weight:700}
.shot small{position:relative;z-index:1;display:block;color:#ffffffb0;font-weight:400;margin-top:2px}
.shot.hide{display:none}
.shot.c1{background:linear-gradient(200deg,#ff7a45,#5b2a86 55%,#0a1224)}
.shot.c2{background:linear-gradient(200deg,#00e5ff66,#123a7a 55%,#0a1224)}
.shot.c3{background:linear-gradient(200deg,#ffc107aa,#7a2f1a 55%,#0a1224)}
.shot.c4{background:linear-gradient(200deg,#3ddc8477,#123a5a 55%,#0a1224)}
.shot.c5{background:linear-gradient(200deg,#8b6bff88,#2a1a5a 55%,#0a1224)}
.shot.c6{background:linear-gradient(200deg,#ff5c8a77,#3a1a4a 55%,#0a1224)}
.live{text-align:center;padding:50px 20px;border:1px dashed var(--line2);border-radius:var(--r);margin-top:36px;background:var(--panel)}
.live .ictile{margin:0 auto 16px}
</style>
</head>
<body>
<?php require __DIR__.'/inc/head-nav.php'; ?>

<main>
<section class="pagehero">
 <div class="orbp a"></div><div class="orbp b"></div>
 <div class="wrap">
  <div class="crumb"><a href="index.php">خانه</a><span>/</span><span>گالری</span></div>
  <h1>گالری <span data-name>یونیک</span></h1>
  <p>لحظه‌های ثبت‌شده توسط شهروندان شهر؛ از غروب‌های روی بلوار تا دورهمی‌های گنگ‌ها و رویدادهای رسمی.</p>
 </div>
</section>

<section style="padding-top:10px"><div class="wrap rv">
 <div class="tabs" role="tablist" id="gtabs">
  <button role="tab" aria-selected="true" data-f="all">همه</button>
  <button role="tab" data-f="city">شهر</button>
  <button role="tab" data-f="car">خودرو</button>
  <button role="tab" data-f="gang">گنگ‌ها</button>
  <button role="tab" data-f="event">رویداد</button>
 </div>

 <div class="gal" id="gal">
  <div class="shot c1" data-cat="city"><span>غروب روی بلوار</span><small>مرکز شهر</small></div>
  <div class="shot c2" data-cat="city"><span>گشت شبانه</span><small>پلیس دپارتمان</small></div>
  <div class="shot c5" data-cat="gang"><span>دورهمی گنگ‌ها</span><small>حومه‌ی شهر</small></div>
  <div class="shot c3" data-cat="event"><span>افتتاحیه‌ی فصل جدید</span><small>رویداد رسمی</small></div>
  <div class="shot c4" data-cat="car"><span>مسابقه‌ی خیابانی</span><small>بندر شهر</small></div>
  <div class="shot c6" data-cat="event"><span>جشن شب یلدا</span><small>میدان مرکزی</small></div>
  <div class="shot c2" data-cat="car"><span>نمایشگاه خودرو</span><small>گاراژ مرکزی</small></div>
  <div class="shot c1" data-cat="city"><span>روز بارونی</span><small>خیابان اصلی</small></div>
  <div class="shot c5" data-cat="gang"><span>معامله‌ی نیمه‌شب</span><small>منطقه‌ی صنعتی</small></div>
 </div>
</div></section>

<section style="background:var(--bg2)"><div class="wrap rv">
 <div class="live">
  <div class="ictile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="15" height="14" rx="2"/><path d="m17 10 5-3v10l-5-3"/></svg></div>
  <h3>پخش زنده</h3>
  <p class="sub" style="margin:6px auto 0">پخش زنده‌ی استریمرها به‌زودی از همین‌جا در دسترس خواهد بود.</p>
  <p style="margin-top:22px"><a class="btn pri" data-discord href="#">دنبال کردن استریمرها در دیسکورد</a></p>
 </div>
</div></section>
</main>

<?php
$EXTRA_JS = <<<JS
document.querySelectorAll("#gtabs button").forEach(b=>b.onclick=()=>{
 document.querySelectorAll("#gtabs button").forEach(x=>x.setAttribute("aria-selected",x===b));
 const f=b.dataset.f;
 document.querySelectorAll("#gal .shot").forEach(s=>s.classList.toggle("hide", f!=="all" && s.dataset.cat!==f));
});
JS;
require __DIR__.'/inc/foot.php';
?>
</body>
</html>
