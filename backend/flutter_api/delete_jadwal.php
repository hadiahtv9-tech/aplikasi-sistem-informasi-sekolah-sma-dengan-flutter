<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=utf-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require 'db.php';

$id = $_POST['id'] ?? '';

if (!$id) {
    echo json_encode(['success' => 0, 'error' => 'ID kosong']);
    exit;
}

$stmt = $pdo->prepare("DELETE FROM jadwal WHERE id=?");
$ok = $stmt->execute([$id]);

echo json_encode(['success' => $ok ? 1 : 0]);
