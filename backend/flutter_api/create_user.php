<?php
require_once 'api_common.php';
require_once 'db.php';

try {
    $nama     = $_POST['nama'] ?? null;
    $email    = $_POST['email'] ?? null;
    $password = $_POST['password'] ?? null;
    $role     = $_POST['role'] ?? 'siswa';

    $kelas_id = $_POST['kelas_id'] ?? null;
    $wali_kelas_id = $_POST['wali_kelas_id'] ?? null;

    if (!$nama || !$email || !$password || !$role) {
        send_json(['success' => 0, 'error' => 'Data tidak lengkap'], 400);
    }

    $hash = password_hash($password, PASSWORD_DEFAULT);

    $stmt = $pdo->prepare(
        "INSERT INTO users (nama, email, password, role, kelas_id, wali_kelas_id)
         VALUES (?, ?, ?, ?, ?, ?)"
    );

    $stmt->execute([
        $nama,
        $email,
        $hash,
        $role,
        $role === 'siswa' ? $kelas_id : null,
        $role === 'guru' ? $wali_kelas_id : null
    ]);

    send_json(['success' => 1, 'id' => $pdo->lastInsertId()]);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
