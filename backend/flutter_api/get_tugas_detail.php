<?php
require_once 'api_common.php';
require_once 'db.php';

$id = input_get('id');

if (!$id) {
    send_json([
        'success' => 0,
        'error' => 'ID tugas tidak ditemukan'
    ], 400);
}

try {
    $stmt = $pdo->prepare("
        SELECT 
            t.id,
            t.judul,
            t.deskripsi,
            t.deadline,
            t.created_at,
            u.nama AS nama_guru
        FROM tugas t
        JOIN users u ON u.id = t.guru_id
        WHERE t.id = ?
        LIMIT 1
    ");

    $stmt->execute([$id]);
    $tugas = $stmt->fetch();

    if (!$tugas) {
        send_json([
            'success' => 0,
            'error' => 'Tugas tidak ditemukan'
        ], 404);
    }

    send_json([
        'success' => 1,
        'tugas' => $tugas
    ]);

} catch (Exception $e) {
    handle_exception_and_respond($e);
}
