<?php
require_once 'api_common.php';
require_once 'db.php';

$siswa_id = $_POST['siswa_id'] ?? null;
$mapel_id = $_POST['mapel_id'] ?? null;
$uts      = $_POST['uts'] ?? null;
$uas      = $_POST['uas'] ?? null;

$semester = 'Ganjil';

if (!$siswa_id || !$mapel_id) {
    send_json(['success' => 0, 'error' => 'Data tidak lengkap'], 400);
}

function validNilai($n) {
    return $n === null || (is_numeric($n) && $n >= 0 && $n <= 100);
}

if (!validNilai($uts) || !validNilai($uas)) {
    send_json(['success' => 0, 'error' => 'Nilai harus 0 - 100'], 400);
}

/* ================= CEK DATA ================= */
$check = $pdo->prepare("
    SELECT id FROM nilai
    WHERE siswa_id = ? AND mapel_id = ? AND semester = ?
    LIMIT 1
");
$check->execute([$siswa_id, $mapel_id, $semester]);
$data = $check->fetch();

/* ================= UPDATE ================= */
if ($data) {
    $stmt = $pdo->prepare("
        UPDATE nilai
        SET 
            uts = COALESCE(?, uts),
            uas = COALESCE(?, uas),
            updated_at = NOW()
        WHERE id = ?
    ");
    $stmt->execute([$uts, $uas, $data['id']]);

    send_json([
        'success' => 1,
        'message' => 'Nilai berhasil diperbarui'
    ]);
}

/* ================= INSERT ================= */
$stmt = $pdo->prepare("
    INSERT INTO nilai (siswa_id, mapel_id, uts, uas, semester)
    VALUES (?, ?, ?, ?, ?)
");
$stmt->execute([$siswa_id, $mapel_id, $uts, $uas, $semester]);

send_json([
    'success' => 1,
    'message' => 'Nilai berhasil disimpan'
]);
