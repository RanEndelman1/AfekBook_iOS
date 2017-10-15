<?php
/**
 * Created by PhpStorm.
 * User: RanEndelman
 * Date: 14/10/2017
 * Time: 16:44
 */
// Declare Class to access this php file
class  access
{

//    Connection global variables
    var $host = null;
    var $user = null;
    var $pass = null;
    var $name = null;
    var $conn = null;
    var $result = null;

    function __construct($dbhost, $dbuser, $dbname, $dbpass)
    {
        $this->host = $dbhost;
        $this->user = $dbuser;
        $this->pass = $dbpass;
        $this->name = $dbname;
    }

//        Establish connection and store it in $conn
    public function connect()
    {
        $this->conn = new mysqli($this->host, $this->user, $this->pass, $this->name);

        if (mysqli_connect_errno()) {
            echo 'Could not connect to DB';
        }
//        Set the connection to support all languages
        $this->conn->set_charset("utf8");
    }

    public function disconnect()
    {
        if ($this->conn != null) {
            mysqli_close($this->conn);
        }
    }

//    Insert User details
    public function registerUser($username, $password, $salt, $email, $fullname) {
        $sql = "INSERT INTO users SET username=?, password=?, salt=?, email=?, fullname=?";
        $statement = mysqli_prepare($this->conn, $sql);
        if (!$statement) {
            throw new Exception($statement->error);
        }
        $statement->bind_param("sssss", $username, $password, $salt, $email, $fullname);
        $result = $statement->execute();
        return $result;
    }

    public function selectUser($username) {
        $sql = "SELECT * FROM users WHERE username='".$username."'";
        $result = mysqli_query($this->conn, $sql);

        if ($result != null && (mysqli_num_rows($result) >= 1)) {
            $row = $result->fetch_array(MYSQLI_ASSOC);
            if (!empty($row)) {
                $returnArray = $row;
            }
        }
        return $returnArray;
    }
}


?>