<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $role = $_GET['role'] ?? '';

    if (!$role) {
        send_json(['count' => 0]);
    }

    $stmt = $pdo->prepare("SELECT COUNT(*) as total FROM users WHERE role = ?");
    $stmt->execute([$role]);
    $row = $stmt->fetch();

    send_json(['count' => (int)($row['total'] ?? 0)]);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
