<?php 

	include 'conn.php';
    $user_id = $_GET['user_id'];

		$queryResult=$connect -> query("Select * from tb_inmeeting join tb_reservation on tb_inmeeting.reserve_id=tb_reservation.reserve_id where tb_inmeeting.user_id='$user_id'");

	

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>