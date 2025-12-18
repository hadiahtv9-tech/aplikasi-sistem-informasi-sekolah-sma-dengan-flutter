<?php
require_once 'api_common.php';
require_once 'db.php';

$id = $_POST['id'] ?? null;

if (!$id) {
    send_json(['success' => 0, 'error' => 'ID wajib'], 400);
}

$stmt = $pdo->prepare("DELETE FROM users WHERE id = ?");
$stmt->execute([$id]);

send_json(['success' => 1]);
