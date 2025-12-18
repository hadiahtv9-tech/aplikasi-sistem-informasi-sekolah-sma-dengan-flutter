<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $email = 'admin@gmail.com';
    $password = 'admin123';
    $nama = 'Admin User';
    $role = 'admin';
    $uid = 'admin001';

    $hash = password_hash($password, PASSWORD_DEFAULT);
    $stmt = $pdo->prepare('INSERT INTO users (uid, email, password, username, nama, role, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())');
    $stmt->execute([$uid, $email, $hash, 'admin', $nama, $role]);
    send_json(['success' => 1, 'message' => 'Admin created', 'email' => $email, 'password' => $password]);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
?>