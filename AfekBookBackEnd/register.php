<?php
/**
 * Created by PhpStorm.
 * User: RanEndelman
 * Date: 14/10/2017
 * Time: 17:00
 */

//STEP 1. Declare params of user info
// Securing info and storing variables
$username = htmlentities($_REQUEST["username"]);
$password = htmlentities($_REQUEST["password"]);
$email = htmlentities($_REQUEST["email"]);
$fullname = htmlentities($_REQUEST["fullname"]);

// if GET or POST are empty
if (empty($username) || empty($password) || empty($email) || empty($fullname)) {
    $returnArray["status"] = "400";
    $returnArray["messages"] = "Missing required info";
    echo json_encode($returnArray);
    return;
}

// Secure password
$salt = openssl_random_pseudo_bytes(20);
$secure_password = sha1($password . $salt);

//STEP 2. Build a connection
// Secure way to build connection
$file = parse_ini_file("../../../AfekBook.ini");

// Store in php variables info from ini file variables
$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

// include access.php to use it's functions
require("secure/access.php");
$access = new access($host, $user, $name, $pass);
$access->connect();

//STEP 3. Insert user info
$result = $access->registerUser($username, $secure_password, $salt, $email, $fullname);
if ($result) {
    $user = $access->selectUser($username);
    $returnArray["status"] = "200";
    $returnArray["messages"] = "Successfully registered ";
    $returnArray["id"] = $user["id"];
    $returnArray["username"] = $user["username"];
    $returnArray["email"] = $user["email"];
    $returnArray["fullname"] = $user["fullname"];
    $returnArray["ava"] = $user["ava"];
} else {
    $returnArray["status"] = "400";
    $returnArray["messages"] = "Could not register with provided info";
}

// STEP 4. Close connection
$access->disconnect();

// STEP 5. JSON data
echo json_encode($returnArray);

?>