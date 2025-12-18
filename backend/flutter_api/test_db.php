<?php
require_once 'api_common.php';
try {
    require_once 'db.php';
    $stmt = $pdo->query('SELECT 1 as ok');
    $row = $stmt->fetch();
    send_json(['success' => 1, 'db' => $row['ok']]);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}

