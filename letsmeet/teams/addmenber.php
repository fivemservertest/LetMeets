<?php
include 'conn.php';

$team_name = $_POST['team_name'];
$username = $_POST['username'];
$firstname = $_POST['firstname'];
$lastname = $_POST['lastname'];

$sql = "SELECT * from tb_memberteams WHERE username = '".$username."' AND team_name = '".$team_name."'";
$result = $connect->query($sql);
if ($result->num_rows < 1	) {
	$sql = "INSERT INTO tb_memberteams
	(team_name,username,firstname,lastname,status)  VALUES ('" . $team_name . "','" . $username . "','" . $firstname . "','" . $lastname . "','member')";
$result = $connect->query($sql);
echo json_encode('add member');
	}
else{
		echo json_encode('dupicate member');
	}	