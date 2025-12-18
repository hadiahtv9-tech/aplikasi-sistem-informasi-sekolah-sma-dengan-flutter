<?php
require_once 'api_common.php';
require_once 'db.php';

try {
    $kelas_id = $_GET['kelas_id'] ?? null;
    $guru_id  = $_GET['guru_id'] ?? null;

    if (!$kelas_id || !$guru_id) {
        send_json([
            'success' => 0,
            'error' => 'kelas_id dan guru_id wajib diisi'
        ], 400);
    }

    $stmt = $pdo->prepare("
        SELECT DISTINCT mapel
        FROM jadwal
        WHERE kelas_id = ?
          AND guru_id = ?
        ORDER BY mapel ASC
    ");

    $stmt->execute([$kelas_id, $guru_id]);
    $data = $stmt->fetchAll();

    send_json([
        'success' => 1,
        'mapel' => $data
    ]);

} catch (Exception $e) {
    send_json([
        'success' => 0,
        'error' => $e->getMessage()
    ], 500);
}
