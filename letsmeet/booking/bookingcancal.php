<?php
	include 'conn.php';
	
	$meet_id = $_POST['meeting_id'];
	
	
	
	
		$connect->query("UPDATE tb_reservation set status='0' where reserve_id ='$meet_id'");
		
	
	
	
	

?>

