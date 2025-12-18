<?php
require_once 'api_common.php';
try {
	$hash = password_hash('admin123', PASSWORD_DEFAULT);
	send_json(['success' => 1, 'hash' => $hash]);
} catch (Throwable $e) {
	handle_exception_and_respond($e);
}
