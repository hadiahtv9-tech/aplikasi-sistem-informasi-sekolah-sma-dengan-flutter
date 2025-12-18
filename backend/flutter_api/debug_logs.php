<?php
require_once 'api_common.php';
try {
    require_once 'db.php';

    $result = [
        'status' => 'ok',
        'message' => 'Debug endpoint working',
        'tips' => [
            '1. Jalankan Flutter app: flutter run -d chrome',
            '2. Coba login dengan siswa1@school.com / siswa123',
            '3. Lihat output di terminal saat login',
            '4. Logs akan muncul dengan emoji untuk tracking',
            '5. Check PHP error log di: C:\\xampp\\php\\logs\\php_error.log'
        ],
        'test_endpoints' => [
            'login' => 'POST /login.php with email & password',
            'create_user' => 'POST /create_user.php with nama, email, password, role',
            'get_user' => 'GET /get_user.php?uid=USER_ID'
        ],
        'valid_credentials' => [
            ['email' => 'admin@gmail.com', 'password' => 'admin123', 'role' => 'admin'],
            ['email' => 'guru1@school.com', 'password' => 'guru123', 'role' => 'guru'],
            ['email' => 'siswa1@school.com', 'password' => 'siswa123', 'role' => 'siswa']
        ]
    ];

    // Try to get users count as health check
    try {
        $stmt = $pdo->query('SELECT COUNT(*) as total FROM users');
        $count = $stmt->fetch();
        $result['database'] = [
            'status' => 'connected',
            'users_count' => $count['total'] ?? 0
        ];
    } catch (Throwable $e) {
        $result['database'] = ['status' => 'error', 'message' => $e->getMessage()];
    }

    send_json($result);
} catch (Throwable $e) {
    handle_exception_and_respond($e);
}
?>
