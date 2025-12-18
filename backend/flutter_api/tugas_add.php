<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $guruId   = $_POST['guru_id'] ?? null;
    $kelasId  = $_POST['kelas_id'] ?? null;
    $judul    = $_POST['judul'] ?? null;
    $deskripsi= $_POST['deskripsi'] ?? null;
    $deadline = $_POST['deadline'] ?? null;

    if (!$guruId || !$kelasId || !$judul || !$deadline) {
        send_json(['success' => 0, 'error' => 'Field wajib kosong']);
        exit;
    }

    $stmt = $pdo->prepare("
        INSERT INTO tugas (guru_id, kelas_id, judul, deskripsi, deadline, created_at)
        VALUES (?, ?, ?, ?, ?, NOW())
    ");

    $stmt->execute([$guruId, $kelasId, $judul, $deskripsi, $deadline]);

    send_json(['success' => 1]);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
