<?php
require_once 'db.php';

$judul = $_POST['judul'] ?? '';
$pesan = $_POST['pesan'] ?? '';
$role  = $_POST['role'] ?? '';

if (!$judul || !$pesan || !$role) {
    echo json_encode(['success' => 0, 'message' => 'Data tidak lengkap']);
    exit;
}

try {
    // ambil user sesuai role
    $stmt = $pdo->prepare("SELECT id FROM users WHERE role = ?");
    $stmt->execute([$role]);
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($users as $u) {
        $ins = $pdo->prepare("
            INSERT INTO notifikasi (user_id, judul, pesan)
            VALUES (?, ?, ?)
        ");
        $ins->execute([$u['id'], $judul, $pesan]);
    }

    echo json_encode(['success' => 1]);
} catch (Exception $e) {
    echo json_encode(['success' => 0, 'error' => $e->getMessage()]);
}
