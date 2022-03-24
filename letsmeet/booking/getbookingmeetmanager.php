<?php 

	include 'conn.php';


	$room_id = $_GET['room_id'];
	$user_id = $_GET['user_id'];




	$queryResult=$connect -> query("SELECT * FROM tb_reservation join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id where  
		tb_reservation.room_id = '$room_id' && dateout >=CURDATE() && tb_reservation.status='1' && tb_reservation.user_id='$user_id' 
		group by tb_reservation.reserve_id order by tb_reservation.datein asc");

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>