<?php 

	include 'conn.php';

	$team_id = $_GET['team_id'];


	$queryResult=$connect -> query("SELECT * FROM tb_reservation  join tb_user on tb_reservation.user_id=tb_user.user_id join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id where team_id ='$team_id' and tb_reservation.status='1' ");

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>