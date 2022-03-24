<?php 
	include 'conn.php';

$reserve_id =$_GET['reserve_id'];

			$queryResult=$connect->query("SELECT * FROM tb_inmeeting join tb_user on tb_inmeeting.user_id=tb_user.user_id where tb_inmeeting.reserve_id='$reserve_id' group by tb_user.user_id");

	

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);
	
?>