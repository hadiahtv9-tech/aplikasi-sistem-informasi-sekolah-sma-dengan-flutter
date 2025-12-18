<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $stmt = $pdo->query("SELECT id, nama FROM kelas ORDER BY nama");
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);

    send_json(['success' => 1, 'data' => $data]);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
