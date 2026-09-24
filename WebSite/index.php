<?php
require __DIR__."/lib.php"; $ACTIVE='home';
$ST=site_stats(); $N=$ST['citizens']; $SC=$ST['staffCount']; $GC=$ST['gangCount'];
$openGangs=count(array_filter($ST['gangs'],fn($g)=>$g[2])); $onlineForces=array_sum(array_map(fn($d)=>$d[1],$ST['depts']));
$J=JSON_UNESCAPED_UNICODE|JSON_HEX_TAG|JSON_HEX_AMP;
?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>یونیک رول پلی | سرور رول پلی ایرانی GTA V</title>
<meta name="description" content="Unique RP؛ سرور رول‌پلی فارسی‌زبان روی VMP. بدون نیاز به استیم.">
<meta name="theme-color" content="#050505">
<meta property="og:title" content="یونیک رول پلی | سرور رول پلی ایرانی GTA V">
<meta property="og:description" content="یه زندگی دوم برات شروع می‌شه؛ شغل انتخاب کن، گنگ بزن یا طرف قانون وایسا.">
<meta property="og:type" content="website">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpath d='M16 8v28a16 16 0 0 0 32 0V8' fill='none' stroke='%23ffc107' stroke-width='11' stroke-linecap='round'/%3E%3C/svg%3E">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;500;600;700;800;900&display=swap">
<link rel="stylesheet" href="style.css">
<style>
/* ===== هیرو ===== */
.hero{position:relative;min-height:100vh;display:grid;place-items:center;text-align:center;padding:140px 0 170px;overflow:hidden;background:radial-gradient(ellipse 80% 60% at 50% -10%,#b8860b66,transparent 62%),radial-gradient(ellipse 50% 40% at 85% 30%,#e6a40026,transparent 70%),var(--bg)}
.hero::before{content:"";position:absolute;inset:0;background-image:linear-gradient(rgba(255,255,255,.04) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.04) 1px,transparent 1px);background-size:60px 60px;-webkit-mask:radial-gradient(ellipse 60% 70% at 50% 30%,#000,transparent 75%);mask:radial-gradient(ellipse 60% 70% at 50% 30%,#000,transparent 75%)}
.orb{position:absolute;border-radius:50%;filter:blur(80px);pointer-events:none;opacity:.6;will-change:transform;transition:transform .4s ease-out}
.orb1{width:460px;height:460px;top:-140px;left:-90px;background:radial-gradient(circle,#ffc10755,transparent 70%);animation:drift1 16s ease-in-out infinite}
.orb2{width:420px;height:420px;top:0;right:-110px;background:radial-gradient(circle,#e6a40055,transparent 70%);animation:drift2 19s ease-in-out infinite}
.orb3{width:340px;height:340px;bottom:40px;left:36%;background:radial-gradient(circle,#ffc10730,transparent 70%);animation:drift1 13s ease-in-out infinite reverse}
@keyframes drift1{0%,100%{transform:translate(0,0)}50%{transform:translate(34px,28px)}}
@keyframes drift2{0%,100%{transform:translate(0,0)}50%{transform:translate(-28px,34px)}}
.stars{position:absolute;inset:0;background-image:radial-gradient(1.5px 1.5px at 20% 30%,#fff9,transparent),radial-gradient(1px 1px at 70% 20%,#fff8,transparent),radial-gradient(1.5px 1.5px at 85% 55%,#fff7,transparent),radial-gradient(1px 1px at 40% 60%,#fff6,transparent),radial-gradient(1px 1px at 10% 70%,#fff6,transparent),radial-gradient(1px 1px at 55% 15%,#fff6,transparent),radial-gradient(1px 1px at 92% 38%,#fff6,transparent);background-size:340px 340px;animation:tw 6s ease-in-out infinite alternate}
@keyframes tw{from{opacity:.55}to{opacity:1}}
.moon{position:absolute;top:11%;left:9%;width:130px;height:130px;border-radius:50%;background:radial-gradient(circle at 35% 35%,#fff4d0cc,#ffc10744 55%,transparent 72%);box-shadow:0 0 120px #ffc10755;animation:float 7s ease-in-out infinite}
@keyframes float{0%,100%{transform:translateY(0)}50%{transform:translateY(-16px)}}
.city{position:absolute;bottom:0;width:100%;height:210px}
.road{position:absolute;bottom:26px;inset-inline:0;height:4px;z-index:2}
.car{position:absolute;top:0;height:3px;width:110px;border-radius:9px;animation:drive 8s linear infinite}
.car.r{background:linear-gradient(270deg,transparent,#fff,#ff4d4d);box-shadow:0 0 16px #ff4d4d}
.car.y{background:linear-gradient(90deg,transparent,#fff,#ffe08a);box-shadow:0 0 16px #ffc107;animation-direction:reverse;animation-duration:11s;top:6px}
@keyframes drive{from{left:-130px}to{left:100%}}
.hero .in{position:relative;z-index:3}
.badge{display:inline-flex;align-items:center;gap:8px;border:1px solid #ffc1074d;color:var(--cyan);padding:6px 20px;border-radius:99px;background:#ffc10712;font-size:.8rem;letter-spacing:.12em;direction:ltr;backdrop-filter:blur(8px);animation:rise .8s var(--ease) both}
.badge::before{content:"";width:7px;height:7px;border-radius:50%;background:#3ddc84;box-shadow:0 0 8px #3ddc84;animation:pulse 1.8s ease-in-out infinite}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.35}}
.live-pill{display:inline-flex;align-items:center;gap:8px;margin:16px 8px 0;padding:7px 20px;border-radius:99px;border:1px solid #3ddc8455;background:#3ddc8414;font-size:.85rem;color:#c9ffe4;backdrop-filter:blur(8px)}
.live-pill[hidden]{display:none}
.live-pill b{color:#3ddc84;font-size:1rem}
.live-pill .dot{width:8px;height:8px;border-radius:50%;background:#3ddc84;box-shadow:0 0 8px #3ddc84;animation:pulse 1.8s ease-in-out infinite}
.hero h1{font-size:clamp(2.6rem,8vw,6rem);font-weight:900;line-height:1.2;margin:20px 0 16px;letter-spacing:-.03em;animation:rise .9s .1s var(--ease) both}
.hero h1 .l1{display:block;font-size:.42em;font-weight:700;color:#e3dac2;letter-spacing:0;margin-bottom:4px}
.hero h1 .gt{filter:drop-shadow(0 6px 40px #ffc10744)}
.hero p{color:#d6cdb6;max-width:58ch;margin:0 auto 32px;font-size:1.06rem;animation:rise .9s .2s var(--ease) both}
.cta{display:flex;gap:14px;justify-content:center;flex-wrap:wrap;animation:rise .9s .3s var(--ease) both}
.cta .btn{padding:15px 34px;font-size:1.02rem}
.stats{display:grid;grid-template-columns:repeat(3,1fr);margin:48px auto 0;width:min(580px,100%);background:var(--glass);border:1px solid var(--line2);border-radius:var(--r-lg);backdrop-filter:blur(16px);box-shadow:var(--shadow-lg),inset 0 1px 0 #ffffff14;animation:rise .9s .4s var(--ease) both}
.stats div{padding:20px 8px}
.stats div+div{border-inline-start:1px solid var(--line2)}
.stats b{display:block;font-size:2rem;line-height:1.4;background:linear-gradient(135deg,var(--cyan),#fff0b8);-webkit-background-clip:text;background-clip:text;color:transparent}
.stats span{color:var(--mut);font-size:.78rem}
.scrolldown{position:absolute;bottom:52px;left:50%;transform:translateX(-50%);z-index:3;display:flex;flex-direction:column;align-items:center;gap:6px;color:var(--mut2);font-size:.72rem;letter-spacing:.1em;animation:bob 2.4s ease-in-out infinite}
.scrolldown svg{width:16px;height:16px}
@keyframes bob{0%,100%{transform:translate(-50%,0)}50%{transform:translate(-50%,6px)}}
/* ===== نوار متحرک برترین‌ها ===== */
.ticker{position:relative;z-index:4;overflow:hidden;border-block:1px solid var(--line2);background:linear-gradient(90deg,#0b0a07,#15110a,#0b0a07);padding:13px 0;direction:ltr}
.ticker::before,.ticker::after{content:"";position:absolute;top:0;bottom:0;width:90px;z-index:2;pointer-events:none}
.ticker::before{left:0;background:linear-gradient(90deg,var(--bg),transparent)}.ticker::after{right:0;background:linear-gradient(-90deg,var(--bg),transparent)}
.tk{display:flex;width:max-content;animation:marq 38s linear infinite}
.ticker:hover .tk{animation-play-state:paused}
.tk span{display:inline-flex;align-items:center;gap:9px;padding:0 28px;font-size:.88rem;color:var(--mut);white-space:nowrap;border-right:1px solid var(--line2)}
.tk b{color:var(--text)}.tk em{font-style:normal;color:var(--gold)}.tk i{font-style:normal;color:var(--cyan);font-size:.75rem}
@keyframes marq{to{transform:translateX(-50%)}}
/* ===== رنک ===== */
#top{background:radial-gradient(ellipse 60% 50% at 50% 0,#ffc10714,transparent 70%)}
.center{text-align:center}.center .eyebrow{justify-content:center}.center .eyebrow::before{display:none}.center .sub{margin-inline:auto}
.center .tabs{margin-inline:auto}
.rankwrap{max-width:860px;margin-inline:auto}
.podium{margin-top:44px;gap:18px}
.pod{padding:28px 12px 24px}
.pod .av{width:76px;height:76px;font-size:1.7rem}
.pod.first .av{width:92px;height:92px;font-size:2.1rem}
.pod .val{display:inline-block;margin-top:8px;padding:2px 14px;border-radius:99px;font-size:.78rem;background:#ffffff0d;color:var(--cyan);direction:ltr}
.rk-note{margin-top:18px;color:var(--mut2);font-size:.82rem;text-align:center}
/* ===== راهنما ===== */
.guide{display:grid;grid-template-columns:1.05fr .95fr;gap:52px;align-items:center}
.steps{margin-top:36px;display:grid;max-width:640px}
.step{display:flex;gap:18px;align-items:flex-start;padding-bottom:26px;position:relative}
.step::before{content:"";position:absolute;top:48px;bottom:0;inset-inline-start:21px;width:2px;background:linear-gradient(var(--cyan2),transparent);opacity:.5}
.step:last-child::before{display:none}
.step i{flex:none;width:44px;height:44px;border-radius:14px;display:grid;place-items:center;background:linear-gradient(160deg,var(--cyan),var(--cyan2));font-style:normal;font-weight:900;box-shadow:0 8px 26px #ffc10744;z-index:1;color:#1a1200}
.step h3{font-size:1.06rem;line-height:1.6}.step p{color:var(--mut);font-size:.9rem;margin-top:2px}
.note{background:linear-gradient(165deg,var(--panel),#0a0906);border:1px solid var(--line2);border-radius:var(--r-lg);padding:34px;box-shadow:var(--shadow);position:relative;overflow:hidden}
.note::before{content:"";position:absolute;top:-80px;left:-80px;width:220px;height:220px;background:radial-gradient(circle,#ffc1072e,transparent 70%)}
.note h3{color:var(--cyan);display:flex;align-items:center;gap:10px;font-size:1.1rem;position:relative}
.note code{direction:ltr;display:flex;align-items:center;justify-content:space-between;gap:10px;margin-top:18px;background:#030302;border-radius:12px;padding:14px 16px;color:var(--gold);font-size:.92rem;text-align:left;border:1px solid var(--line2);position:relative}
.note code button{border:0;background:#ffffff10;color:var(--mut);border-radius:8px;padding:5px 12px;font-size:.72rem;cursor:pointer;font-family:inherit}
.note code button:hover{color:var(--cyan)}
/* ===== بنر عضوگیری ===== */
.band{position:relative;border-radius:var(--r-lg);padding:54px 44px;overflow:hidden;text-align:center;background:linear-gradient(135deg,#1c1606,#0b0a07 60%,#120e05);border:1px solid #ffc10733;box-shadow:var(--glow)}
.band::before{content:"";position:absolute;inset:-40% -10% auto;height:120%;background:conic-gradient(from 180deg at 50% 0,transparent,#ffc1071a,transparent 30%,#e6a4001a,transparent 60%);animation:sweep 12s linear infinite;pointer-events:none}
@keyframes sweep{to{transform:rotate(360deg)}}
.band>*{position:relative}
.band h2{margin-top:6px}
.band .sub{margin-inline:auto}
.bstats{display:flex;justify-content:center;gap:14px;flex-wrap:wrap;margin:28px 0 30px}
.bstats div{min-width:150px;padding:14px 20px;border-radius:16px;background:#ffffff08;border:1px solid var(--line2)}
.bstats b{display:block;font-size:1.7rem;color:var(--gold);line-height:1.5}
.bstats span{font-size:.8rem;color:var(--mut)}
@media(max-width:800px){.guide{grid-template-columns:1fr}.moon{width:80px;height:80px}.band{padding:38px 20px}.hero{padding-bottom:150px}}
</style>
</head>
<body>
<?php require __DIR__.'/inc/head-nav.php'; ?>

<main>
<section class="hero" id="home">
 <div class="orb orb1"></div><div class="orb orb2"></div><div class="orb orb3"></div>
 <div class="stars"></div><div class="moon"></div>
 <svg class="city" viewBox="0 0 1200 190" preserveAspectRatio="none" aria-hidden="true"><path fill="#17130a" d="M0 190V120h60V80h50v50h40V60h60v70h50V100h70v30h60V50h55v80h50V90h60v40h70V70h60v60h50V95h70v35h60V40h50v90h60V85h60v45h70V110h60v80z"/><path fill="#0a0906" d="M0 190v-40h90v-25h70v25h120v-35h80v35h140v-20h90v20h160v-30h100v30h150v-25h90v25h110z"/></svg>
 <div class="road" aria-hidden="true"><span class="car r"></span><span class="car y" style="animation-delay:-4s"></span><span class="car r" style="animation-delay:-5s;animation-duration:10s"></span></div>
 <div class="wrap in">
  <span class="badge">GTA V ROLEPLAY · VMP</span>
  <div id="live-pill" class="live-pill" hidden><span class="dot"></span><b id="live-count">–</b><span>/</span><span id="live-max">–</span><span> آنلاین همین الان</span></div>
  <h1><span class="l1">به شهرِ</span><span class="gt" data-name>یونیک</span><span class="l1" style="margin:0"> خوش اومدی</span></h1>
  <p>یه زندگی دوم برات شروع می‌شه؛ شغل انتخاب کن، گنگ بزن یا طرف قانون وایسا و اسم و رسم خودتو بین شهروندای شهر بساز. بدون نیاز به خرید نسخه‌ی اصلی بازی.</p>
  <div class="cta">
   <a class="btn pri" href="<?=me()?'dashboard.php':'auth.php'?>">ورود به داشبورد شهروندی</a>
   <a class="btn ghost" data-discord href="#"><svg viewBox="0 0 24 24" fill="currentColor"><path d="M20.3 5.4a17 17 0 0 0-4.3-1.3l-.2.4a15 15 0 0 1 3.8 1.4 16 16 0 0 0-14.9 0 15 15 0 0 1 3.9-1.4l-.2-.4A17 17 0 0 0 4 5.4C1.8 8.6 1.2 11.8 1.5 14.9a17 17 0 0 0 5 2.5l1-1.6a11 11 0 0 1-1.7-.8c.1-.1.3-.2.4-.3a12 12 0 0 0 10.6 0l.4.3a11 11 0 0 1-1.7.8l1 1.6a17 17 0 0 0 5-2.5c.4-3.6-.5-6.7-2.2-9.5ZM8.7 13c-.7 0-1.3-.7-1.3-1.5S8 10 8.7 10s1.3.7 1.3 1.5S9.4 13 8.7 13Zm6.6 0c-.7 0-1.3-.7-1.3-1.5s.6-1.5 1.3-1.5 1.3.7 1.3 1.5-.6 1.5-1.3 1.5Z"/></svg>دیسکورد ما</a>
  </div>
  <div class="stats"><div><b data-n="<?=$N?>"><?=$N?></b><span>شهروند</span></div><div><b data-n="<?=$SC?>"><?=$SC?></b><span>عضو کادر</span></div><div><b data-n="<?=$GC?>"><?=$GC?></b><span>گنگ فعال</span></div></div>
 </div>
 <a class="scrolldown" href="#top"><span>رنک سرور</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 4v15M6 13l6 6 6-6"/></svg></a>
</section>

<div class="ticker" aria-hidden="true"><div class="tk">
<?php for($k=0;$k<2;$k++) foreach($ST['top'] as $cat=>$rows) foreach(array_slice($rows,0,5) as $i=>$r): ?>
 <span><em><?=$i==0?'👑':'#'.($i+1)?></em><i><?=e($cat)?></i><b><?=e($r[0])?></b><?=e($r[1])?></span>
<?php endforeach; ?>
</div></div>

<section id="top"><div class="wrap rv center">
 <div class="eyebrow">رنک سرور</div>
 <h2>تالار افتخار <span class="gt" data-name>یونیک</span></h2>
 <p class="sub">بهترین‌های شهر در هر دسته؛ شاید نفر بعدی تو باشی.</p>
 <div class="tabs" role="tablist" id="tabs"></div>
 <div class="rankwrap">
  <div class="podium" id="podium"></div>
  <div class="list" id="list" style="text-align:start"></div>
  <p class="rk-note">رنک‌ها به‌صورت خودکار از دیتابیس سرور به‌روز می‌شن.</p>
 </div>
</div></section>

<section id="guide" style="background:var(--bg2)"><div class="wrap guide rv">
 <div>
  <div class="eyebrow">راهنما</div>
  <h2>چطور شهروند بشیم</h2>
  <p class="sub">چهار قدم ساده تا رسیدن به اولین شب رول‌پلی تو خیابون‌ها.</p>
  <div class="steps">
   <div class="step"><i>1</i><div><h3>دانلود و نصب VMP</h3><p>کلاینت VMP رو از سایت رسمی‌ش دانلود و نصب کن.</p></div></div>
   <div class="step"><i>2</i><div><h3>اتصال به سرور</h3><p>از لیست سرورها، <span data-name>یونیک</span> رو پیدا کن و وارد شو.</p></div></div>
   <div class="step"><i>3</i><div><h3>ساخت شناسنامه‌ی شهروندی</h3><p>اسم، سن و پیش‌زمینه‌ی شخصیتت رو کامل کن تا وارد شهر بشی.</p></div></div>
   <div class="step"><i>4</i><div><h3>انتخاب مسیر زندگی</h3><p>شغل بگیر، از داشبورد به یه گنگ یا ارگان رسمی درخواست بده و وضعیتشو پیگیری کن.</p></div></div>
  </div>
 </div>
 <div class="note">
  <h3><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20"><path d="M13 2 3 14h7l-1 8 10-12h-7l1-8Z"/></svg>ما روی VMP هستیم</h3>
  <p class="sub" style="position:relative">برای ورود لازم نیست IRFive نصب کنی. کلاینت VMP کافیه و نیازی به استیم هم نیست.</p>
  <code><span>connect → <span data-name>Unique</span> RP</span><button type="button" onclick="navigator.clipboard&&navigator.clipboard.writeText(this.parentElement.firstElementChild.textContent);this.textContent='کپی شد ✓'">کپی</button></code>
 </div>
</div></section>

<section id="why"><div class="wrap rv">
 <div class="eyebrow">چرا <span data-name>یونیک</span>؟</div>
 <h2>شهری که با هر تصمیم تو عوض می‌شه</h2>
 <p class="sub">یه محیط رول‌پلی جدی با اقتصاد پویا، قانون واقعی و شهروندایی که هر شب داستان خودشونو می‌سازن.</p>
 <div class="grid">
  <div class="card"><div class="ictile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="11" rx="4"/><circle cx="8" cy="12.5" r="1.6"/><circle cx="16" cy="12.5" r="1.6"/></svg></div><h3>بدون نیاز به استیم</h3><p>با VMP وارد شو و بدون خرید نسخه‌ی اصلی GTA V بازی کن.</p></div>
  <div class="card"><div class="ictile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="12" rx="2"/><path d="M8 20h8M12 16v4"/></svg></div><h3>دسترسی آسان به سرور</h3><p>سرور رو از لیست انتخاب کن و بدون مراحل پیچیده وارد شهر شو.</p></div>
  <div class="card"><div class="ictile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 11.5a8.4 8.4 0 0 1-8.4 8.4 8.6 8.6 0 0 1-3.8-.9L3 20l1-5.6a8.4 8.4 0 0 1-.9-3.9A8.4 8.4 0 0 1 11.5 2 8.6 8.6 0 0 1 21 11.5Z"/></svg></div><h3>کامیونیتی فعال دیسکورد</h3><p>اخبار، رویدادها و اطلاعیه‌های مهم شهر رو دنبال کن.</p></div>
  <div class="card"><div class="ictile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.5 2"/></svg></div><h3>پشتیبانی ۲۴ ساعته</h3><p>تیم پشتیبانی از طریق تیکت دیسکورد جواب سوالات و مشکلاتته.</p></div>
 </div>
</div></section>

<section style="padding-top:20px"><div class="wrap rv">
 <div class="band">
  <div class="eyebrow" style="justify-content:center">عضوگیری و دپارتمان</div>
  <h2>جایگاهتو تو شهر پیدا کن</h2>
  <p class="sub">گنگ‌ها و ارگان‌های رسمی شهر (Department Of Justice، Law Enforcement و Organ Services) دنبال نیروی جدیدن. همه‌چیز رو تو یه صفحه ببین و از داشبورد درخواست بده.</p>
  <div class="bstats">
   <div><b data-n="<?=$openGangs?>"><?=$openGangs?></b><span>گنگ با عضوگیری باز</span></div>
   <div><b data-n="<?=$onlineForces?>"><?=$onlineForces?></b><span>نیروی آنلاین ارگان‌ها</span></div>
   <div><b data-n="<?=count($ST['depts'])?>"><?=count($ST['depts'])?></b><span>ارگان رسمی</span></div>
  </div>
  <a class="btn gold" href="join.php">مشاهده عضوگیری و ارگان‌ها ←</a>
 </div>
</div></section>
</main>

<?php
$EXTRA_JS = 'const CFX='.json_encode(CFG['cfxcode'],$J).';const TOP='.json_encode($ST['top'],$J).';' . <<<'JS'

if(CFX){
 fetch(`https://servers-frontend.fivem.net/api/servers/single/${CFX}`).then(r=>r.json()).then(d=>{
  const s=d&&d.Data; if(!s) return;
  $("#live-count").textContent=s.clients??0;
  $("#live-max").textContent=s.svMaxclients??"?";
  $("#live-pill").hidden=false;
 }).catch(()=>{});
}
document.title=CFG.fa+" رول پلی | سرور رول پلی ایرانی";

if(matchMedia("(pointer:fine)").matches && !matchMedia("(prefers-reduced-motion: reduce)").matches){
 const hero=$(".hero");
 hero&&hero.addEventListener("mousemove",e=>{
  const x=(e.clientX/innerWidth-.5)*22, y=(e.clientY/innerHeight-.5)*22;
  document.querySelectorAll(".orb").forEach((o,i)=>{const f=(i+1)*.7;o.style.transform=`translate(${x*f}px,${y*f}px)`});
 },{passive:true});
}

/* شمارنده‌ی انیمیشنی */
const cio=new IntersectionObserver(es=>es.forEach(en=>{
 if(!en.isIntersecting) return; cio.unobserve(en.target);
 const el=en.target,to=+el.dataset.n||0,t0=performance.now();
 (function f(t){const p=Math.min(1,(t-t0)/1400);el.textContent=Math.round(to*(1-Math.pow(1-p,3)));if(p<1)requestAnimationFrame(f)})(t0);
}),{threshold:.6});
document.querySelectorAll("[data-n]").forEach(el=>cio.observe(el));

/* رنک سرور */
const num=v=>parseInt(String(v).replace(/[^\d]/g,""))||0;
function show(k){
 const d=(TOP[k]||[]).slice(); while(d.length<3)d.push(["—",""]);
 const ord=[[d[2],3],[d[0],1],[d[1],2]];
 $("#podium").innerHTML=ord.map(([p,r])=>`<div class="pod r${r} ${r==1?"first":""}"><div class="av">${esc(p[0][0])}</div><div class="rk">#${r}</div><h3>${esc(p[0])}</h3><span class="val">${esc(p[1])}</span></div>`).join("");
 const rest=d.slice(3),mx=Math.max(1,...d.map(p=>num(p[1])));
 $("#list").innerHTML=rest.map((p,i)=>`<div class="row"><span class="bar" style="--w:${Math.round(num(p[1])/mx*100)}%"></span><span class="rk">#${i+4}</span><span class="n">${esc(p[0])}</span><small>${esc(p[1])}</small></div>`).join("");
 document.querySelectorAll("#tabs button").forEach(b=>b.setAttribute("aria-selected",b.textContent==k));
}
$("#tabs").innerHTML=Object.keys(TOP).map(k=>`<button role="tab">${esc(k)}</button>`).join("");
$("#tabs").onclick=e=>{if(e.target.matches("button"))show(e.target.textContent)};
show(Object.keys(TOP)[0]);
JS;
require __DIR__.'/inc/foot.php';
?>
</body>
</html>
