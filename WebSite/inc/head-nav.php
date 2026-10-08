<?php $ACTIVE = $ACTIVE ?? ''; $cls = fn($k) => $ACTIVE === $k ? ' class="on"' : ''; ?>
<div id="prog"></div>
<header><div class="wrap"><nav>
 <a href="index.php#home" class="logo" id="brand"></a>
 <div class="links" id="links">
  <a href="index.php#home"<?=$cls('home')?>>خانه</a>
  <a href="rules.php"<?=$cls('rules')?>>قوانین</a>
 </div>
 <button class="btn" id="burger" aria-label="منو" aria-expanded="false"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true"><path class="b1" d="M4 7h16"/><path class="b2" d="M4 12h16"/><path class="b3" d="M4 17h16"/></svg></button>
 <a class="btn pri" href="<?=me()?"dashboard.php":"auth.php"?>">ورود به داشبورد</a>
</nav></div></header>
