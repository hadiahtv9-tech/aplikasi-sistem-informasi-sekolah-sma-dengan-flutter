<?php
require_once 'api_common.php';

try {
    require_once 'db.php';

    $stmt = $pdo->prepare(
        "SELECT 
            id,
            email,
            nama,
            wali_kelas_id
         FROM users
         WHERE role = 'guru'
         ORDER BY nama"
    );

    $stmt->execute();
    $data = $stmt->fetchAll();

    send_json([
        'success' => 1,
        'guru' => $data
    ]);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
