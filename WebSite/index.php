<?php require __DIR__."/lib.php"; $ST=site_stats(); $N=$ST['citizens']; $SC=$ST['staffCount']; $GC=$ST['gangCount']; $LIVE=is_live(); ?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>یونیک رول پلی | سرور رول پلی ایرانی GTA V</title>
<meta name="description" content="Unique RP؛ سرور رول‌پلی فارسی‌زبان روی VMP. بدون نیاز به استیم.">
<meta name="theme-color" content="#05070d">
<meta property="og:title" content="یونیک رول پلی | سرور رول پلی ایرانی GTA V">
<meta property="og:description" content="یه زندگی دوم برات شروع می‌شه؛ شغل انتخاب کن، گنگ بزن یا طرف قانون وایسا.">
<meta property="og:type" content="website">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpath d='M16 8v28a16 16 0 0 0 32 0V8' fill='none' stroke='%23ffc107' stroke-width='11' stroke-linecap='round'/%3E%3C/svg%3E">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;500;600;700;800;900&display=swap">
<link rel="stylesheet" href="style.css">
<style>
/* صفحه‌ی اصلی: فقط استایل‌های اختصاصیِ هیرو، راهنما، برترین‌ها، عضوگیری و دپارتمان — بقیه در style.css مشترکه */
.hero{position:relative;min-height:100vh;display:grid;place-items:center;text-align:center;padding:130px 0 150px;background:radial-gradient(ellipse 70% 55% at 50% -5%,#123a8a55 0,transparent 60%),var(--bg);overflow:hidden}
.orb{position:absolute;border-radius:50%;filter:blur(70px);pointer-events:none;opacity:.55;will-change:transform}
.orb1{width:420px;height:420px;top:-120px;left:-80px;background:radial-gradient(circle,#00e5ff55,transparent 70%);animation:drift1 16s ease-in-out infinite}
.orb2{width:380px;height:380px;top:0;right:-100px;background:radial-gradient(circle,#8b6bff4d,transparent 70%);animation:drift2 19s ease-in-out infinite}
.orb3{width:300px;height:300px;bottom:-60px;left:38%;background:radial-gradient(circle,#ffc10733,transparent 70%);animation:drift1 13s ease-in-out infinite reverse}
@keyframes drift1{0%,100%{transform:translate(0,0)}50%{transform:translate(30px,25px)}}
@keyframes drift2{0%,100%{transform:translate(0,0)}50%{transform:translate(-25px,30px)}}
.stars{position:absolute;inset:0;background-image:radial-gradient(1.5px 1.5px at 20% 30%,#fff9,transparent),radial-gradient(1px 1px at 70% 20%,#fff8,transparent),radial-gradient(1.5px 1.5px at 85% 55%,#fff7,transparent),radial-gradient(1px 1px at 40% 60%,#fff6,transparent),radial-gradient(1px 1px at 10% 70%,#fff6,transparent),radial-gradient(1px 1px at 55% 15%,#fff6,transparent),radial-gradient(1px 1px at 92% 38%,#fff6,transparent);background-size:340px 340px;animation:tw 6s ease-in-out infinite alternate}
@keyframes tw{from{opacity:.65}to{opacity:1}}
.moon{position:absolute;top:9%;left:9%;width:150px;height:150px;border-radius:50%;background:radial-gradient(circle at 35% 35%,#bcd8ff77,#2f5bb022 70%,transparent);box-shadow:0 0 90px #4f8cff3d;animation:float 7s ease-in-out infinite}
@keyframes float{0%,100%{transform:translateY(0)}50%{transform:translateY(-16px)}}
.city{position:absolute;bottom:0;width:100%;height:210px;opacity:.9}
.hero .in{position:relative}
.badge{display:inline-flex;align-items:center;gap:8px;border:1px solid #00e5ff4d;color:var(--cyan);padding:5px 18px;border-radius:99px;background:#00e5ff12;font-size:.82rem;letter-spacing:.05em;direction:ltr;backdrop-filter:blur(6px)}
.badge::before{content:"";width:7px;height:7px;border-radius:50%;background:#3ddc84;box-shadow:0 0 8px #3ddc84;animation:pulse 1.8s ease-in-out infinite}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.35}}
.live-pill{display:inline-flex;align-items:center;gap:8px;margin-top:16px;padding:7px 20px;border-radius:99px;border:1px solid #3ddc8455;background:#3ddc8414;font-size:.85rem;color:#c9ffe4;backdrop-filter:blur(6px)}
.live-pill b{color:#3ddc84;font-size:1rem}
.live-pill .dot.on{width:8px;height:8px;border-radius:50%;background:#3ddc84;box-shadow:0 0 8px #3ddc84;animation:pulse 1.8s ease-in-out infinite}
.hero h1{font-size:clamp(2.4rem,7vw,4.9rem);font-weight:900;line-height:1.35;margin:22px 0 14px;letter-spacing:-.02em}
.hero h1 em{font-style:normal;background:linear-gradient(135deg,var(--gold),var(--gold2));-webkit-background-clip:text;background-clip:text;color:transparent}
.hero p{color:#c1cdea;max-width:56ch;margin:0 auto 30px;font-size:1.05rem}
.cta{display:flex;gap:14px;justify-content:center;flex-wrap:wrap}
.stats{display:grid;grid-template-columns:repeat(3,1fr);margin:42px auto 0;width:min(520px,100%);background:#0a1224d9;border:1px solid var(--line2);border-radius:var(--r);backdrop-filter:blur(12px);box-shadow:var(--shadow-lg)}
.stats div{padding:18px 8px}
.stats div+div{border-inline-start:1px solid var(--line2)}
.stats b{display:block;font-size:1.75rem;background:linear-gradient(135deg,var(--cyan),#a7e9ff);-webkit-background-clip:text;background-clip:text;color:transparent}
.stats span{color:var(--mut);font-size:.78rem}
.scrolldown{position:absolute;bottom:30px;left:50%;transform:translateX(-50%);display:flex;flex-direction:column;align-items:center;gap:6px;color:var(--mut2);font-size:.72rem;letter-spacing:.1em;animation:bob 2.4s ease-in-out infinite}
.scrolldown svg{width:16px;height:16px}
@keyframes bob{0%,100%{transform:translate(-50%,0)}50%{transform:translate(-50%,6px)}}
.steps{margin-top:36px;display:grid;gap:0;max-width:640px;position:relative}
.step{display:flex;gap:18px;align-items:flex-start;padding-bottom:26px;position:relative}
.step::before{content:"";position:absolute;top:46px;bottom:0;insetInlineStart:21px;width:2px;background:linear-gradient(var(--line2),transparent)}
.step:last-child::before{display:none}
.step i{flex:none;width:44px;height:44px;border-radius:13px;display:grid;place-items:center;background:linear-gradient(160deg,var(--cyan2),#123f7a);font-style:normal;font-weight:900;box-shadow:0 8px 22px #175d9455;z-index:1;color:#fff}
.step h3{font-size:1.06rem;line-height:1.6}
.step p{color:var(--mut);font-size:.9rem;margin-top:2px}
.guide{display:grid;grid-template-columns:1.05fr .95fr;gap:48px;align-items:center}
.note{background:linear-gradient(165deg,var(--panel),#0a1122);border:1px solid var(--line2);border-radius:var(--r-lg);padding:32px;box-shadow:var(--shadow)}
.note h3{color:var(--cyan);display:flex;align-items:center;gap:10px;font-size:1.1rem}
.note code{direction:ltr;display:flex;align-items:center;justify-content:space-between;gap:10px;margin-top:16px;background:#04070f;border-radius:10px;padding:13px 16px;color:var(--gold);font-size:.9rem;text-align:left;border:1px solid var(--line2)}
.note code button{border:0;background:#ffffff10;color:var(--mut);border-radius:7px;padding:4px 10px;font-size:.72rem;cursor:pointer;font-family:inherit}
.note code button:hover{color:var(--cyan)}
.dept{display:flex;justify-content:space-between;align-items:center}
.dept b{direction:ltr}
.dot{width:10px;height:10px;border-radius:50%;background:#ff6b6b}
.dot.on{background:#3ddc84;box-shadow:0 0 10px #3ddc84;animation:pulse 1.8s ease-in-out infinite}
.dept small{color:var(--mut)}
@media(max-width:800px){.guide{grid-template-columns:1fr}.moon{width:90px;height:90px}}
</style>
</head>
<body>
<div id="prog"></div>
<header><div class="wrap"><nav>
 <a href="#home" class="logo" id="brand"></a>
 <div class="links" id="links">
  <a href="#home">خانه</a><a href="#guide">راهنما</a><a href="#top">برترین‌ها</a><a href="#join">عضوگیری</a><a href="#dept">دپارتمان</a><a href="gallery.php">گالری</a><a href="rules.php">قوانین</a><a href="team.php">کادر مدیریت</a>
 </div>
 <button class="btn" id="burger" aria-label="منو" aria-expanded="false">☰</button>
 <a class="btn pri" href="<?=me()?"dashboard.php":"auth.php"?>">ورود به داشبورد</a>
</nav></div></header>

<main>
<section class="hero" id="home">
 <div class="orb orb1"></div><div class="orb orb2"></div><div class="orb orb3"></div>
 <div class="stars"></div><div class="moon"></div>
 <svg class="city" viewBox="0 0 1200 190" preserveAspectRatio="none" aria-hidden="true"><path fill="#0b1630" d="M0 190V120h60V80h50v50h40V60h60v70h50V100h70v30h60V50h55v80h50V90h60v40h70V70h60v60h50V95h70v35h60V40h50v90h60V85h60v45h70V110h60v80z"/><path fill="#070b16" d="M0 190v-40h90v-25h70v25h120v-35h80v35h140v-20h90v20h160v-30h100v30h150v-25h90v25h110z"/></svg>
 <div class="wrap in">
  <span class="badge">GTA V ROLEPLAY · VMP</span>
  <div id="live-pill" class="live-pill" hidden><span class="dot on"></span><b id="live-count">–</b><span>/</span><span id="live-max">–</span><span> آنلاین همین الان</span></div>
  <h1>به شهرِ <em data-name>یونیک</em> خوش اومدی</h1>
  <p>یه زندگی دوم برات شروع می‌شه؛ شغل انتخاب کن، گنگ بزن یا طرف قانون وایسا و اسم و رسم خودتو بین شهروندای شهر بساز. بدون نیاز به خرید نسخه‌ی اصلی بازی.</p>
  <div class="cta">
   <a class="btn pri" href="<?=me()?"dashboard.php":"auth.php?m=reg"?>">ثبت‌نام و ورود به شهر</a>
   <a class="btn" data-discord href="#"><svg viewBox="0 0 24 24" fill="currentColor"><path d="M20.3 5.4a17 17 0 0 0-4.3-1.3l-.2.4a15 15 0 0 1 3.8 1.4 16 16 0 0 0-14.9 0 15 15 0 0 1 3.9-1.4l-.2-.4A17 17 0 0 0 4 5.4C1.8 8.6 1.2 11.8 1.5 14.9a17 17 0 0 0 5 2.5l1-1.6a11 11 0 0 1-1.7-.8c.1-.1.3-.2.4-.3a12 12 0 0 0 10.6 0l.4.3a11 11 0 0 1-1.7.8l1 1.6a17 17 0 0 0 5-2.5c.4-3.6-.5-6.7-2.2-9.5ZM8.7 13c-.7 0-1.3-.7-1.3-1.5S8 10 8.7 10s1.3.7 1.3 1.5S9.4 13 8.7 13Zm6.6 0c-.7 0-1.3-.7-1.3-1.5s.6-1.5 1.3-1.5 1.3.7 1.3 1.5-.6 1.5-1.3 1.5Z"/></svg>دیسکورد ما</a>
  </div>
  <div class="stats"><div><b><?=$N?></b><span>شهروند ثبت‌نام‌شده</span></div><div><b><?=$SC?></b><span>عضو کادر</span></div><div><b><?=$GC?></b><span>گنگ فعال</span></div></div>
 </div>
 <div class="scrolldown"><span>اسکرول کن</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 4v15M6 13l6 6 6-6"/></svg></div>
</section>

<section id="guide"><div class="wrap guide rv">
 <div>
  <div class="eyebrow">راهنما</div>
  <h2>چطور شهروند بشیم</h2>
  <p class="sub">چهار قدم ساده تا رسیدن به اولین شب رول‌پلی تو خیابون‌ها.</p>
  <div class="steps">
   <div class="step"><i>1</i><div><h3>دانلود و نصب VMP</h3><p>کلاینت VMP رو از سایت رسمی‌ش دانلود و نصب کن.</p></div></div>
   <div class="step"><i>2</i><div><h3>اتصال به سرور</h3><p>از لیست سرورها، <span data-name>یونیک</span> رو پیدا کن و وارد شو.</p></div></div>
   <div class="step"><i>3</i><div><h3>ساخت شناسنامه‌ی شهروندی</h3><p>اسم، سن و پیش‌زمینه‌ی شخصیتت رو کامل کن تا وارد شهر بشی.</p></div></div>
   <div class="step"><i>4</i><div><h3>انتخاب مسیر زندگی</h3><p>شغل بگیر، به یه گنگ بپیوند یا به دپارتمان‌های رسمی درخواست بده.</p></div></div>
  </div>
 </div>
 <div class="note">
  <h3><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20"><path d="M13 2 3 14h7l-1 8 10-12h-7l1-8Z"/></svg>ما روی VMP هستیم</h3>
  <p class="sub">برای ورود لازم نیست IRFive نصب کنی. کلاینت VMP کافیه و نیازی به استیم هم نیست.</p>
  <code><span>connect → <span data-name>Unique</span> RP</span><button type="button" onclick="navigator.clipboard&&navigator.clipboard.writeText(this.parentElement.firstElementChild.textContent)">کپی</button></code>
 </div>
</div></section>

<section id="why" style="background:var(--bg2)"><div class="wrap rv">
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

<section id="top"><div class="wrap rv">
 <div class="eyebrow">برترین‌ها</div>
 <h2>تالار افتخار شهر</h2>
 <p class="sub">بهترین‌های شهر در هر دسته؛ شاید نفر بعدی تو باشی.</p>
 <div class="tabs" role="tablist" id="tabs"></div>
 <div class="podium" id="podium"></div>
 <div class="list" id="list"></div>
</div></section>

<section id="join" style="background:var(--bg2)"><div class="wrap rv">
 <div class="eyebrow">عضوگیری</div>
 <h2>آگهی‌های عضوگیری</h2>
 <p class="sub">فرصت‌های عضویت در گنگ‌های مختلف شهر.</p>
 <div class="grid" id="gangs"></div>
</div></section>

<section id="dept"><div class="wrap rv">
 <div class="eyebrow">دپارتمان</div>
 <h2>دپارتمان‌های شهر</h2>
 <p class="sub">وضعیت لحظه‌ای دپارتمان‌های رسمی و تعداد نیروهای آنلاین.</p>
 <div class="grid" id="depts"></div>
</div></section>
</main>

<button id="totop" aria-label="برو به بالا" onclick="scrollTo({top:0,behavior:'smooth'})"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 19V5M6 11l6-6 6 6"/></svg></button>

<footer><div class="wrap">
 <div class="fg">
  <div>
   <div class="logo" id="flogo"></div>
   <p class="sub">یه شهر کامل برای زندگی دوم تو؛ رول‌پلی جدی، قانون واقعی و کامیونیتی همیشه‌فعال.</p>
   <div class="social"><a data-discord href="#" aria-label="دیسکورد"><svg viewBox="0 0 24 24" fill="currentColor"><path d="M20.3 5.4a17 17 0 0 0-4.3-1.3l-.2.4a15 15 0 0 1 3.8 1.4 16 16 0 0 0-14.9 0 15 15 0 0 1 3.9-1.4l-.2-.4A17 17 0 0 0 4 5.4C1.8 8.6 1.2 11.8 1.5 14.9a17 17 0 0 0 5 2.5l1-1.6a11 11 0 0 1-1.7-.8c.1-.1.3-.2.4-.3a12 12 0 0 0 10.6 0l.4.3a11 11 0 0 1-1.7.8l1 1.6a17 17 0 0 0 5-2.5c.4-3.6-.5-6.7-2.2-9.5ZM8.7 13c-.7 0-1.3-.7-1.3-1.5S8 10 8.7 10s1.3.7 1.3 1.5S9.4 13 8.7 13Zm6.6 0c-.7 0-1.3-.7-1.3-1.5s.6-1.5 1.3-1.5 1.3.7 1.3 1.5-.6 1.5-1.3 1.5Z"/></svg></a></div>
  </div>
  <div><h4>دسترسی سریع</h4><ul><li><a href="#home">خانه</a></li><li><a href="#guide">راهنما</a></li><li><a href="#top">برترین‌ها</a></li><li><a href="#dept">دپارتمان</a></li></ul></div>
  <div><h4>سرور</h4><ul><li><a href="gallery.php">گالری</a></li><li><a href="rules.php">قوانین</a></li><li><a href="team.php">درباره ما</a></li><li><a href="#join">عضوگیری</a></li></ul></div>
  <div><h4>ارتباط با ما</h4><ul><li><a data-discord href="#">دیسکورد</a></li><li><a data-panel href="#">پنل کاربری</a></li><li><a data-discord href="#">پشتیبانی و تیکت</a></li></ul></div>
 </div>
 <div class="copy"><span>© 2026 <span data-brand>Unique RP</span> — تمامی حقوق محفوظ است</span><span>Powered by VMP</span></div>
</div></footer>

<script>
<?php
$J=JSON_UNESCAPED_UNICODE|JSON_HEX_TAG|JSON_HEX_AMP;
?>
const CFG=<?=json_encode(['name'=>CFG['name'],'fa'=>CFG['fa'],'discord'=>CFG['discord'],'panel'=>'dashboard.php','cfxcode'=>CFG['cfxcode'],'live'=>$LIVE],$J)?>;
const TOP=<?=json_encode($ST['top'],$J)?>;
const GANGS=<?=json_encode($ST['gangs'],$J)?>;
const DEPTS=<?=json_encode($ST['depts'],$J)?>;

const $=s=>document.querySelector(s), esc=t=>String(t).replace(/[&<>"]/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;"}[c]));
const mark='<svg viewBox="0 0 64 64"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffe08a"/><stop offset="1" stop-color="#d18f00"/></linearGradient></defs><path d="M16 8v28a16 16 0 0 0 32 0V8" fill="none" stroke="url(#g)" stroke-width="11" stroke-linecap="round"/></svg>';
const [w1,...w2]=CFG.name.split(" ");
$("#brand").innerHTML=mark+"<span>"+esc(w1)+" <b>"+esc(w2.join(" "))+"</b></span>";
$("#flogo").innerHTML=$("#brand").innerHTML;
document.querySelectorAll("[data-name]").forEach(e=>e.textContent=CFG.fa);
document.querySelectorAll("[data-brand]").forEach(e=>e.textContent=CFG.name);
document.querySelectorAll("[data-discord]").forEach(e=>{e.href=CFG.discord;e.target="_blank";e.rel="noopener"});
document.querySelectorAll("[data-panel]").forEach(e=>e.href=CFG.panel);
document.title=CFG.fa+" رول پلی | سرور رول پلی ایرانی";

if(CFG.cfxcode){
 fetch(`https://servers-frontend.fivem.net/api/servers/single/${CFG.cfxcode}`).then(r=>r.json()).then(d=>{
  const s=d&&d.Data; if(!s) return;
  $("#live-count").textContent=s.clients??0;
  $("#live-max").textContent=s.svMaxclients??"?";
  $("#live-pill").hidden=false;
 }).catch(()=>{});
}

$("#burger").onclick=e=>{const o=$("#links").classList.toggle("open");e.currentTarget.setAttribute("aria-expanded",o)};
$("#links").onclick=()=>$("#links").classList.remove("open");

addEventListener("scroll",()=>{
 const h=document.querySelector("header");
 h.classList.toggle("scrolled",scrollY>10);
 const doc=document.documentElement;
 const p=(scrollY/(doc.scrollHeight-doc.clientHeight))*100;
 $("#prog").style.width=Math.min(100,Math.max(0,p))+"%";
 $("#totop").classList.toggle("show",scrollY>700);
},{passive:true});

if("IntersectionObserver" in window){
 const io=new IntersectionObserver(es=>es.forEach(en=>{if(en.isIntersecting){en.target.classList.add("in");io.unobserve(en.target)}}),{threshold:.12,rootMargin:"0px 0px -60px 0px"});
 document.querySelectorAll(".rv").forEach(el=>io.observe(el));
}else document.querySelectorAll(".rv").forEach(el=>el.classList.add("in"));

if(matchMedia("(pointer:fine)").matches && !matchMedia("(prefers-reduced-motion: reduce)").matches){
 const hero=$(".hero");
 hero&&hero.addEventListener("mousemove",e=>{
  const x=(e.clientX/innerWidth-.5)*18, y=(e.clientY/innerHeight-.5)*18;
  document.querySelectorAll(".orb").forEach((o,i)=>{const f=(i+1)*.6;o.style.transform=`translate(${x*f}px,${y*f}px)`});
 },{passive:true});
}

function show(k){
 const d=TOP[k],ord=[d[2],d[0],d[1]],rk=[3,1,2];
 $("#podium").innerHTML=ord.map((p,i)=>`<div class="pod ${rk[i]==1?"first":""}"><div class="av">${esc(p[0][0])}</div><div class="rk">#${rk[i]}</div><h3>${esc(p[0])}</h3><small>${esc(p[1])}</small></div>`).join("");
 $("#list").innerHTML=d.slice(3).map((p,i)=>`<div class="row"><span class="rk">#${i+4}</span><span class="n">${esc(p[0])}</span><small>${esc(p[1])}</small></div>`).join("");
 document.querySelectorAll("#tabs button").forEach(b=>b.setAttribute("aria-selected",b.textContent==k));
}
$("#tabs").innerHTML=Object.keys(TOP).map(k=>`<button role="tab">${k}</button>`).join("");
$("#tabs").onclick=e=>{if(e.target.matches("button"))show(e.target.textContent)};
show(Object.keys(TOP)[0]);

$("#gangs").innerHTML=GANGS.map(g=>`<div class="card rec"><div class="av">${esc(g[0][0])}</div><h3>${esc(g[0])}</h3><span class="lv">${g[1]}</span><button class="btn" ${g[2]?"":"disabled"}>${g[2]?"درخواست عضویت":"عضویت بسته است"}</button></div>`).join("");
$("#depts").innerHTML=DEPTS.map(d=>`<div class="card"><div class="dept"><b>${esc(d[0])}</b><span class="dot ${d[3]?"on":""}" title="${d[3]?"OnDuty":"OffDuty"}"></span></div><small style="color:var(--mut)">${d[3]?"آنلاین":"آفلاین"}: ${d[1]} · کل نیروها: ${d[2]}</small></div>`).join("");
</script>
</body>
</html>
