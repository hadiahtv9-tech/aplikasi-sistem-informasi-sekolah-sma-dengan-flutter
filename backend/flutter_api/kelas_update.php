<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $id = $_POST['id'] ?? null;
    $nama = $_POST['nama'] ?? null;

    if (!$id) { send_json(['success'=>0,'error'=>'Missing id'], 400); }
    if (!$nama) { send_json(['success'=>0,'error'=>'Missing nama'], 400); }

    $stmt = $pdo->prepare('UPDATE kelas SET nama = ? WHERE id = ?');
    $stmt->execute([$nama, $id]);
    send_json(['success'=>1]);
} catch (Throwable $e) { handle_exception_and_respond($e); }
?>