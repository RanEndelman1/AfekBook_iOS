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

    function __construct($dbhost, $dbuser, $dbpass, $dbname)
    {
        $this->host = $dbhost;
        $this->user = $dbuser;
        $this->pass = $dbpass;
        $this->name = $dbname;
    }

//        Establish connection and store it in $conn
    public function connect()
    {

        $this->conn = mysqli_connect($this->host,$this->user,$this->pass,$this->name); 

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
    public function registerUser($username, $password, $salt, $email, $fullname)
    {
        $sql = "INSERT INTO users SET username=?, password=?, salt=?, email=?, fullname=?";
        $statement = mysqli_prepare($this->conn, $sql);
        if (!$statement) {
            throw new Exception($statement->error);
        }
        $statement->bind_param("sssss", $username, $password, $salt, $email, $fullname);
        $result = $statement->execute();
        return $result;
    }

    public function selectUser($username)
    {
        $sql = "SELECT * FROM users WHERE username='" . $username . "'";
        $result = mysqli_query($this->conn, $sql);

        if ($result != null && (mysqli_num_rows($result) >= 1)) {
            $row = $result->fetch_array(MYSQLI_ASSOC);
            if (!empty($row)) {
                $returnArray = $row;
            }
        }
        return $returnArray;
    }

//    Function to save confirmation email message's token
    public function saveToken($table, $id, $token)
    {
        $sql = "INSERT INTO $table SET id=?, token=?";
        $statement = mysqli_prepare($this->conn, $sql);
        if (!$statement) {
            throw new Exception($statement->error);
        }
        $statement->bind_param("is", $id, $token);
        $result = $statement->execute();
        return $result;
    }

//    Get user's ID via token
    public function getUserID($token) {
        $sql = "SELECT id FROM emailTokens WHERE token = '".$token."'";
        $result = mysqli_query($this->conn, $sql);
        if ($result != null && mysqli_num_rows($result) >= 1) {
            $row = $result->fetch_array(MYSQLI_ASSOC);
            if (!empty($row)) {
                return $row;
            }
        }
        return null;
    }

    public function emailConfirmationStatus($status, $id) {
        $sql = "UPDATE users SET emailConfirmed=? WHERE id=?";
        $statement = mysqli_prepare($this->conn, $sql);
        if (!$statement) {
            throw new Exception($statement->error);
        }
        $statement->bind_param("ii", $status, $id);
        $result = $statement->execute();
        return $result;
    }

    public function deleteToken($id) {
        $sql = "DELETE FROM emailTokens WHERE id=?";
        $statement = mysqli_prepare($this->conn, $sql);
        if (!$statement) {
            throw new Exception($statement->error);
        }
        $statement->bind_param("i", $id);
        $result = $statement->execute();
        return $result;
    }

    public function getUser($username) {

        // declare array to store all information we got
        $returnArray = array();
      

        // sql statement
        $sql = "SELECT * FROM users WHERE username='".$username."'";

      
        echo $sql;
        echo "<br>";

        // execute / query $sql
        $result = mysqli_query($this->conn,"SELECT * FROM users WHERE username='$username'");



        // if we got some result
        if ($result != null && (mysqli_num_rows($result) >= 1)) {

            // assign result to $row as assoc array
            $row = $result->fetch_array(MYSQLI_ASSOC);

            // if assigned to $row. Assign everything $returnArray
            if (!empty($row)) {
                $returnArray = $row;
            }
        }
        else

        return $returnArray;

    }


}


?>