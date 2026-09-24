<?php $ACTIVE='rules'; require __DIR__."/lib.php"; ?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>قوانین شهر | یونیک رول پلی</title>
<meta name="description" content="قوانین کامل شهر یونیک؛ احترام، رول‌پلی واقعی، تقلب و باگ، قوانین گنگ و دپارتمان.">
<meta name="theme-color" content="#050505">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpath d='M16 8v28a16 16 0 0 0 32 0V8' fill='none' stroke='%23ffc107' stroke-width='11' stroke-linecap='round'/%3E%3C/svg%3E">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;500;600;700;800;900&display=swap">
<link rel="stylesheet" href="style.css">
<style>
.rcats{display:grid;gap:16px;margin-top:32px}
.rcat{background:linear-gradient(165deg,var(--panel),#0a0906);border:1px solid var(--line2);border-radius:var(--r);overflow:hidden}
.rcat summary{list-style:none;cursor:pointer;padding:22px 24px;display:flex;align-items:center;gap:16px;font-weight:800;font-size:1.02rem}
.rcat summary::-webkit-details-marker{display:none}
.rcat summary .ictile{margin:0;flex:none}
.rcat summary .chev{margin-inline-start:auto;transition:transform .25s var(--ease);color:var(--mut)}
.rcat[open] summary .chev{transform:rotate(180deg)}
.rcat[open]{border-color:#ffc10744;box-shadow:0 0 0 1px #ffc10722,0 20px 50px -20px #000c}
.rcat summary .ictile{transition:transform .3s var(--ease),background .3s,border-color .3s}
.rcat[open] summary .ictile{background:#ffc10726;border-color:#ffc10766;transform:rotate(-8deg) scale(1.06)}
.rcat ol{list-style:none;padding:0 24px 24px 24px;display:grid;gap:10px;color:var(--mut);font-size:.92rem;counter-reset:rn}
.rcat ol li{position:relative;padding-inline-start:38px;counter-increment:rn}
.rcat ol li::before{content:counter(rn);position:absolute;inset-inline-start:0;top:-1px;width:24px;height:24px;border-radius:8px;background:#ffc10716;border:1px solid #ffc10740;color:var(--gold);font-weight:800;font-size:.72rem;display:grid;place-items:center}
.rcat ol li b{color:var(--text);font-weight:700}
.punish{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:14px;margin-top:30px;position:relative}
.punish::before{content:"";position:absolute;top:32px;inset-inline:6%;height:2px;background:linear-gradient(90deg,#ffc10788,#ff5c3a88,#e6000088);z-index:0;opacity:.5}
.pstep{background:linear-gradient(165deg,var(--panel),#0a0906);border:1px solid var(--line2);border-radius:var(--r-sm);padding:18px;position:relative;z-index:1;transition:transform .25s var(--ease),border-color .25s}
.pstep:hover{transform:translateY(-5px);border-color:#ffc10755}
.pstep:last-child{border-color:#ff5c3a55;background:linear-gradient(165deg,#2a120a,#0a0906)}
.pstep:last-child b{color:#ff8a5c}
.pstep b{display:block;color:var(--gold);font-size:.85rem;margin-bottom:6px}
.pstep p{color:var(--mut);font-size:.88rem}
</style>
</head>
<body>
<?php require __DIR__.'/inc/head-nav.php'; ?>

<main>
<section class="pagehero">
 <div class="orbp a"></div><div class="orbp b"></div>
 <div class="wrap">
  <div class="crumb"><a href="index.php">خانه</a><span>/</span><span>قوانین</span></div>
  <h1><span class="gt">قوانین شهر</span> <span data-name>یونیک</span></h1>
  <p>قبل از ورود به شهر، این قوانین رو بخون. رعایت‌شون تجربه‌ی رول‌پلی بهتری برای همه می‌سازه.</p>
 </div>
</section>

<section style="padding-top:10px"><div class="wrap rv">
 <div class="rcats">

  <details class="rcat" open>
   <summary>
    <div class="ictile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3 4 6v6c0 5 3.4 8.4 8 9 4.6-.6 8-4 8-9V6l-8-3Z"/></svg></div>
    <span>قوانین عمومی و احترام</span>
    <svg class="chev" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20"><path d="m6 9 6 6 6-6"/></svg>
   </summary>
   <ol>
    <li><b>احترام متقابل:</b> به همه‌ی شهروندان و اعضای کادر احترام بذار؛ توهین، تبعیض یا آزار کلامی جایی تو شهر نداره.</li>
    <li><b>زبان مناسب:</b> از چت‌های عمومی و صدای بازی برای الفاظ رکیک یا اسپم استفاده نکن.</li>
    <li><b>تبلیغ ممنوع:</b> تبلیغ سرورهای دیگه یا لینک‌های نامرتبط داخل چت شهر یا دیسکورد مجاز نیست.</li>
    <li><b>گزارش مشکلات:</b> هر مشکلی رو از طریق تیکت دیسکورد به کادر اطلاع بده، نه با درگیری داخل شهر.</li>
   </ol>
  </details>

  <details class="rcat">
   <summary>
    <div class="ictile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="3.2"/><path d="M5 20c1-3.6 4-5.5 7-5.5S18 16.4 19 20"/></svg></div>
    <span>رول‌پلی واقعی</span>
    <svg class="chev" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20"><path d="m6 9 6 6 6-6"/></svg>
   </summary>
   <ol>
    <li><b>منطق داستان:</b> هر کاری که شخصیتت انجام می‌ده باید با پیش‌زمینه و منطق شخصیت جور باشه.</li>
    <li><b>VDM ممنوع:</b> زدن عمدی بازیکنان دیگه با وسیله‌ی نقلیه بدون دلیل رول‌پلی جرمه.</li>
    <li><b>متاگیمینگ ممنوع:</b> از اطلاعاتی که شخصیتت درون بازی به‌دست نیاورده استفاده نکن (مثل چت دیسکورد یا استریم).</li>
    <li><b>New Life Rule:</b> بعد از مرگ شخصیت، خاطرات مربوط به لحظه‌ی مرگ فراموش می‌شه.</li>
   </ol>
  </details>

  <details class="rcat">
   <summary>
    <div class="ictile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="m6 6 12 12"/></svg></div>
    <span>تقلب، باگ و ابزارهای غیرمجاز</span>
    <svg class="chev" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20"><path d="m6 9 6 6 6-6"/></svg>
   </summary>
   <ol>
    <li><b>چیت و هک:</b> استفاده از هرگونه نرم‌افزار تقلب یا اسپید‌هک به بن دائم می‌رسه.</li>
    <li><b>سوءاستفاده از باگ:</b> پیدا کردن باگ رو به کادر گزارش بده؛ سوءاستفاده از اون تخلف محسوب می‌شه.</li>
    <li><b>دو حساب هم‌زمان:</b> ورود هم‌زمان با چند اکانت برای گرفتن مزیت غیرمنصفانه ممنوعه.</li>
   </ol>
  </details>

  <details class="rcat">
   <summary>
    <div class="ictile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 11.5a8.4 8.4 0 0 1-8.4 8.4 8.6 8.6 0 0 1-3.8-.9L3 20l1-5.6a8.4 8.4 0 0 1-.9-3.9A8.4 8.4 0 0 1 11.5 2 8.6 8.6 0 0 1 21 11.5Z"/></svg></div>
    <span>قوانین گنگ‌ها</span>
    <svg class="chev" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20"><path d="m6 9 6 6 6-6"/></svg>
   </summary>
   <ol>
    <li><b>قلمرو مشخص:</b> درگیری بین گنگ‌ها باید با رول‌پلی منطقی و در چارچوب قوانین شهر باشه.</li>
    <li><b>محدودیت افراد:</b> هر گنگ باید در سقف مجاز اعضا فعالیت کنه؛ برای عضوگیری از پنل درخواست بده.</li>
    <li><b>فحاشی خارج از کاراکتر ممنوع:</b> رقابت گنگی نباید به درگیری واقعی بین بازیکنان تبدیل بشه.</li>
   </ol>
  </details>

  <details class="rcat">
   <summary>
    <div class="ictile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="12" rx="2"/><path d="M8 20h8M12 16v4"/></svg></div>
    <span>قوانین دپارتمان‌های رسمی</span>
    <svg class="chev" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20"><path d="m6 9 6 6 6-6"/></svg>
   </summary>
   <ol>
    <li><b>رفتار حرفه‌ای:</b> نیروهای پلیس، امدادی و شهرداری باید مطابق آموزش رسمی دپارتمان رفتار کنن.</li>
    <li><b>سوءاستفاده از قدرت ممنوع:</b> استفاده از ابزار یا وسیله‌ی دپارتمانی خارج از مأموریت رسمی مجاز نیست.</li>
    <li><b>زنجیره‌ی فرماندهی:</b> دستورات مافوق در چارچوب قوانین شهر باید رعایت بشه.</li>
   </ol>
  </details>

 </div>

 <div class="eyebrow" style="margin-top:56px">روند برخورد</div>
 <h2>مراحل رسیدگی به تخلف</h2>
 <p class="sub">اکثر تخلفات این مسیر رو طی می‌کنن؛ تخلفات سنگین (مثل چیت) مستقیم به بن دائم می‌رسن.</p>
 <div class="punish">
  <div class="pstep"><b>۱ · اخطار</b><p>تذکر رسمی و ثبت در پرونده‌ی شهروندی.</p></div>
  <div class="pstep"><b>۲ · جریمه یا سکوت موقت</b><p>جریمه‌ی درون‌شهری یا محدودیت موقت چت.</p></div>
  <div class="pstep"><b>۳ · بن موقت</b><p>محرومیت چندروزه از ورود به شهر.</p></div>
  <div class="pstep"><b>۴ · بن دائم</b><p>برای تخلفات تکراری یا سنگین (چیت، سوءاستفاده از باگ).</p></div>
 </div>

 <p style="margin-top:28px"><a class="btn pri" data-discord href="#">سوالی داری؟ تیکت بزن در دیسکورد</a></p>
</div></section>
</main>

<?php require __DIR__.'/inc/foot.php'; ?>
</body>
</html>
