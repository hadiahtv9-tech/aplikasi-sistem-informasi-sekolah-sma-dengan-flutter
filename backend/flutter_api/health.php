<?php
require_once 'api_common.php';
try {
    require_once 'db.php';
    // basic DB probe
    $stmt = $pdo->query('SELECT 1');
    $row = $stmt->fetch();
    if ($row) {
        send_json(['success' => 1, 'status' => 'ok']);
    }
    send_json(['success' => 0, 'status' => 'db_probe_failed'], 500);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
?>