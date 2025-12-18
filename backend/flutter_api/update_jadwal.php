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

$id       = $_POST['id'] ?? '';
$hari     = $_POST['hari'] ?? '';
$mapel    = $_POST['mapel'] ?? '';
$kelas_id = $_POST['kelas_id'] ?? '';
$guru_id  = $_POST['guru_id'] ?? '';
$jam      = $_POST['jam'] ?? '';
$ruangan  = $_POST['ruangan'] ?? '';

if (!$id) {
    echo json_encode(['success' => 0, 'error' => 'ID kosong']);
    exit;
}

$stmt = $pdo->prepare("
    UPDATE jadwal SET
      hari=?,
      mapel=?,
      kelas_id=?,
      guru_id=?,
      jam=?,
      ruangan=?
    WHERE id=?
");

$ok = $stmt->execute([
    $hari, $mapel, $kelas_id, $guru_id, $jam, $ruangan, $id
]);

echo json_encode(['success' => $ok ? 1 : 0]);
