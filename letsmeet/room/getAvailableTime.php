<?php 

	include 'conn.php';

	$room_id = $_GET['room_id'];
	//$date = $_GET['date'];


	$queryResult=$connect -> query("SELECT * FROM tb_reservation where room_id ='$room_id'");

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>