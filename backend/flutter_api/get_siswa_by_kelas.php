<?php
require_once 'api_common.php';
require_once 'db.php';

try {
    $kelas_id = $_GET['kelas_id'] ?? null;

    if (!$kelas_id) {
        send_json([
            'success' => 0,
            'error' => 'kelas_id wajib diisi'
        ], 400);
    }

    $stmt = $pdo->prepare("
        SELECT id, nama
        FROM users
        WHERE role = 'siswa'
          AND kelas_id = ?
        ORDER BY nama ASC
    ");

    $stmt->execute([$kelas_id]);
    $siswa = $stmt->fetchAll();

    send_json([
        'success' => 1,
        'siswa' => $siswa
    ]);

} catch (Exception $e) {
    send_json([
        'success' => 0,
        'error' => $e->getMessage()
    ], 500);
}
