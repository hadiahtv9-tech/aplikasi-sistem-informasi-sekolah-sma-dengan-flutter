<?php
require_once 'api_common.php';
require_once 'db.php';

$kelas_id = input_get('kelas_id');
$mapel_id = input_get('mapel_id');

if (!$kelas_id || !$mapel_id) {
    send_json([
        'success' => 0,
        'error' => 'kelas_id dan mapel_id wajib'
    ], 400);
}

$sql = "
SELECT 
    n.id,
    n.siswa_id,
    u.nama AS nama_siswa,
    n.mapel_id,
    n.nilai,
    n.semester
FROM nilai n
JOIN users u ON u.id = n.siswa_id
WHERE u.kelas_id = :kelas_id
AND n.mapel_id = :mapel_id
ORDER BY u.nama
";

$stmt = $pdo->prepare($sql);
$stmt->execute([
    ':kelas_id' => $kelas_id,
    ':mapel_id' => $mapel_id,
]);

$data = $stmt->fetchAll();

send_json([
    'success' => 1,
    'nilai' => $data
]);
