<?php
// api_common.php - common bootstrap for all API endpoints
// - sets JSON + CORS headers
// - converts PHP warnings/notices to exceptions
// - provides send_json() helper and exception handler

ini_set('display_errors', '0');
ini_set('html_errors', '0');
error_reporting(E_ALL);

// CORS and content-type headers (always set)
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Respond to OPTIONS preflight immediately
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

// Convert PHP errors/warnings/notices to ErrorException so they are caught
set_error_handler(function ($severity, $message, $file, $line) {
    // Respect @ operator
    if (error_reporting() === 0) {
        return false;
    }
    throw new ErrorException($message, 0, $severity, $file, $line);
});

// Exception handler — always return JSON
set_exception_handler(function ($e) {
    http_response_code(500);
    $msg = $e->getMessage();
    // hide internal details in production? Keep message for now per user request
    $resp = ['success' => 0, 'error' => $msg];
    echo json_encode($resp, JSON_UNESCAPED_UNICODE);
    exit;
});

// Fatal shutdown handler to capture fatal errors
register_shutdown_function(function () {
    $err = error_get_last();
    if ($err && ($err['type'] & (E_ERROR | E_PARSE | E_CORE_ERROR | E_COMPILE_ERROR))) {
        http_response_code(500);
        $resp = ['success' => 0, 'error' => $err['message']];
        echo json_encode($resp, JSON_UNESCAPED_UNICODE);
        exit;
    }
});

function send_json($data, $status = 200)
{
    if (!headers_sent()) {
        http_response_code($status);
        header('Content-Type: application/json; charset=utf-8');
    }
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function handle_exception_and_respond($e)
{
    $msg = $e instanceof Exception ? $e->getMessage() : (string)$e;
    send_json(['success' => 0, 'error' => $msg], 500);
}

// small helper for safe access (optional)
function input_post($key, $default = null)
{
    return $_POST[$key] ?? $default;
}

function input_get($key, $default = null)
{
    return $_GET[$key] ?? $default;
}

?>
