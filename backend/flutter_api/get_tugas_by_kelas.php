<?php
require_once 'api_common.php';
require_once 'db.php';

$kelasId = input_get('kelas_id');

if (!$kelasId) {
    send_json([
        'success' => 0,
        'error' => 'kelas_id wajib diisi'
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
        WHERE t.kelas_id = ?
        ORDER BY t.deadline ASC
    ");

    $stmt->execute([$kelasId]);
    $tugas = $stmt->fetchAll();

    send_json([
        'success' => 1,
        'tugas' => $tugas
    ]);

} catch (Exception $e) {
    handle_exception_and_respond($e);
}
