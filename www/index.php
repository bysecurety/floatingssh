<?php

ini_set(‘display_errors’, ‘on’); 
error_reporting(E_ALL); 


$servername = "localhost";
$username = "FSSH"; 
$password = ""; 
$databasename = "floatingssh";

// CREATE CONNECTION
$conn = new mysqli($servername,
        $username, $password, $databasename);

// GET CONNECTION ERRORS
if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
}

// SQL QUERY
$query = "SELECT * FROM sshports;";

// FETCHING DATA FROM DATABASE
$result = $conn->query($query);

        if ($result->num_rows > 0)
        {
                // OUTPUT DATA OF EACH ROW
                while($row = $result->fetch_assoc())
                {
                        echo "ID: " .
                                $row["id"]. " - Host: " .
                                $row["host"]. " | Date: " .
                                $row["date"]. " | Port Num: " .
                                $row["portnum"]. "<br>";
                }
        }
        else {
                          echo "0 results";
        }

$conn->close();

?>

