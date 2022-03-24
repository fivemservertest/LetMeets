<?php
$servername = "localhost";
$username = "root";
$password = "";
$db = "letsmeet";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $db);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

$username = $_POST['username'];
$password = $_POST['password'];


$sql = "SELECT * FROM tb_user WHERE username = '" . $username . "' AND password = '" . $password . "'";
$result = $conn->query($sql);
$resultt = array();
if ($result->num_rows > 0) {
    while ($row = mysqli_fetch_array($result)) {
        $resultt[] = $row;
    }
    echo json_encode($resultt);
} else {
    echo json_encode("Error");
}
