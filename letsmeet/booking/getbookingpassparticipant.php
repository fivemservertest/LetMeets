<?php 

	include 'conn.php';

	$user_id = $_GET['user_id'];


	$queryResult=$connect -> query("SELECT * FROM tb_inmeeting join tb_reservation on tb_inmeeting.reserve_id = tb_reservation.reserve_id join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id join tb_user on tb_user.user_id=tb_reservation.user_id where tb_inmeeting.user_id ='$user_id' && tb_inmeeting.Invitestatus='1' && tb_reservation.status='1' && dateout <=CURDATE() group by tb_reservation.reserve_id order by tb_reservation.datein asc");

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>