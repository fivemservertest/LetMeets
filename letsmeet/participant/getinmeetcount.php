<?php 

	include 'conn.php';

$reserve_id = $_GET['reserve_id'];
			$queryResult=$connect -> query("SELECT * FROM tb_inmeeting where tb_inmeeting.reserve_id='$reserve_id' && Invitestatus=1 group by tb_inmeeting.user_id");

	$num = $queryResult->num_rows;


	echo json_encode($num);
?>