<?php
require_once 'api_common.php';
require_once 'db.php';

$guru_id = $_GET['guru_id'] ?? '';

if (!$guru_id) {
    send_json([
        'success' => 0,
        'error' => 'guru_id kosong'
    ]);
}

$stmt = $pdo->prepare("
    SELECT *
    FROM jadwal
    WHERE guru_id = ?
    ORDER BY hari, jam
");

$stmt->execute([$guru_id]);

send_json([
    'success' => 1,
    'jadwal' => $stmt->fetchAll(PDO::FETCH_ASSOC)
]);
