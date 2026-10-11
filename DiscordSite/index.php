<?php
/* The Discord app. Same UI files as the in-game phone; data comes from api.php. */
require __DIR__ . '/lib.php';
require_user();

$html = (string)file_get_contents(__DIR__ . '/app/index.html');
// <base> makes every relative path (css, js, img, fonts, and the paths the apps build in JS) resolve inside app/
$head = '<base href="app/"><meta name="dx-csrf" content="' . e(csrf()) . '"><meta name="robots" content="noindex"><title>' . e(dsite_cfg('site_name')) . '</title>';
$html = preg_replace('/<head>/i', '<head>' . $head, $html, 1) ?? $html;
$html = preg_replace('/(<script[^>]*jquery\.min\.js[^>]*><\/script>)/i', '$1<script src="web-shim.js"></script>', $html, 1) ?? $html;
$html = preg_replace('/<\/head>/i', '<link rel="stylesheet" href="web.css"></head>', $html, 1) ?? $html;

header('Content-Type: text/html; charset=utf-8');
header('Cache-Control: no-store');
header('X-Frame-Options: SAMEORIGIN');
header('X-Content-Type-Options: nosniff');
header("Referrer-Policy: same-origin");
echo $html;
