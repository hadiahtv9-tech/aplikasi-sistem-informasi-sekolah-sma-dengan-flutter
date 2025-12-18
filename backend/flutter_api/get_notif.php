<?php
require_once 'db.php';

$user_id = $_GET['user_id'] ?? '';

if (!$user_id) {
    echo json_encode([]);
    exit;
}

$stmt = $pdo->prepare("
    SELECT id, judul, pesan, dibaca, created_at
    FROM notifikasi
    WHERE user_id = ?
    ORDER BY created_at DESC
");
$stmt->execute([$user_id]);

echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
