<?php
require_once 'api_common.php';
require_once 'db.php';

$stmt = $pdo->query("SELECT * FROM jadwal ORDER BY hari, jam");
send_json([
    'success' => 1,
    'jadwal' => $stmt->fetchAll(PDO::FETCH_ASSOC)
]);
