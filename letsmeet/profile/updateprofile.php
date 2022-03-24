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
$department = $_POST['department'];
$user_id = $_POST['user_id'];

if($_FILES['image'] !=""){

$datetime = date("dmYHis");
$file_name = substr($_FILES['image']['name'], -4);
$images = $datetime . '_driversss' . $file_name;
move_uploaded_file($_FILES["image"]["tmp_name"], "../login_logout/upload/" . $images);

$conn->query("UPDATE tb_user SET 
        username ='" . $username . "',
        firstname='" . $firstname . "',
        lastname='" . $surname . "' , 
        email='" . $email . "',
        age='" . $age . "', 
        password='" . $password . "',
        department='" . $department . "',
		image='" . $images . "'
         WHERE  user_id =" . $user_id);

}else{

$conn->query("UPDATE tb_user SET 
        username ='" . $username . "',
        firstname='" . $firstname . "',
        lastname='" . $surname . "' , 
        email='" . $email . "',
        age='" . $age . "', 
        password='" . $password . "',
        department='" . $department . "'
         WHERE  user_id =" . $user_id);


}


