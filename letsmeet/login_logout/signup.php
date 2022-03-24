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
$email = $_POST['email'];
$firstname = $_POST['firstname'];
$surname = $_POST['surname'];
$username = $_POST['username'];
$password = $_POST['password'];
$age = $_POST['age'];
$permission = $_POST['permission'];
$department = $_POST['department'];


$upload = $_FILES['image']['name'];
$path = "upload/";
$type = strrchr($upload, ".");
$newname = $upload . $type;
$path_copy = $path . $newname;
move_uploaded_file($_FILES['image']['tmp_name'], $path_copy);


$sql = "SELECT * from tb_user WHERE username = '".$username."'";
$result = $conn->query($sql);
if ($result->num_rows < 1 ) {
$conn->query("INSERT INTO tb_user(username,password,firstname,lastname,email,age,verify_account,permission,department,image)VALUES('" . $username . "','" . $password . "','" . $firstname . "','" . $surname . "','" . $email . "','" . $age . "',0,'" . $permission . "','" . $department . "','" . $newname . "')");
echo json_encode('addmember');
    }
else{
        echo json_encode('dupicatemember');
    }	