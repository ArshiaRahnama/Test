<button id="totop" aria-label="برو به بالا" type="button"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 19V5M6 11l6-6 6 6"/></svg></button>

<footer><div class="wrap">
 <div class="fg">
  <div>
   <div class="logo" id="flogo"></div>
   <p class="sub">یه شهر کامل برای زندگی دوم تو؛ رول‌پلی جدی، قانون واقعی و کامیونیتی همیشه‌فعال.</p>
   <div class="social"><a data-discord href="#" aria-label="دیسکورد"><svg viewBox="0 0 24 24" fill="currentColor"><path d="M20.3 5.4a17 17 0 0 0-4.3-1.3l-.2.4a15 15 0 0 1 3.8 1.4 16 16 0 0 0-14.9 0 15 15 0 0 1 3.9-1.4l-.2-.4A17 17 0 0 0 4 5.4C1.8 8.6 1.2 11.8 1.5 14.9a17 17 0 0 0 5 2.5l1-1.6a11 11 0 0 1-1.7-.8c.1-.1.3-.2.4-.3a12 12 0 0 0 10.6 0l.4.3a11 11 0 0 1-1.7.8l1 1.6a17 17 0 0 0 5-2.5c.4-3.6-.5-6.7-2.2-9.5ZM8.7 13c-.7 0-1.3-.7-1.3-1.5S8 10 8.7 10s1.3.7 1.3 1.5S9.4 13 8.7 13Zm6.6 0c-.7 0-1.3-.7-1.3-1.5s.6-1.5 1.3-1.5 1.3.7 1.3 1.5-.6 1.5-1.3 1.5Z"/></svg></a></div>
  </div>
  <div><h4>دسترسی سریع</h4><ul><li><a href="index.php#home">خانه</a></li><li><a href="index.php#guide">راهنما</a></li><li><a href="index.php#top">رنک سرور</a></li><li><a href="join.php">عضوگیری و دپارتمان</a></li></ul></div>
  <div><h4>سرور</h4><ul><li><a href="gallery.php">گالری</a></li><li><a href="rules.php">قوانین</a></li><li><a href="team.php">درباره ما</a></li><li><a href="index.php#guide">راهنمای ورود</a></li></ul></div>
  <div><h4>ارتباط با ما</h4><ul><li><a data-discord href="#">دیسکورد</a></li><li><a data-panel href="#">پنل کاربری</a></li><li><a data-discord href="#">پشتیبانی و تیکت</a></li></ul></div>
 </div>
 <div class="copy"><span>© 2026 <span data-brand>Unique RP</span> — تمامی حقوق محفوظ است</span><span>Powered by <a href="https://arshiahub.ir" target="_blank" rel="noopener" class="pw">arshiahub.ir</a></span></div>
</div></footer>

<script>
<?php $J = JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP; ?>
const CFG=<?=json_encode(['name'=>CFG['name'],'fa'=>CFG['fa'],'discord'=>CFG['discord'],'panel'=>'dashboard.php','cfxcode'=>CFG['cfxcode'],'live'=>is_live()],$J)?>;
const $=s=>document.querySelector(s), esc=t=>String(t).replace(/[&<>"]/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;"}[c]));
const mark='<svg viewBox="0 0 64 64"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffe08a"/><stop offset="1" stop-color="#d18f00"/></linearGradient></defs><path d="M16 8v28a16 16 0 0 0 32 0V8" fill="none" stroke="url(#g)" stroke-width="11" stroke-linecap="round"/></svg>';
const [w1,...w2]=CFG.name.split(" ");
$("#brand").innerHTML=mark+"<span>"+esc(w1)+" <b>"+esc(w2.join(" "))+"</b></span>";
$("#flogo").innerHTML=$("#brand").innerHTML;
document.querySelectorAll("[data-name]").forEach(e=>e.textContent=CFG.fa);
document.querySelectorAll("[data-brand]").forEach(e=>e.textContent=CFG.name);
document.querySelectorAll("[data-discord]").forEach(e=>{e.href=CFG.discord;e.target="_blank";e.rel="noopener"});
document.querySelectorAll("[data-panel]").forEach(e=>e.href=CFG.panel);

$("#totop").addEventListener("click",()=>window.scrollTo({top:0,behavior:"smooth"}));
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
if(matchMedia("(pointer:fine)").matches)addEventListener("pointermove",e=>{const c=e.target.closest&&e.target.closest(".card,.dcard");if(!c)return;const r=c.getBoundingClientRect();c.style.setProperty("--mx",(e.clientX-r.left)+"px");c.style.setProperty("--my",(e.clientY-r.top)+"px")},{passive:true});
<?=$EXTRA_JS ?? ''?>
</script>
