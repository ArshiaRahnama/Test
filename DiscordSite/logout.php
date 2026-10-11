<?php
require __DIR__ . '/lib.php';
if (($_SERVER['REQUEST_METHOD'] ?? '') === 'POST' && csrf_ok((string)($_POST['csrf'] ?? ''))) {
  $_SESSION = [];
  session_destroy();
}
go('login.php');
