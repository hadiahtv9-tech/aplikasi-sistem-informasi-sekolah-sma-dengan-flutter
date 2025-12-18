<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $stmt = $pdo->query('SELECT id, guru_id, judul, deskripsi, deadline, created_at FROM tugas ORDER BY deadline');
    $data = $stmt->fetchAll();
    send_json(['success' => 1, 'data' => $data]);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
?>