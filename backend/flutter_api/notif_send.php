<?php
require_once 'api_common.php';
require_once 'db.php';

try {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        throw new Exception('Invalid method');
    }

    $judul = $_POST['judul'] ?? '';
    $pesan = $_POST['pesan'] ?? '';
    $role  = $_POST['role'] ?? '';

    if (!$judul || !$pesan || !$role) {
        throw new Exception('Data tidak lengkap');
    }

    // Ambil semua user berdasarkan role
    $stmt = $pdo->prepare("SELECT id FROM users WHERE role = ?");
    $stmt->execute([$role]);
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (!$users) {
        throw new Exception('User tidak ditemukan');
    }

    $insert = $pdo->prepare("
        INSERT INTO notifikasi (user_id, judul, pesan)
        VALUES (?, ?, ?)
    ");

    foreach ($users as $u) {
        $insert->execute([
            $u['id'],
            $judul,
            $pesan
        ]);
    }

    echo json_encode([
        'success' => 1,
        'message' => 'Notifikasi berhasil dikirim'
    ]);
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => 0,
        'error' => $e->getMessage()
    ]);
}
