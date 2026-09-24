<?php $ACTIVE = $ACTIVE ?? ''; $cls = fn($k) => $ACTIVE === $k ? ' class="on"' : ''; ?>
<div id="prog"></div>
<header><div class="wrap"><nav>
 <a href="index.php#home" class="logo" id="brand"></a>
 <div class="links" id="links">
  <a href="index.php#home">خانه</a>
  <a href="index.php#guide">راهنما</a>
  <a href="index.php#top">برترین‌ها</a>
  <a href="index.php#join">عضوگیری</a>
  <a href="index.php#dept">دپارتمان</a>
  <a href="gallery.php"<?=$cls('gallery')?>>گالری</a>
  <a href="rules.php"<?=$cls('rules')?>>قوانین</a>
  <a href="team.php"<?=$cls('team')?>>کادر مدیریت</a>
 </div>
 <button class="btn" id="burger" aria-label="منو" aria-expanded="false">☰</button>
 <a class="btn pri" href="<?=me()?"dashboard.php":"auth.php"?>">ورود به داشبورد</a>
</nav></div></header>
