<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $nama = $_POST['nama'] ?? null;
    if (!$nama) { send_json(['success'=>0,'error'=>'Missing nama'], 400); }

    $stmt = $pdo->prepare('INSERT INTO kelas (nama, created_at) VALUES (?, NOW())');
    $stmt->execute([$nama]);
    send_json(['success'=>1]);
} catch (Throwable $e) { handle_exception_and_respond($e); }
?>