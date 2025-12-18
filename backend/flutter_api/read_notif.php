<?php
require_once 'db.php';

$id = $_POST['id'] ?? 0;

$stmt = $pdo->prepare("UPDATE notifikasi SET dibaca = 1 WHERE id = ?");
$stmt->execute([$id]);

echo json_encode(['success' => 1]);
