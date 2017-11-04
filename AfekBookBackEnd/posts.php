<?php
/**
 * Created by PhpStorm.
 * User: RanEndelman
 * Date: 04/11/2017
 * Time: 15:10
 */


header("Access-Control-Allow-Origin: *");
//STEP 1. Build a connection
// Secure way to build connection
$file = parse_ini_file("../../../AfekBook.ini");

// Store in php variables info from ini file variables
$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

// include access.php to use it's functions
require("secure/access.php");
$access = new access($host, $user, $pass, $name);
$access->connect();

// STEP 2. Check did pass data to this file?
if (!empty($_REQUEST["uuid"]) && !empty($_REQUEST["text"])) {
    $id = htmlentities($_REQUEST["id"]);
    $uuid = htmlentities($_REQUEST["uuid"]);
    $text = htmlentities($_REQUEST["text"]);

//    Create folder in the server to store post's pics
    $folder = "/Application/XAMPP/xamppfiles/htdocs/AfekBook/AfekBookBackEnd/posts/" . $id;
    if (!file_exists($folder)) {
        mkdir($folder, 0777, true);
    }
    $folder = $folder . "/" . basename($_FILES["file"]["name"]);
    if (move_uploaded_file($_FILES["file"]["tmp_name"], $folder)) {
        $returnArray["message"] = "Post has been made with picture";
        $path = "http://localhost/AfekBook/AfekBookBackEnd/posts/" . $id . "/post-" . $uuid . ".jpg";
    } else {
        $returnArray["message"] = "Post has been made without picture";
        $path = "";
    }

//  Save the post info in DB
    $access->insertPost($id, uuid, $text, $path);

}

// STEP 3. Close connection
$access->disconnect();

// STEP 4. Feedback info
echo  json_encode($returnArray);

?>