<?php $ACTIVE='gallery'; require __DIR__."/lib.php"; ?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>گالری | یونیک رول پلی</title>
<meta name="description" content="لحظه‌های ثبت‌شده توسط شهروندان شهر یونیک؛ عکس‌های شهر، خودروها، گنگ‌ها و رویدادها.">
<meta name="theme-color" content="#050505">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpath d='M16 8v28a16 16 0 0 0 32 0V8' fill='none' stroke='%23ffc107' stroke-width='11' stroke-linecap='round'/%3E%3C/svg%3E">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;500;600;700;800;900&display=swap">
<link rel="stylesheet" href="style.css">
<style>
.gal{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:16px;margin-top:32px}
.shot{aspect-ratio:16/10;border-radius:var(--r);border:1px solid var(--line2);position:relative;overflow:hidden;display:flex;align-items:flex-end;padding:16px;font-size:.85rem;color:#fff;transition:transform .4s var(--ease),opacity .3s}
.shot::after{content:"";position:absolute;inset:0;background:linear-gradient(0deg,#000c,transparent 55%)}
.shot:hover{transform:translateY(-6px) scale(1.02);border-color:#ffc10766;box-shadow:0 24px 50px -12px #000b,0 0 0 1px #ffc10733}
.shot::before{content:"";position:absolute;inset:0;background:radial-gradient(circle at 80% 15%,#ffffff26,transparent 45%);z-index:0}
.shot span{position:relative;text-shadow:0 1px 8px #000;z-index:1;font-weight:700}
.shot small{position:relative;z-index:1;display:block;color:#ffffffb0;font-weight:400;margin-top:2px}
.shot.hide{display:none}
.shot.c1{background:linear-gradient(200deg,#ff7a45,#5a2a10 55%,#0b0a07)}
.shot.c2{background:linear-gradient(200deg,#ffc10766,#4a3408 55%,#0b0a07)}
.shot.c3{background:linear-gradient(200deg,#ffc107aa,#7a2f1a 55%,#0b0a07)}
.shot.c4{background:linear-gradient(200deg,#3ddc8477,#3a2a08 55%,#0b0a07)}
.shot.c5{background:linear-gradient(200deg,#e6a40088,#2a1a05 55%,#0b0a07)}
.shot.c6{background:linear-gradient(200deg,#ff5c3a77,#3a1a10 55%,#0b0a07)}
.shot{cursor:zoom-in}
.shot .shine{position:absolute;inset:0;z-index:1;background:linear-gradient(115deg,transparent 30%,#ffffff3a 48%,#ffffff55 50%,#ffffff3a 52%,transparent 70%);background-size:220% 220%;background-position:130% 130%;opacity:0;transition:opacity .35s,background-position .7s var(--ease)}
.shot:hover .shine{opacity:1;background-position:-30% -30%}
.shot .zoomico{position:absolute;top:12px;inset-inline-end:12px;z-index:1;width:30px;height:30px;border-radius:9px;background:#00000066;border:1px solid #ffffff2e;display:grid;place-items:center;opacity:0;transform:translateY(-4px);transition:.25s var(--ease)}
.shot:hover .zoomico{opacity:1;transform:translateY(0)}
#lightbox{position:fixed;inset:0;z-index:80;background:#000000e6;backdrop-filter:blur(6px);display:none;align-items:center;justify-content:center;padding:40px;animation:lbin .25s var(--ease)}
#lightbox.on{display:flex}
@keyframes lbin{from{opacity:0}to{opacity:1}}
#lightbox .lbcard{width:min(720px,100%);aspect-ratio:16/10;border-radius:var(--r-lg);position:relative;display:flex;align-items:flex-end;padding:26px;border:1px solid #ffc10744;box-shadow:0 40px 120px -20px #000c,0 0 0 1px #ffc10733;overflow:hidden}
#lightbox .lbcard::after{content:"";position:absolute;inset:0;background:linear-gradient(0deg,#000d,transparent 55%)}
#lightbox .lbcard span{position:relative;z-index:1;font-weight:800;font-size:1.2rem;text-shadow:0 1px 8px #000}
#lightbox .lbcard small{position:relative;z-index:1;display:block;color:#ffffffb0;margin-top:4px}
#lightbox .lbclose{position:absolute;top:-46px;inset-inline-end:0;width:36px;height:36px;border-radius:10px;background:var(--panel);border:1px solid var(--line2);color:var(--text);display:grid;place-items:center;cursor:pointer}
</style>
</head>
<body>
<?php require __DIR__.'/inc/head-nav.php'; ?>

<main>
<section class="pagehero">
 <div class="orbp a"></div><div class="orbp b"></div>
 <div class="wrap">
  <div class="crumb"><a href="index.php">خانه</a><span>/</span><span>گالری</span></div>
  <h1><span class="gt">گالری</span> <span data-name>یونیک</span></h1>
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

<div id="lightbox"><div class="lbcard" id="lbcard"><div class="lbclose" id="lbclose">✕</div><span id="lbtitle"></span><br><small id="lbsub"></small></div></div>
</main>

<?php
$EXTRA_JS = <<<JS
document.querySelectorAll("#gtabs button").forEach(b=>b.onclick=()=>{
 document.querySelectorAll("#gtabs button").forEach(x=>x.setAttribute("aria-selected",x===b));
 const f=b.dataset.f;
 document.querySelectorAll("#gal .shot").forEach(s=>s.classList.toggle("hide", f!=="all" && s.dataset.cat!==f));
});

// خفن‌ترش کن: افکت درخشش روی هاور + کلیک برای بزرگ‌نمایی (لایت‌باکس)
document.querySelectorAll("#gal .shot").forEach(s=>{
 s.insertAdjacentHTML("beforeend", '<i class="shine"></i><span class="zoomico"><svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="#fff" stroke-width="2"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3M11 8v6M8 11h6"/></svg></span>');
 s.onclick=()=>{
  const title=s.querySelector("span:not(.zoomico)")?.textContent||"";
  const sub=s.querySelector("small")?.textContent||"";
  const lb=document.getElementById("lightbox"), card=document.getElementById("lbcard");
  card.className="lbcard "+[...s.classList].find(c=>c.startsWith("c"));
  document.getElementById("lbtitle").textContent=title;
  document.getElementById("lbsub").textContent=sub;
  lb.classList.add("on");
 };
});
const closeLb=()=>document.getElementById("lightbox").classList.remove("on");
document.getElementById("lbclose").onclick=closeLb;
document.getElementById("lightbox").onclick=e=>{ if(e.target.id==="lightbox") closeLb(); };
document.addEventListener("keydown",e=>{ if(e.key==="Escape") closeLb(); });
JS;
require __DIR__.'/inc/foot.php';
?>
</body>
</html>
