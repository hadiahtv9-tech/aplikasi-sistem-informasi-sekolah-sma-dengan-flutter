<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $id = $_POST['id'] ?? null;
    if (!$id) { send_json(['success'=>0,'error'=>'Missing id'], 400); }

    $fields = [];
    $values = [];
    $allowed = ['judul','deskripsi','deadline','guru_id'];

    foreach ($allowed as $f) {
        if (isset($_POST[$f])) {
            $fields[] = "$f = ?";
            $values[] = $_POST[$f];
        }
    }

    if (empty($fields)) {
        send_json(['success'=>0,'error'=>'No fields to update'], 400);
    }

    $values[] = $id;
    $sql = 'UPDATE tugas SET ' . implode(', ', $fields) . ' WHERE id = ?';
    $stmt = $pdo->prepare($sql);
    $stmt->execute($values);
    send_json(['success'=>1]);
} catch (Throwable $e) { handle_exception_and_respond($e); }
?>