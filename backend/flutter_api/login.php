<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    // Log incoming request safely
    error_log('[LOGIN.PHP]  Request received at ' . date('Y-m-d H:i:s'));
    error_log('[LOGIN.PHP]  POST data: email=' . ($_POST['email'] ?? 'MISSING') . ', password_length=' . strlen($_POST['password'] ?? ''));

    $email = $_POST['email'] ?? null;
    $password = $_POST['password'] ?? null;

    if (!$email || !$password) {
        $error = 'Missing credentials - email=' . ($email ? 'present' : 'MISSING') . ', password=' . ($password ? 'present' : 'MISSING');
        error_log('[LOGIN.PHP]  ' . $error);
        send_json(['success' => 0, 'error' => $error], 400);
    }

    $stmt = $pdo->prepare('SELECT * FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if (!$user) {
        error_log('[LOGIN.PHP]  User not found for email: ' . $email);
        send_json(['success' => 0, 'error' => 'User not found'], 404);
    }

    if (!password_verify($password, $user['password'])) {
        error_log('[LOGIN.PHP]  Password verification failed for email: ' . $email);
        send_json(['success' => 0, 'error' => 'Invalid password'], 401);
    }

    unset($user['password']);
    send_json(['success' => 1, 'user' => $user]);
} catch (Throwable $e) {
    error_log('[LOGIN.PHP]  Exception: ' . $e->getMessage());
    handle_exception_and_respond($e);
}
?>
