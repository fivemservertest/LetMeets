<?php 

	include 'conn.php';


	$room_id = $_GET['room_id'];
	$user_id = $_GET['user_id'];


	$queryResult=$connect -> query("SELECT 
		tb_reservation.reserve_id,
		tb_reservation.room_id,
		tb_reservation.user_id,
		tb_reservation.dateTime,
		tb_reservation.datein,
		tb_reservation.dateout,
		tb_reservation.status,
		tb_meetingroom.name
	 FROM tb_reservation join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id join tb_inmeeting on tb_reservation.reserve_id=tb_inmeeting.reserve_id where tb_reservation.room_id = '$room_id' && dateout >=CURDATE() && tb_reservation.status='1' && tb_inmeeting.user_id = '$user_id' && tb_inmeeting.Invitestatus =1 group by tb_reservation.reserve_id order by tb_reservation.datein asc");

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>