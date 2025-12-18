<?php
require_once 'api_common.php';
require_once 'db.php';

$id = $_POST['id'] ?? null;

if (!$id) {
    send_json(['success' => 0, 'error' => 'ID wajib'], 400);
}

$fields = [];
$params = [];

if (isset($_POST['nama'])) {
    $fields[] = "nama=?";
    $params[] = $_POST['nama'];
}

if (isset($_POST['email'])) {
    $fields[] = "email=?";
    $params[] = $_POST['email'];
}

if (isset($_POST['kelas_id'])) {
    $fields[] = "kelas_id=?";
    $params[] = $_POST['kelas_id'];
}

if (isset($_POST['wali_kelas_id'])) {
    $fields[] = "wali_kelas_id=?";
    $params[] = $_POST['wali_kelas_id'];
}

if (isset($_POST['password']) && $_POST['password'] !== '') {
    $fields[] = "password=?";
    $params[] = password_hash($_POST['password'], PASSWORD_DEFAULT);
}

$sql = "UPDATE users SET " . implode(", ", $fields) . " WHERE id=?";
$params[] = $id;

$stmt = $pdo->prepare($sql);
$stmt->execute($params);

send_json(['success' => 1]);
