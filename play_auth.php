<?php

$ip = $_SERVER['REMOTE_ADDR'];

$valid_ips = file('/auth/ips.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

if (in_array($ip, $valid_ips)) {
    // If the key is valid, allow publishing
    http_response_code(200);
    echo "OK";
} else {
    // If the key is invalid, deny publishing
    http_response_code(403);
    echo "Forbidden";
}