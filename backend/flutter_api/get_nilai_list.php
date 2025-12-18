<?php
require_once 'api_common.php';
require_once 'db.php';

try {
    if (!isset($_GET['siswa_id'])) {
        throw new Exception('siswa_id wajib diisi');
    }

    $siswa_id = $_GET['siswa_id'];

    $sql = "
        SELECT 
            n.id,
            n.mapel_id,
            n.uts,
            n.uas,
            n.semester
        FROM nilai n
        WHERE n.siswa_id = ?
        ORDER BY n.created_at DESC
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->execute([$siswa_id]);

    echo json_encode([
        'success' => 1,
        'nilai' => $stmt->fetchAll(PDO::FETCH_ASSOC)
    ]);
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => 0,
        'error' => $e->getMessage()
    ]);
}
