<?php require __DIR__."/lib.php"; $N=(int)db()->query("SELECT COUNT(*) FROM users")->fetchColumn(); $SC=(int)db()->query("SELECT COUNT(*) FROM staff")->fetchColumn(); $GC=(int)db()->query("SELECT COUNT(*) FROM gangs")->fetchColumn(); ?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>یونیک رول پلی | سرور رول پلی ایرانی GTA V</title>
<meta name="description" content="Unique RP؛ سرور رول‌پلی فارسی‌زبان روی VMP. بدون نیاز به استیم.">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpath d='M16 8v28a16 16 0 0 0 32 0V8' fill='none' stroke='%23ffc107' stroke-width='11' stroke-linecap='round'/%3E%3C/svg%3E">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;500;700;900&display=swap">
<style>
:root{--bg:#070b16;--panel:#0e1526;--panel2:#131d33;--line:#1e2b47;--cyan:#00ecff;--gold:#ffc107;--text:#e9effc;--mut:#8b98b5;--r:14px}
*{box-sizing:border-box;margin:0}
html{scroll-behavior:smooth;scroll-padding-top:84px}
body{background:var(--bg);color:var(--text);font-family:Vazirmatn,Tahoma,sans-serif;line-height:1.9;overflow-x:hidden}
a{color:inherit;text-decoration:none}
:focus-visible{outline:2px solid var(--cyan);outline-offset:3px}
.wrap{width:min(1120px,92%);margin-inline:auto}
section{padding:84px 0}
h2{font-size:clamp(1.6rem,4vw,2.4rem);font-weight:900;line-height:1.5}
.sub{color:var(--mut);max-width:60ch;margin-top:6px}
.chip{display:inline-block;padding:2px 14px;border:1px solid var(--line);border-radius:99px;background:var(--panel);color:var(--cyan);font-size:.8rem;margin-bottom:10px}
.btn{display:inline-flex;align-items:center;gap:8px;padding:10px 24px;border-radius:12px;font-weight:700;border:1px solid var(--line);background:var(--panel);cursor:pointer;font:inherit;font-weight:700;color:var(--text);transition:transform .15s}
.btn:hover{transform:translateY(-2px)}
.btn.pri{background:linear-gradient(135deg,#00ecff,#2f8cff);color:#04101f;border:0;box-shadow:0 8px 30px #00ecff33}
/* nav */
header{position:fixed;inset:0 0 auto;z-index:20;background:#070b16d9;backdrop-filter:blur(12px);border-bottom:1px solid var(--line)}
nav{display:flex;align-items:center;gap:22px;height:68px}
.logo{display:flex;align-items:center;gap:10px;font-weight:900;font-size:1.2rem}
.logo svg{width:30px;height:30px}
.logo b{color:var(--gold)}
.links{display:flex;gap:18px;margin-inline-end:auto;color:var(--mut);font-size:.92rem}
.links a:hover{color:var(--text)}
#burger{display:none}
/* hero */
.hero{position:relative;min-height:100vh;display:grid;place-items:center;text-align:center;padding:120px 0 150px;background:radial-gradient(ellipse at 50% 0,#12377a 0,#0a1a3d 45%,var(--bg) 100%);overflow:hidden}
.stars{position:absolute;inset:0;background-image:radial-gradient(1.5px 1.5px at 20% 30%,#fff9,transparent),radial-gradient(1px 1px at 70% 20%,#fff8,transparent),radial-gradient(1.5px 1.5px at 85% 55%,#fff7,transparent),radial-gradient(1px 1px at 40% 60%,#fff6,transparent),radial-gradient(1px 1px at 10% 70%,#fff6,transparent);background-size:300px 300px}
.moon{position:absolute;top:8%;left:9%;width:170px;height:170px;border-radius:50%;background:radial-gradient(circle at 35% 35%,#9fc4ff55,#2f5bb022 70%,transparent);box-shadow:0 0 80px #4f8cff33}
.city{position:absolute;bottom:0;width:100%;height:190px}
.hero .in{position:relative}
.badge{display:inline-block;border:1px solid #00ecff55;color:var(--cyan);padding:2px 18px;border-radius:99px;background:#00ecff14;font-size:.82rem;letter-spacing:.06em;direction:ltr}
.hero h1{font-size:clamp(2.2rem,7vw,4.4rem);font-weight:900;line-height:1.4;margin:18px 0 10px}
.hero h1 em{font-style:normal;color:var(--gold)}
.hero p{color:#b9c6e6;max-width:56ch;margin:0 auto 26px}
.cta{display:flex;gap:12px;justify-content:center;flex-wrap:wrap}
.stats{display:grid;grid-template-columns:repeat(3,1fr);margin:34px auto 0;width:min(460px,100%);background:#0a1224cc;border:1px solid var(--line);border-radius:var(--r)}
.stats div{padding:12px 6px}
.stats div+div{border-inline-start:1px solid var(--line)}
.stats b{display:block;font-size:1.5rem;color:var(--cyan)}
.stats span{color:var(--mut);font-size:.78rem}
/* steps */
.steps{margin-top:34px;display:grid;gap:14px;max-width:640px;position:relative}
.step{display:flex;gap:16px;align-items:flex-start}
.step i{flex:none;width:44px;height:44px;border-radius:12px;display:grid;place-items:center;background:linear-gradient(160deg,#3aa8e8,#175d94);font-style:normal;font-weight:900}
.step h3{font-size:1.05rem;line-height:1.6}
.step p{color:var(--mut);font-size:.9rem}
.guide{display:grid;grid-template-columns:1fr 1fr;gap:40px;align-items:center}
.note{background:var(--panel);border:1px solid var(--line);border-radius:var(--r);padding:26px}
.note code{direction:ltr;display:block;margin-top:12px;background:#060a13;border-radius:8px;padding:10px 14px;color:var(--gold);font-size:.9rem;text-align:left}
/* cards */
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(230px,1fr));gap:16px;margin-top:30px}
.card{background:var(--panel);border:1px solid var(--line);border-radius:var(--r);padding:22px}
.card .ic{width:42px;height:42px;border-radius:10px;background:#00ecff14;border:1px solid #00ecff33;display:grid;place-items:center;font-size:1.2rem;margin-bottom:12px}
.card h3{font-size:1.02rem}
.card p{color:var(--mut);font-size:.88rem;margin-top:4px}
/* tabs + podium */
.tabs{display:inline-flex;gap:4px;padding:4px;margin-top:24px;background:var(--panel);border:1px solid var(--line);border-radius:14px}
.tabs button{border:0;background:none;color:var(--mut);font:inherit;padding:6px 22px;border-radius:10px;cursor:pointer}
.tabs button[aria-selected=true]{background:linear-gradient(135deg,#00ecff,#2f8cff);color:#04101f;font-weight:700}
.podium{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;align-items:end;margin-top:30px}
.pod{text-align:center;background:var(--panel);border:1px solid var(--line);border-radius:var(--r);padding:20px 10px}
.pod.first{border-color:#ffc10766;padding-block:34px;background:linear-gradient(#ffc10714,var(--panel))}
.av{width:68px;height:68px;border-radius:50%;margin:0 auto 8px;display:grid;place-items:center;font-weight:900;font-size:1.5rem;background:#0a1224;border:2px solid var(--gold);color:var(--gold)}
.pod .rk{color:var(--gold);font-weight:900}
.pod small,.row small{color:var(--cyan)}
.list{margin-top:14px;display:grid;gap:8px}
.row{display:flex;align-items:center;gap:14px;padding:10px 16px;background:var(--panel);border:1px solid var(--line);border-radius:12px}
.row .n{margin-inline-end:auto;font-weight:700}
.row .rk{color:var(--mut);width:28px}
/* recruit */
.rec{text-align:center}
.rec .av{width:54px;height:54px;font-size:1.1rem;border-color:var(--line);color:var(--text)}
.rec .lv{display:inline-block;font-size:.75rem;padding:0 12px;border-radius:99px;background:#7a5cff22;border:1px solid #7a5cff66;margin:4px 0 10px;direction:ltr}
.rec .btn{width:100%;justify-content:center;padding:6px;font-size:.85rem;color:var(--cyan)}
.rec .btn[disabled]{color:var(--mut);cursor:not-allowed;transform:none}
/* dept */
.dept{display:flex;justify-content:space-between;align-items:center}
.dept b{direction:ltr}
.dot{width:10px;height:10px;border-radius:50%;background:#ff6b6b}
.dot.on{background:#3ddc84;box-shadow:0 0 10px #3ddc84}
.dept small{color:var(--mut)}
/* gallery */
.gal{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:14px;margin-top:30px}
.shot{aspect-ratio:16/10;border-radius:var(--r);border:1px solid var(--line);position:relative;overflow:hidden;display:flex;align-items:flex-end;padding:12px;font-size:.85rem;color:#fff}
.shot:nth-child(1){background:linear-gradient(200deg,#ff7a45,#5b2a86 55%,#0a1224)}
.shot:nth-child(2){background:linear-gradient(200deg,#00ecff66,#123a7a 55%,#0a1224)}
.shot:nth-child(3){background:linear-gradient(200deg,#ffc107aa,#7a2f1a 55%,#0a1224)}
.shot span{position:relative;text-shadow:0 1px 8px #000}
.live{text-align:center;padding:44px 20px;border:1px dashed var(--line);border-radius:var(--r);margin-top:30px;background:var(--panel)}
footer{border-top:1px solid var(--line);padding:44px 0 26px;background:#060a13}
.fg{display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:30px}
footer h4{font-size:.95rem;border-bottom:2px solid var(--cyan);display:inline-block;margin-bottom:10px}
footer li{list-style:none;color:var(--mut);font-size:.9rem}
footer li a:hover{color:var(--cyan)}
footer ul{padding:0}
.copy{margin-top:30px;padding-top:16px;border-top:1px solid var(--line);color:var(--mut);font-size:.8rem;display:flex;justify-content:space-between;gap:10px;flex-wrap:wrap}
@media(max-width:800px){
 .links{display:none;position:absolute;top:68px;inset-inline:0;flex-direction:column;background:var(--bg);padding:16px 4%;border-bottom:1px solid var(--line)}
 .links.open{display:flex}
 #burger{display:block;margin-inline-end:auto}
 nav .btn.pri{display:none}
 .guide,.fg{grid-template-columns:1fr}
 .podium{grid-template-columns:1fr}
 .moon{width:90px;height:90px}
}
@media(prefers-reduced-motion:reduce){*{transition:none!important;scroll-behavior:auto!important}}
</style>
</head>
<body>
<header><div class="wrap"><nav>
 <a href="#home" class="logo" id="brand"></a>
 <div class="links" id="links">
  <a href="#home">خانه</a><a href="#guide">راهنما</a><a href="#top">برترین‌ها</a><a href="#join">عضوگیری</a><a href="#dept">دپارتمان</a><a href="#gallery">گالری</a><a href="#rules">قوانین</a><a href="#team">کادر مدیریت</a>
 </div>
 <button class="btn" id="burger" aria-label="منو" aria-expanded="false">☰</button>
 <a class="btn pri" href="<?=me()?"dashboard.php":"auth.php"?>">ورود به داشبورد</a>
</nav></div></header>

<main>
<section class="hero" id="home">
 <div class="stars"></div><div class="moon"></div>
 <svg class="city" viewBox="0 0 1200 190" preserveAspectRatio="none" aria-hidden="true"><path fill="#0b1630" d="M0 190V120h60V80h50v50h40V60h60v70h50V100h70v30h60V50h55v80h50V90h60v40h70V70h60v60h50V95h70v35h60V40h50v90h60V85h60v45h70V110h60v80z"/><path fill="#070b16" d="M0 190v-40h90v-25h70v25h120v-35h80v35h140v-20h90v20h160v-30h100v30h150v-25h90v25h110z"/></svg>
 <div class="wrap in">
  <span class="badge">GTA V ROLEPLAY · VMP</span>
  <h1>به شهرِ <em data-name>یونیک</em> خوش اومدی</h1>
  <p>یه زندگی دوم برات شروع می‌شه؛ شغل انتخاب کن، گنگ بزن یا طرف قانون وایسا و اسم و رسم خودتو بین شهروندای شهر بساز. بدون نیاز به خرید نسخه‌ی اصلی بازی.</p>
  <div class="cta"><a class="btn pri" href="<?=me()?"dashboard.php":"auth.php?m=reg"?>">ثبت‌نام و ورود به شهر</a><a class="btn" data-discord href="#">دیسکورد ما</a></div>
  <div class="stats"><div><b><?=$N?></b><span>شهروند ثبت‌نام‌شده</span></div><div><b><?=$SC?></b><span>عضو کادر</span></div><div><b><?=$GC?></b><span>گنگ فعال</span></div></div>
 </div>
</section>

<section id="guide"><div class="wrap guide">
 <div>
  <span class="chip">راهنما</span>
  <h2>چطور شهروند بشیم</h2>
  <p class="sub">چهار قدم ساده تا رسیدن به اولین شب رول‌پلی تو خیابون‌ها.</p>
  <div class="steps">
   <div class="step"><i>1</i><div><h3>دانلود و نصب VMP</h3><p>کلاینت VMP رو از سایت رسمی‌ش دانلود و نصب کن.</p></div></div>
   <div class="step"><i>2</i><div><h3>اتصال به سرور</h3><p>از لیست سرورها، <span data-name>یونیک</span> رو پیدا کن و وارد شو.</p></div></div>
   <div class="step"><i>3</i><div><h3>ساخت شناسنامه‌ی شهروندی</h3><p>اسم، سن و پیش‌زمینه‌ی شخصیتت رو کامل کن تا وارد شهر بشی.</p></div></div>
   <div class="step"><i>4</i><div><h3>انتخاب مسیر زندگی</h3><p>شغل بگیر، به یه گنگ بپیوند یا به دپارتمان‌های رسمی درخواست بده.</p></div></div>
  </div>
 </div>
 <div class="note"><h3>ما روی VMP هستیم</h3><p class="sub">برای ورود لازم نیست IRFive نصب کنی. کلاینت VMP کافیه و نیازی به استیم هم نیست.</p><code>connect → <span data-name>Unique</span> RP</code></div>
</div></section>

<section id="why" style="background:#0a1020"><div class="wrap">
 <span class="chip">چرا <span data-name>یونیک</span>؟</span>
 <h2>شهری که با هر تصمیم تو عوض می‌شه</h2>
 <p class="sub">یه محیط رول‌پلی جدی با اقتصاد پویا، قانون واقعی و شهروندایی که هر شب داستان خودشونو می‌سازن.</p>
 <div class="grid">
  <div class="card"><div class="ic">🎮</div><h3>بدون نیاز به استیم</h3><p>با VMP وارد شو و بدون خرید نسخه‌ی اصلی GTA V بازی کن.</p></div>
  <div class="card"><div class="ic">🖥️</div><h3>دسترسی آسان به سرور</h3><p>سرور رو از لیست انتخاب کن و بدون مراحل پیچیده وارد شهر شو.</p></div>
  <div class="card"><div class="ic">💬</div><h3>کامیونیتی فعال دیسکورد</h3><p>اخبار، رویدادها و اطلاعیه‌های مهم شهر رو دنبال کن.</p></div>
  <div class="card"><div class="ic">🕒</div><h3>پشتیبانی ۲۴ ساعته</h3><p>تیم پشتیبانی از طریق تیکت دیسکورد جواب سوالات و مشکلاتته.</p></div>
 </div>
</div></section>

<section id="top"><div class="wrap">
 <span class="chip">برترین‌ها</span>
 <h2>تالار افتخار شهر</h2>
 <p class="sub">بهترین‌های شهر در هر دسته؛ شاید نفر بعدی تو باشی.</p>
 <div class="tabs" role="tablist" id="tabs"></div>
 <div class="podium" id="podium"></div>
 <div class="list" id="list"></div>
</div></section>

<section id="join" style="background:#0a1020"><div class="wrap">
 <span class="chip">عضوگیری</span>
 <h2>آگهی‌های عضوگیری</h2>
 <p class="sub">فرصت‌های عضویت در گنگ‌های مختلف شهر.</p>
 <div class="grid" id="gangs"></div>
</div></section>

<section id="dept"><div class="wrap">
 <span class="chip">دپارتمان</span>
 <h2>دپارتمان‌های شهر</h2>
 <p class="sub">وضعیت لحظه‌ای دپارتمان‌های رسمی و تعداد نیروهای آنلاین.</p>
 <div class="grid" id="depts"></div>
</div></section>

<section id="gallery" style="background:#0a1020"><div class="wrap">
 <span class="chip">گالری</span>
 <h2>لحظه‌های ثبت‌شده توسط شهروندان</h2>
 <div class="gal"><div class="shot"><span>غروب روی بلوار</span></div><div class="shot"><span>گشت شبانه</span></div><div class="shot"><span>دورهمی گنگ‌ها</span></div></div>
 <div class="live"><h3>پخش زنده</h3><p class="sub" style="margin:6px auto 0">پخش زنده‌ی استریمرها به‌زودی از همین‌جا در دسترس خواهد بود.</p></div>
</div></section>

<section id="rules"><div class="wrap">
 <span class="chip">قوانین</span>
 <h2>قوانین شهر</h2>
 <div class="grid">
  <div class="card"><h3>احترام</h3><p>به همه‌ی شهروندان و کادر احترام بذار. توهین و تبعیض جایی تو شهر نداره.</p></div>
  <div class="card"><h3>رول‌پلی واقعی</h3><p>هر کاری که شخصیتت انجام می‌ده باید با منطق داستان جور باشه؛ VDM و متاگیمینگ ممنوعه.</p></div>
  <div class="card"><h3>تقلب و باگ</h3><p>استفاده از چیت یا سوءاستفاده از باگ به بن دائم می‌رسه. باگ رو به کادر گزارش بده.</p></div>
 </div>
 <p style="margin-top:20px"><a class="btn" data-discord href="#">قوانین کامل در دیسکورد</a></p>
</div></section>

<section id="team" style="background:#0a1020"><div class="wrap">
 <span class="chip">کادر مدیریت</span>
 <h2>کادر مدیریت</h2>
 <p class="sub">با افرادی آشنا شو که تجربه‌ی نقش‌آفرینی شهر رو می‌سازن.</p>
 <div class="grid" id="staff"></div>
</div></section>
</main>

<footer><div class="wrap">
 <div class="fg">
  <div><div class="logo" id="flogo"></div><p class="sub">یه شهر کامل برای زندگی دوم تو؛ رول‌پلی جدی، قانون واقعی و کامیونیتی همیشه‌فعال.</p></div>
  <div><h4>دسترسی سریع</h4><ul><li><a href="#home">خانه</a></li><li><a href="#guide">راهنما</a></li><li><a href="#top">برترین‌ها</a></li><li><a href="#dept">دپارتمان</a></li></ul></div>
  <div><h4>سرور</h4><ul><li><a href="#gallery">پخش زنده</a></li><li><a href="#gallery">گالری</a></li><li><a href="#rules">قوانین</a></li><li><a href="#team">درباره ما</a></li></ul></div>
  <div><h4>ارتباط با ما</h4><ul><li><a data-discord href="#">دیسکورد</a></li><li><a data-panel href="#">پنل کاربری</a></li><li><a data-discord href="#">پشتیبانی و تیکت</a></li></ul></div>
 </div>
 <div class="copy"><span>© 2026 <span data-brand>Unique RP</span> — تمامی حقوق محفوظ است</span><span>Powered by VMP</span></div>
</div></footer>

<script>
<?php
$q=fn($s)=>db()->query($s)->fetchAll(PDO::FETCH_NUM);
$top=[];foreach($q('SELECT cat,name,val FROM top ORDER BY id') as [$c,$n,$v])$top[$c][]=[$n,$v];
$gangs=array_map(fn($r)=>[$r[0],'Level '.$r[1],(int)$r[2]],$q('SELECT name,lvl,open FROM gangs ORDER BY id'));
$depts=array_map(fn($r)=>[$r[0],(int)$r[1],(int)$r[2],(int)$r[3]],$q('SELECT name,online,total,duty FROM depts ORDER BY id'));
$staff=$q('SELECT name,role FROM staff ORDER BY id');
$J=JSON_UNESCAPED_UNICODE|JSON_HEX_TAG|JSON_HEX_AMP;
?>
const CFG=<?=json_encode(['name'=>CFG['name'],'fa'=>CFG['fa'],'discord'=>CFG['discord'],'panel'=>'dashboard.php'],$J)?>;
const TOP=<?=json_encode($top,$J)?>;
const GANGS=<?=json_encode($gangs,$J)?>;
const DEPTS=<?=json_encode($depts,$J)?>;
const STAFF=<?=json_encode($staff,$J)?>;

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

$("#burger").onclick=e=>{const o=$("#links").classList.toggle("open");e.currentTarget.setAttribute("aria-expanded",o)};
$("#links").onclick=()=>$("#links").classList.remove("open");

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
$("#staff").innerHTML=STAFF.map(s=>`<div class="card rec"><div class="av">${esc(s[0][0])}</div><h3>${esc(s[0])}</h3><small style="color:var(--gold)">${esc(s[1])}</small></div>`).join("");
</script>
</body>
</html>
