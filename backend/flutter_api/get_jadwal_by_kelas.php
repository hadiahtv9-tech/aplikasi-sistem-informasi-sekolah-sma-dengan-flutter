<?php
header('Content-Type: application/json');

require_once 'db.php'; // menghasilkan $pdo

try {
    if (!isset($_GET['kelas_id'])) {
        echo json_encode([
            'success' => 0,
            'message' => 'kelas_id tidak ditemukan'
        ]);
        exit;
    }

    $kelas_id = (int) $_GET['kelas_id'];

    if ($kelas_id <= 0) {
        echo json_encode([
            'success' => 0,
            'message' => 'kelas_id tidak valid'
        ]);
        exit;
    }

    $sql = "
        SELECT id, hari, mapel, jam, ruangan
        FROM jadwal
        WHERE kelas_id = :kelas_id
        ORDER BY 
          FIELD(hari,'Senin','Selasa','Rabu','Kamis','Jumat','Sabtu'),
          jam
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute(['kelas_id' => $kelas_id]);

    $jadwal = $stmt->fetchAll();

    echo json_encode([
        'success' => 1,
        'jadwal' => $jadwal
    ]);
} catch (Exception $e) {
    echo json_encode([
        'success' => 0,
        'message' => $e->getMessage()
    ]);
}
