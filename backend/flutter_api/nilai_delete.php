<?php
require_once 'api_common.php';
require_once 'db.php';

$id = input_post('id');

if (!$id) {
    send_json([
        'success' => 0,
        'error' => 'ID tidak boleh kosong'
    ], 400);
}

$stmt = $pdo->prepare("DELETE FROM nilai WHERE id = :id");
$stmt->execute([':id' => $id]);

send_json([
    'success' => 1,
    'message' => 'Nilai berhasil dihapus'
]);
