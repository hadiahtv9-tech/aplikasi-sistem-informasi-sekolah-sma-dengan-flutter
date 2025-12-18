<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $uid = $_GET['uid'] ?? null;
    if (!$uid) {
        send_json(['success' => 0, 'error' => 'Missing uid'], 400);
    }

    $stmt = $pdo->prepare('SELECT uid, email, username, nama, role, kelas_id, wali_kelas_id FROM users WHERE uid = ? LIMIT 1');
    $stmt->execute([$uid]);
    $user = $stmt->fetch();
    if (!$user) {
        send_json(['success' => 0, 'error' => 'User not found'], 404);
    }
    send_json(['success' => 1, 'user' => $user]);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
?>