<?php
	include 'conn.php';
	
	$reserve_id = $_POST['reserve_id'];
	$user_id = $_POST['user_id'];

	
	
	$connect->query("INSERT INTO tb_inmeeting(reserve_id,user_id)VALUES('".$reserve_id."','".$user_id."')");


?>
