<?php
// List of valid keys

#$valid_keys = ['key1', 'key2', 'key3']; // Replace with your keys

#parse the keys from the file
$valid_keys = file('/auth/keys.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

$key = $_POST['name'];

if (in_array($key, $valid_keys)) {
    // If the key is valid, allow publishing
    http_response_code(200);
    echo "OK";
} else {
    // If the key is invalid, deny publishing
    http_response_code(403);
    echo "Forbidden";
}
?>
