<?php
/**
 * Created by PhpStorm.
 * User: RanEndelman
 * Date: 15/10/2017
 * Time: 12:58
 */

// STEP 1. Verify income data
$token = htmlentities($_GET["token"]);
if (empty($token)) {
    echo 'Missing info';
}

//STEP 2. Establish connection to DB
// Secure way to build connection
$file = parse_ini_file("../../../../AfekBook.ini");

// Store in php variables info from ini file variables
$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

// include access.php to use it's functions
require("../secure/access.php");
$access = new access($host, $user, $name, $pass);
$access->connect();

// STEP 3. Get user's ID
$id = $access->getUserID($token);
if (empty($id["id"])) {
    echo "Could not confirm user, try to register again.";
    return;
}

// STEP 4. Change status of 'emailConfirmed' and delete token
$result = $access->emailConfirmationStatus(1, $id["id"]);

// Delete the token from the emailTokens Table
if ($result) {
    $access->deleteToken($id["id"]);
    echo 'Thank you, your email is now confirmed!';
}

// STEP 5. Close connection
$access->disconnect();
?>