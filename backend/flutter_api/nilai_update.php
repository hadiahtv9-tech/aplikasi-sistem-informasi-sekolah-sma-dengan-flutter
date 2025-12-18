<?php
require_once 'api_common.php';
require_once 'db.php';

$id    = input_post('id');
$nilai = input_post('nilai');
$semester = input_post('semester');

if (!$id || $nilai === null) {
    send_json([
        'success' => 0,
        'error' => 'ID dan nilai wajib diisi'
    ], 400);
}

$stmt = $pdo->prepare("
    UPDATE nilai
    SET nilai = :nilai, semester = :semester
    WHERE id = :id
");

$stmt->execute([
    ':id' => $id,
    ':nilai' => $nilai,
    ':semester' => $semester,
]);

send_json([
    'success' => 1,
    'message' => 'Nilai berhasil diperbarui'
]);
