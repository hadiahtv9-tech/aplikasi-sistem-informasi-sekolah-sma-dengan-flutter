<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $id = $_POST['id'] ?? null;
    if (!$id) { send_json(['success'=>0,'error'=>'Missing id'], 400); }

    $stmt = $pdo->prepare('DELETE FROM tugas WHERE id = ?');
    $stmt->execute([$id]);
    send_json(['success'=>1]);
} catch (Throwable $e) { handle_exception_and_respond($e); }
?>