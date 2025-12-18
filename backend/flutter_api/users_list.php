<?php
require_once 'api_common.php';
require_once 'db.php';

$role = $_GET['role'] ?? null;

try {
    if ($role) {
        $stmt = $pdo->prepare("
            SELECT 
                id,
                email,
                nama,
                role,
                kelas_id,
                wali_kelas_id
            FROM users
            WHERE role = ?
            ORDER BY nama
        ");
        $stmt->execute([$role]);
    } else {
        $stmt = $pdo->query("
            SELECT 
                id,
                email,
                nama,
                role,
                kelas_id,
                wali_kelas_id
            FROM users
            ORDER BY nama
        ");
    }

    $data = $stmt->fetchAll();
    send_json(['success' => 1, 'data' => $data]);

} catch (Throwable $e) {
    send_json(['success' => 0, 'error' => $e->getMessage()], 500);
}
