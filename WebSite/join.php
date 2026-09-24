<?php
require __DIR__."/lib.php"; $ACTIVE='join'; $ST=site_stats();
$J=JSON_UNESCAPED_UNICODE|JSON_HEX_TAG|JSON_HEX_AMP;
$logged=(bool)me(); $open=count(array_filter($ST['gangs'],fn($g)=>$g[2])); $online=array_sum(array_map(fn($d)=>$d[1],$ST['depts'])); $total=array_sum(array_map(fn($d)=>$d[2],$ST['depts']));
?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>عضوگیری و دپارتمان‌ها | یونیک رول پلی</title>
<meta name="description" content="آگهی‌های عضوگیری گنگ‌ها و وضعیت لحظه‌ای دپارتمان‌های رسمی شهر یونیک؛ همه در یک صفحه.">
<meta name="theme-color" content="#050505">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpath d='M16 8v28a16 16 0 0 0 32 0V8' fill='none' stroke='%23ffc107' stroke-width='11' stroke-linecap='round'/%3E%3C/svg%3E">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;500;600;700;800;900&display=swap">
<link rel="stylesheet" href="style.css">
<style>
.summary{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;max-width:760px;margin:38px auto 0;position:relative}
.summary div{padding:18px 10px;border-radius:var(--r);background:var(--glass);border:1px solid var(--line2);backdrop-filter:blur(14px);box-shadow:inset 0 1px 0 #ffffff12}
.summary b{display:block;font-size:2rem;line-height:1.4;background:linear-gradient(135deg,var(--gold2),var(--gold));-webkit-background-clip:text;background-clip:text;color:transparent}
.summary span{font-size:.8rem;color:var(--mut)}
/* سوییچ */
.switch{position:sticky;top:84px;z-index:20;display:flex;width:min(440px,92%);margin:0 auto;padding:6px;border-radius:18px;background:rgba(16,14,9,.85);backdrop-filter:blur(14px);border:1px solid var(--line2);box-shadow:var(--shadow)}
.switch button{flex:1;position:relative;z-index:1;border:0;background:none;color:var(--mut);font:inherit;font-weight:700;padding:12px 10px;border-radius:13px;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;transition:color .25s}
.switch button svg{width:18px;height:18px}
.switch button[aria-selected=true]{color:#1a1200}
.switch .ind{position:absolute;top:6px;bottom:6px;width:calc(50% - 6px);inset-inline-start:6px;border-radius:13px;background:linear-gradient(135deg,var(--cyan),var(--cyan2));box-shadow:0 8px 26px #ffc10744;transition:transform .45s var(--ease)}
.switch[data-t="d"] .ind{transform:translateX(calc(100% * 1))}
html[dir=rtl] .switch[data-t="d"] .ind{transform:translateX(calc(-100% - 0px))}
.panel2{display:none;animation:rise .6s var(--ease) both}.panel2.on{display:block}
.phead{display:flex;justify-content:space-between;align-items:end;gap:16px;flex-wrap:wrap;margin:50px 0 6px}
.phead p{color:var(--mut);margin-top:4px}
.legend{display:flex;gap:16px;color:var(--mut);font-size:.82rem}
.legend i{display:inline-block;width:9px;height:9px;border-radius:50%;margin-inline-end:6px}
/* گنگ */
.gg{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:18px;margin-top:26px}
.gang{padding:26px 22px 22px;text-align:center}
.gang .av{width:74px;height:74px;font-size:1.6rem;margin-bottom:14px;border-color:#e6a40088;color:#ffe08a;background:radial-gradient(circle at 30% 25%,#e6a40040,#0a0906 70%);box-shadow:0 0 0 5px #e6a40014,0 10px 30px #e6a40030}
.gang.closed .av{border-color:var(--line);color:var(--mut2);background:#0a0906;box-shadow:none}
.gang h3{font-size:1.12rem;letter-spacing:.02em}
.lvbar{direction:ltr;margin:14px 0 6px;height:6px;border-radius:99px;background:#ffffff10;overflow:hidden}
.lvbar i{display:block;height:100%;width:0;border-radius:inherit;background:linear-gradient(90deg,var(--violet),var(--cyan));transition:width 1.2s var(--ease)}
.gang small{display:flex;justify-content:space-between;color:var(--mut);font-size:.78rem;direction:ltr}
.pill{display:inline-flex;align-items:center;gap:7px;margin:14px 0;padding:3px 14px;border-radius:99px;font-size:.78rem;border:1px solid}
.pill::before{content:"";width:7px;height:7px;border-radius:50%;background:currentColor}
.pill.o{color:#3ddc84;border-color:#3ddc8455;background:#3ddc8412}.pill.o::before{box-shadow:0 0 8px #3ddc84;animation:pulse 1.8s infinite}
.pill.c{color:#ff8a8a;border-color:#ff6b6b44;background:#ff6b6b10}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.35}}
.gang .btn{width:100%;justify-content:center;padding:10px;font-size:.88rem}
.gang .btn.go{background:linear-gradient(135deg,var(--gold),#e6a400);color:#241800;border:0;box-shadow:0 8px 24px #ffc10730}
.gang .btn[aria-disabled=true]{opacity:.45;pointer-events:none}
/* دپارتمان */
.dg{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:18px;margin-top:26px}
.dcard{position:relative;overflow:hidden;display:flex;gap:20px;align-items:center;padding:24px;background:linear-gradient(165deg,var(--panel),#0a0906);border:1px solid var(--line2);border-radius:var(--r);transition:transform .28s var(--ease),border-color .28s,box-shadow .28s}
.dcard:hover{transform:translateY(-6px);border-color:#ffc1074d;box-shadow:0 20px 46px -10px #000a}
.ring{flex:none;width:92px;height:92px;border-radius:50%;display:grid;place-items:center;background:conic-gradient(var(--c,var(--cyan)) calc(var(--p,0)*1%),#ffffff12 0);position:relative}
.ring::before{content:"";position:absolute;inset:8px;border-radius:50%;background:#0c0a06}
.ring b{position:relative;font-size:1.35rem;line-height:1}
.ring b small{display:block;font-size:.6rem;color:var(--mut);font-weight:400;margin-top:3px}
.dcard.on{--c:#3ddc84}.dcard.on .ring{filter:drop-shadow(0 0 12px #3ddc8455)}
.dcard h3{font-size:1.04rem;direction:ltr;text-align:right}
.dcard .meta{color:var(--mut);font-size:.83rem;margin-top:4px}
.dcard .pill{margin:10px 0 0;padding:2px 12px;font-size:.72rem}
.help{margin-top:56px;display:grid;grid-template-columns:repeat(3,1fr);gap:18px;text-align:center}
.help .card{padding:24px}
.help i{font-style:normal;display:grid;place-items:center;width:38px;height:38px;margin:0 auto 12px;border-radius:12px;background:linear-gradient(160deg,var(--cyan),var(--cyan2));color:#1a1200;font-weight:900}
.center-cta{text-align:center;margin-top:30px}
.ogrp{margin-top:38px}
.ogh{display:flex;align-items:center;gap:14px;padding:16px 20px;border-radius:var(--r);background:linear-gradient(90deg,#ffc10722,transparent);border:1px solid #ffc10733}
.ogh .ictile{margin:0;flex:none}
.ogh h3{font-size:1.15rem;direction:ltr;text-align:right}.ogh small{color:var(--mut);display:block}
.ogh .tot{margin-inline-start:auto;text-align:center;line-height:1.4}.ogh .tot b{display:block;color:var(--gold);font-size:1.3rem}.ogh .tot span{font-size:.72rem;color:var(--mut)}
.dcard .btn{margin-top:12px;padding:7px 18px;font-size:.82rem}
.dcard .btn.go{background:linear-gradient(135deg,var(--gold),#e6a400);color:#241800;border:0}
@media(max-width:760px){.summary{grid-template-columns:1fr 1fr 1fr;gap:8px}.summary b{font-size:1.5rem}.help{grid-template-columns:1fr}.dcard{flex-direction:column;text-align:center}.dcard h3{text-align:center}.switch{top:76px}}
</style>
</head>
<body>
<?php require __DIR__.'/inc/head-nav.php'; ?>

<main>
<section class="pagehero">
 <div class="orbp a"></div><div class="orbp b"></div>
 <div class="wrap">
  <div class="crumb"><a href="index.php">خانه</a><span>/</span><span>عضوگیری و دپارتمان</span></div>
  <h1>عضوگیری و <span class="gt">ارگان‌ها</span></h1>
  <p>یه گنگ پیدا کن، به ارگان‌های رسمی شهر بپیوند و ببین کدوم نیروها همین الان آنلاین و در حال خدمتن.</p>
  <div class="summary">
   <div><b data-n="<?=$open?>"><?=$open?></b><span>عضوگیری باز</span></div>
   <div><b data-n="<?=$online?>"><?=$online?></b><span>نیروی آنلاین</span></div>
   <div><b data-n="<?=$total?>"><?=$total?></b><span>کل نیروهای ارگان‌ها</span></div>
  </div>
 </div>
</section>

<section style="padding-top:0"><div class="wrap">
 <div class="switch" id="sw" data-t="g" role="tablist">
  <span class="ind"></span>
  <button role="tab" aria-selected="true" data-t="g"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H7a4 4 0 0 0-4 4v2"/><circle cx="10" cy="7" r="4"/><path d="M21 21v-2a4 4 0 0 0-3-3.9M16 3.1a4 4 0 0 1 0 7.8"/></svg>عضوگیری گنگ‌ها</button>
  <button role="tab" aria-selected="false" data-t="d"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2 4 5v6c0 5 3.4 9.4 8 11 4.6-1.6 8-6 8-11V5l-8-3Z"/></svg>ارگان‌ها</button>
 </div>

 <div class="panel2 on" id="pg">
  <div class="phead"><div><div class="eyebrow">عضوگیری</div><h2>آگهی‌های عضوگیری</h2><p>فرصت‌های عضویت در گنگ‌های مختلف شهر.</p></div>
   <div class="legend"><span><i style="background:#3ddc84"></i>عضوگیری باز</span><span><i style="background:#ff6b6b"></i>بسته</span></div></div>
  <div class="gg" id="gangs"></div>
 </div>

 <div class="panel2" id="pd">
  <div class="phead"><div><div class="eyebrow">ارگان‌ها</div><h2>ارگان‌های رسمی شهر</h2><p>وضعیت لحظه‌ای ارگان‌ها و تعداد نیروهای آنلاین؛ برای هر کدوم می‌تونی مستقیم درخواست بدی.</p></div>
   <div class="legend"><span><i style="background:#3ddc84"></i>OnDuty</span><span><i style="background:#ff6b6b"></i>OffDuty</span></div></div>
  <div id="depts"></div>
 </div>

 <div class="help rv">
  <div class="card"><i>1</i><h3>با حساب خودت وارد شو</h3><p>ثبت‌نام از طریق سایت انجام نمی‌شه؛ با حساب شهروندی‌ات وارد داشبورد شو.</p></div>
  <div class="card"><i>2</i><h3>فرم درخواست رو پر کن</h3><p>گنگ یا ارگان مورد نظرت رو انتخاب کن و پیش‌زمینه‌ی کاراکترت رو بنویس.</p></div>
  <div class="card"><i>3</i><h3>نتیجه رو پیگیری کن</h3><p>وضعیت درخواست (در انتظار، پذیرفته یا رد) همون‌جا تو داشبورد نمایش داده می‌شه.</p></div>
 </div>
 <p class="center-cta"><a class="btn gold" href="<?=$logged?'dashboard.php?p=apply':'auth.php'?>"><?=$logged?'ثبت درخواست جدید':'ورود به داشبورد'?></a></p>
</div></section>
</main>

<?php
$EXTRA_JS = 'const LOGGED='.($logged?'true':'false').';const GROUPS='.json_encode(CFG['org_groups'],$J).';const GANGS='.json_encode($ST['gangs'],$J).';const DEPTS='.json_encode($ST['depts'],$J).';' . <<<'JS'

document.title="عضوگیری و دپارتمان‌ها | "+CFG.fa+" رول پلی";
const num=v=>parseInt(String(v).replace(/[^\d]/g,""))||0;
const maxLv=Math.max(30,...GANGS.map(g=>num(g[1])));
const APPLY=(k,t)=>"dashboard.php?p=apply&kind="+k+"&target="+encodeURIComponent(t);
const BTN=LOGGED?"درخواست عضویت":"ورود و درخواست";
$("#gangs").innerHTML=GANGS.map(g=>{
 const lv=num(g[1]),open=!!g[2];
 return `<div class="card gang ${open?"":"closed"}"><div class="av">${esc(g[0][0])}</div><h3>${esc(g[0])}</h3>
 <div class="lvbar"><i data-w="${Math.round(lv/maxLv*100)}"></i></div><small><span>${esc(g[1])}</span><span>Max ${maxLv}</span></small>
 <span class="pill ${open?"o":"c"}">${open?"عضوگیری باز":"عضوگیری بسته"}</span>
 <a class="btn ${open?"go":""}" ${open?`href="${esc(APPLY("gang",g[0]))}"`:'aria-disabled="true"'}>${open?BTN:"فعلاً بسته است"}</a></div>`;
}).join("");
const SH='<path d="M12 2 4 5v6c0 5 3.4 9.4 8 11 4.6-1.6 8-6 8-11V5l-8-3Z"/>';
const GI={doj:'<path d="M12 3v18M5 21h14M6 7h12M6 7l-3 7a3 3 0 0 0 6 0L6 7ZM18 7l-3 7a3 3 0 0 0 6 0l-3-7Z"/>',law:SH,svc:'<path d="M14.7 6.3a4 4 0 0 0-5.4 5.4L3 18l3 3 6.3-6.3a4 4 0 0 0 5.4-5.4l-2.7 2.7-2.3-.7-.7-2.3 2.7-2.7Z"/>'};
$("#depts").innerHTML=Object.keys(GROUPS).map(k=>{
 const L=DEPTS.filter(d=>d[4]===k); if(!L.length) return "";
 const on=L.reduce((a,d)=>a+d[1],0),tot=L.reduce((a,d)=>a+d[2],0);
 return `<div class="ogrp"><div class="ogh"><div class="ictile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${GI[k]||SH}</svg></div>
  <div><h3>${esc(GROUPS[k].label)}</h3><small>${esc(GROUPS[k].fa)} · ${L.length} ارگان</small></div><div class="tot"><b>${on}</b><span>آنلاین از ${tot}</span></div></div>
  <div class="dg">${L.map(d=>{
   const isOn=!!d[3],p=d[2]?Math.round(d[1]/d[2]*100):0;
   return `<div class="dcard ${isOn?"on":""}" style="--p:${Math.max(p,isOn?16:0)}"><div class="ring"><b>${d[1]}<small>آنلاین</small></b></div>
   <div><h3>${esc(d[0])}</h3><div class="meta">کل نیروها: ${d[2]}</div><span class="pill ${isOn?"o":"c"}">${isOn?"OnDuty · در حال خدمت":"OffDuty · آفلاین"}</span><br><a class="btn go" href="${esc(APPLY("org",d[0]))}">${BTN}</a></div></div>`}).join("")}</div></div>`;
}).join("");
const grow=()=>document.querySelectorAll(".lvbar i").forEach(i=>i.style.width=i.dataset.w+"%");
setTimeout(grow,150);

const sw=$("#sw");
function tab(t){
 sw.dataset.t=t; sw.querySelectorAll("button").forEach(b=>b.setAttribute("aria-selected",b.dataset.t===t));
 $("#pg").classList.toggle("on",t==="g"); $("#pd").classList.toggle("on",t==="d");
 history.replaceState(null,"",t==="d"?"#departments":"#gangs"); grow();
}
sw.onclick=e=>{const b=e.target.closest("button");if(b)tab(b.dataset.t)};
if(location.hash==="#departments")tab("d");

const cio=new IntersectionObserver(es=>es.forEach(en=>{
 if(!en.isIntersecting) return; cio.unobserve(en.target);
 const el=en.target,to=+el.dataset.n||0,t0=performance.now();
 (function f(t){const p=Math.min(1,(t-t0)/1200);el.textContent=Math.round(to*(1-Math.pow(1-p,3)));if(p<1)requestAnimationFrame(f)})(t0);
}),{threshold:.6});
document.querySelectorAll("[data-n]").forEach(el=>cio.observe(el));
JS;
require __DIR__.'/inc/foot.php';
?>
</body>
</html>
