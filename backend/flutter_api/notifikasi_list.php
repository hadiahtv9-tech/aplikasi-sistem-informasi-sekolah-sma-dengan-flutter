<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $userId = $_GET['userId'] ?? null;
    if (!$userId) { send_json(['success'=>0,'error'=>'Missing userId'], 400); }

    $stmt = $pdo->prepare('SELECT id, user_id, judul, pesan, dibaca, created_at FROM notifikasi WHERE user_id = ? ORDER BY created_at DESC');
    $stmt->execute([$userId]);
    $data = $stmt->fetchAll();
    send_json(['success'=>1,'data'=>$data]);
} catch (Throwable $e) { handle_exception_and_respond($e); }
?>