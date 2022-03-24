<?php 

	include 'conn.php';

	$room_id = $_GET['room_id'];
	$user_id = $_GET['user_id'];


	$queryResult=$connect -> query("SELECT * FROM tb_reservation join tb_user on tb_reservation.user_id=tb_user.user_id where room_id ='$room_id' and status=1 and tb_reservation.user_id='$user_id'");

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>