<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $uid = $_POST['uid'] ?? null;
    $role = $_POST['role'] ?? null;

    if (!$uid || !$role) {
        send_json(['success' => 0, 'error' => 'Missing uid or role'], 400);
    }

    $stmt = $pdo->prepare('UPDATE users SET role = ? WHERE uid = ?');
    $stmt->execute([$role, $uid]);
    send_json(['success' => 1]);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
?>