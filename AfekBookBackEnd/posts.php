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
    echo file_exists($folder);
    $folder = $folder . "/" . basename($_FILES["file"]["name"]);
    if (move_uploaded_file($_FILES["file"]["tmp_name"], $folder)) {
        $returnArray["message"] = "Post has been made with picture";
        $path = "http://localhost/AfekBook/AfekBookBackEnd/posts/" . $id . "/post-" . $uuid . ".jpg";
    } else {
        $returnArray["message"] = "Post has been made without picture";
        $path = "";
    }

//  Save the post info in DB
    $access->insertPost($id, $uuid, $text, $path);
// If data not passed -> show posts
} else if (!empty($_REQUEST["uuid"]) && empty($_REQUEST["id"])) {


    // STEP 2.1 Get uuid of post and path to post picture passed to this php file via swift POST
    $uuid = htmlentities($_REQUEST["uuid"]);
    $path = htmlentities($_REQUEST["path"]);

    // STEP 2.2 Delete post according to uuid
    $result = $access->deletePost($uuid);

    if (!empty($result)) {
        $returnArray["message"] = "Successfully deleted";
        $returnArray["result"] = $result;


        // STEP 2.3 Delete file according to its path and if it exists
        if (!empty($path)) {
            $path = str_replace("http://localhost/", "/Applications/XAMPP/xamppfiles/htdocs/", $path);

            // file deleted successfully
            if (unlink($path)) {
                $returnArray["status"] = "1000";
                // could not delete file
            } else {
                $returnArray["status"] = "400";
            }
        }


    } else {
        $returnArray["message"] = "Could not delete post";
    }


// if data are not passed - show posts except id of the user
} else {


    // STEP 2.1 Pass POST / GET via html encryp and assign passed id of user to $id var
    $id = htmlentities($_REQUEST["id"]);


    // STEP 2.2 Select posts + user related to $id
    $posts = $access->selectPosts($id);

    // STEP 2.3 If posts are found, append them to $returnArray
    if (!empty($posts)) {
        $returnArray["posts"] = $posts;
    }


}

// STEP 3. Close connection
$access->disconnect();

// STEP 4. Feedback info
echo json_encode($returnArray);

?>