<?php
/* Web phone entry point: needs a website login; then serves the phone UI with the web shim. */
require __DIR__ . '/../../lib.php';
if (!me()) { $_SESSION['next'] = 'phone/app/'; go('../../auth.php'); }

$html = (string)file_get_contents(__DIR__ . '/index.html');
// the CSRF token travels in a meta tag; api.php checks it on every request
$meta = '<meta name="dx-csrf" content="' . e(csrf()) . '"><meta name="robots" content="noindex">';
$html = preg_replace('/<head>/i', '<head>' . $meta, $html, 1) ?? $html;
// the shim must run right after jQuery (it replaces $.post) and before any app script
$html = preg_replace('/(<script[^>]*jquery\.min\.js[^>]*><\/script>)/i', '$1<script src="web-shim.js"></script>', $html, 1) ?? $html;
$html = preg_replace('/<\/head>/i', '<link rel="stylesheet" href="web.css"></head>', $html, 1) ?? $html;

header('Content-Type: text/html; charset=utf-8');
header('Cache-Control: no-store');
header('X-Frame-Options: SAMEORIGIN');
header('Referrer-Policy: same-origin');
echo $html;
