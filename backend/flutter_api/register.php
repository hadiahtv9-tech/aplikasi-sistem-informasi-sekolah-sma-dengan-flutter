<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    // register.php
    $email = $_POST['email'] ?? null;
    $password = $_POST['password'] ?? null;
    $username = $_POST['username'] ?? null;
    $name = $_POST['name'] ?? null;
    $role = $_POST['role'] ?? 'siswa';

    if (!$email || !$password) {
        send_json(['success' => 0, 'error' => 'Missing email or password'], 400);
    }

    // check exists
    $stmt = $pdo->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        send_json(['success' => 0, 'error' => 'Email already registered'], 409);
    }

    $hash = password_hash($password, PASSWORD_DEFAULT);
    $uid = bin2hex(random_bytes(8));
    $username = $username ?? explode('@', $email)[0];
    $name = $name ?? $username;

    $stmt = $pdo->prepare('INSERT INTO users (uid, email, password, username, nama, role, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())');
    $stmt->execute([$uid, $email, $hash, $username, $name, $role]);

    send_json(['success' => 1, 'user' => ['uid' => $uid, 'email' => $email, 'username' => $username, 'name' => $name, 'role' => $role]]);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
?>