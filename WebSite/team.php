<?php
$ACTIVE = 'team'; require __DIR__ . '/lib.php';
$ST = site_stats(); $staff = $ST['staff'];           // [نام, رنک, permission_level, آنلاین]
$online = array_sum(array_column($staff, 3));
$byTier = []; $byRank = [];
foreach ($staff as $s) { $byTier[tier_of($s[2])['key']][] = $s; $byRank[$s[1]] = ($byRank[$s[1]] ?? 0) + 1; }
$ladder = array_reverse(CFG['perm_ranks'], true);   // بالاترین رنک اول
?><!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>کادر مدیریت | یونیک رول پلی</title>
<meta name="description" content="کادر مدیریت شهر یونیک؛ رنک‌ها و اعضای فعال، لحظه‌ای از دیتابیس سرور.">
<meta name="theme-color" content="#050505">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpath d='M16 8v28a16 16 0 0 0 32 0V8' fill='none' stroke='%23ffc107' stroke-width='11' stroke-linecap='round'/%3E%3C/svg%3E">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;500;600;700;800;900&display=swap">
<link rel="stylesheet" href="style.css">
<style>
.tm{display:grid;grid-template-columns:270px 1fr;gap:34px;align-items:start}
.ladder{position:sticky;top:96px;padding:22px;border-radius:var(--r);background:linear-gradient(165deg,var(--panel),#0a0906);border:1px solid var(--line2)}
.ladder h3{font-size:1rem;margin-bottom:4px}.ladder p{color:var(--mut);font-size:.8rem;margin-bottom:14px}
.ladder ol{list-style:none;padding:0;position:relative}
.ladder ol::before{content:"";position:absolute;inset-block:8px;inset-inline-start:6px;width:2px;background:linear-gradient(#ffc10788,#ffffff10)}
.ladder li{position:relative;display:flex;align-items:center;gap:12px;padding:5px 0;font-size:.88rem;color:var(--mut2)}
.ladder li::before{content:"";flex:none;width:14px;height:14px;border-radius:50%;background:var(--bg);border:2px solid var(--c);z-index:1}
.ladder li.has{color:var(--text);font-weight:700}.ladder li.has::before{background:var(--c);box-shadow:0 0 10px var(--c)}
.ladder li em{margin-inline-start:auto;font-style:normal;font-size:.75rem;color:var(--c)}
.ladder li span{direction:ltr}
.tier{margin-bottom:46px}
.tier .th{display:flex;align-items:end;gap:14px;flex-wrap:wrap;margin-bottom:16px;padding-bottom:12px;border-bottom:1px solid var(--line2)}
.tier h2{font-size:1.5rem;color:var(--c)}.tier .th p{color:var(--mut);font-size:.88rem}
.tier .th b{margin-inline-start:auto;font-size:.8rem;color:var(--mut);font-weight:500}
.sg{display:grid;grid-template-columns:repeat(auto-fill,minmax(210px,1fr));gap:14px}
.sc{position:relative;display:flex;align-items:center;gap:14px;padding:16px;border-radius:var(--r-sm);background:linear-gradient(165deg,var(--panel),#0a0906);border:1px solid var(--line2);border-inline-start:3px solid var(--c);transition:transform .25s var(--ease),box-shadow .25s}
.sc:hover{transform:translateY(-4px);box-shadow:0 16px 36px -12px #000c}
.sc .av{flex:none;width:52px;height:52px;border-radius:16px;display:grid;place-items:center;font-weight:900;font-size:1.3rem;color:var(--c);background:radial-gradient(circle at 30% 25%,color-mix(in srgb,var(--c) 30%,transparent),#0a0906 75%);border:1px solid color-mix(in srgb,var(--c) 45%,transparent)}
.sc h3{font-size:1rem;line-height:1.5;direction:ltr;text-align:right}
.sc small{display:block;color:var(--c);font-weight:700;font-size:.78rem;direction:ltr;text-align:right}
.sc .lv{position:absolute;top:8px;inset-inline-start:12px;font-size:.68rem;color:var(--mut2);direction:ltr}
.sc .dot{position:absolute;bottom:12px;inset-inline-start:14px;width:9px;height:9px;border-radius:50%;background:#3a3526}
.sc.on .dot{background:#3ddc84;box-shadow:0 0 10px #3ddc84;animation:pulse 1.8s infinite}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.35}}
.tstats{display:flex;justify-content:center;gap:14px;flex-wrap:wrap;margin-top:30px;position:relative}
.tstats div{min-width:130px;padding:14px 22px;border-radius:var(--r);background:var(--glass);border:1px solid var(--line2);backdrop-filter:blur(14px)}
.tstats b{display:block;font-size:1.8rem;line-height:1.4;color:var(--gold)}.tstats span{font-size:.8rem;color:var(--mut)}
.empty{text-align:center;padding:60px 20px;border:1px dashed var(--line2);border-radius:var(--r);background:var(--panel);color:var(--mut)}
.ladder li.top{color:var(--gold);font-weight:900}
.ladder li.top .crown{margin-inline-end:4px}
.sc.on .av{box-shadow:0 0 0 3px color-mix(in srgb,var(--c) 55%,transparent),0 0 22px -4px var(--c);animation:avpulse 2.4s ease-in-out infinite}
@keyframes avpulse{0%,100%{box-shadow:0 0 0 3px color-mix(in srgb,var(--c) 55%,transparent),0 0 14px -4px var(--c)}50%{box-shadow:0 0 0 5px color-mix(in srgb,var(--c) 30%,transparent),0 0 26px -2px var(--c)}}
.tier:first-of-type .sc{border-image:linear-gradient(165deg,var(--c),transparent) 1;box-shadow:0 0 0 1px color-mix(in srgb,var(--c) 25%,transparent)}
@media(max-width:900px){.tm{grid-template-columns:1fr}.ladder{position:static}}
@media(prefers-reduced-motion:reduce){.sc,.sc .dot,.sc.on .av{animation:none;transition:none}}
</style>
</head>
<body>
<?php require __DIR__ . '/inc/head-nav.php'; ?>

<main>
<section class="pagehero">
 <div class="orbp a"></div><div class="orbp b"></div>
 <div class="wrap">
  <div class="crumb"><a href="index.php">خانه</a><span>/</span><span>کادر مدیریت</span></div>
  <h1><span class="gt">کادر مدیریت</span> شهر</h1>
  <p>کسانی که پشت صحنه، شهر رو می‌سازن و بهش نظم می‌دن. اسم هر نفر همون اسم داخل بازیشه و رنکش از permission_level خودش تو سرور خونده می‌شه.</p>
  <div class="tstats">
   <div><b data-n="<?= count($staff) ?>"><?= count($staff) ?></b><span>عضو کادر</span></div>
   <div><b data-n="<?= $online ?>"><?= $online ?></b><span>آنلاین همین الان</span></div>
   <div><b data-n="<?= count($byRank) ?>"><?= count($byRank) ?></b><span>رنک فعال</span></div>
  </div>
 </div>
</section>

<section style="padding-top:20px"><div class="wrap">
<?php if (!$staff): ?>
 <div class="empty">فعلاً عضوی برای نمایش ثبت نشده.</div>
<?php else: ?>
 <div class="tm">
  <aside class="ladder" aria-label="نردبان رنک‌ها">
   <h3>نردبان رنک‌ها</h3><p>رنک‌های پررنگ یعنی همین الان عضو دارن.</p>
   <ol>
   <?php $first = true; foreach ($ladder as $lv => $name): $t = tier_of($lv); $n = $byRank[$name] ?? 0; ?>
    <li class="<?= trim(($n ? 'has ' : '') . ($first ? 'top' : '')) ?>" style="--c:<?= e($t['color']) ?>"><?php if ($first): ?><span class="crown">👑</span><?php endif; ?><span><?= e($name) ?></span><?= $n ? '<em>' . $n . ' نفر</em>' : '' ?></li>
   <?php $first = false; endforeach; ?>
   </ol>
  </aside>

  <div>
  <?php foreach (CFG['perm_tiers'] as $t): $L = $byTier[$t['key']] ?? []; if (!$L) continue; ?>
   <div class="tier" style="--c:<?= e($t['color']) ?>">
    <div class="th"><div><h2><?= e($t['fa']) ?></h2><p><?= e($t['desc']) ?></p></div><b><?= count($L) ?> نفر · <?= array_sum(array_column($L, 3)) ?> آنلاین</b></div>
    <div class="sg">
    <?php foreach ($L as $s): ?>
     <div class="sc <?= $s[3] ? 'on' : '' ?>"><span class="lv">Lv <?= (int)$s[2] ?></span><div class="av"><?= e(mb_substr($s[0], 0, 1)) ?></div><div><h3><?= e($s[0]) ?></h3><small><?= e($s[1]) ?></small></div><i class="dot" title="<?= $s[3] ? 'آنلاین' : 'آفلاین' ?>"></i></div>
    <?php endforeach; ?>
    </div>
   </div>
  <?php endforeach; ?>
  </div>
 </div>
<?php endif; ?>
</div></section>
</main>

<?php
$EXTRA_JS = <<<'JS'
const cio=new IntersectionObserver(es=>es.forEach(en=>{
 if(!en.isIntersecting) return; cio.unobserve(en.target);
 const el=en.target,to=+el.dataset.n||0,t0=performance.now();
 (function f(t){const p=Math.min(1,(t-t0)/1000);el.textContent=Math.round(to*(1-Math.pow(1-p,3)));if(p<1)requestAnimationFrame(f)})(t0);
}),{threshold:.6});
document.querySelectorAll("[data-n]").forEach(el=>cio.observe(el));
JS;
require __DIR__ . '/inc/foot.php';
?>
</body>
</html>
