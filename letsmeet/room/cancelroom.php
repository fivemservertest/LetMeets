<?php
	include 'conn.php';
	
	$room_id = $_POST['room_id'];
	
	
	
	
		$connect->query("UPDATE tb_meetingroom set status='0' where room_id ='$room_id'");
		
	
	
	
	

?>

