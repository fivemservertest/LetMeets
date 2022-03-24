<?php
	include 'conn.php';
	
	$response = $_GET['response'];
	$id = $_GET['id'];

	
	
	$connect->query("update tb_inmeeting set Invitestatus = '$response' where inmeeting_id ='$id'");


?>
