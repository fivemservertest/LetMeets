<?php 

	include 'conn.php';

	$room_id = $_GET['room_id'];


	$queryResult=$connect -> query("SELECT * FROM tb_reservation join tb_user on tb_reservation.user_id=tb_user.user_id where room_id ='$room_id' and status=1");

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>