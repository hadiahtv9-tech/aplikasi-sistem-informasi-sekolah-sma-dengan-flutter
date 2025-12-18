<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $userId = $_POST['userId'] ?? null;
    $judul = $_POST['judul'] ?? null;
    $pesan = $_POST['pesan'] ?? null;
    if (!$userId || !$judul) { send_json(['success'=>0,'error'=>'Missing fields'], 400); }

    $stmt = $pdo->prepare('INSERT INTO notifikasi (user_id, judul, pesan, dibaca, created_at) VALUES (?, ?, ?, 0, NOW())');
    $stmt->execute([$userId, $judul, $pesan]);
    send_json(['success'=>1]);
} catch (Throwable $e) { handle_exception_and_respond($e); }
?>