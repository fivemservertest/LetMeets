<?php 

	include 'conn.php';

$user_id = $_GET['user_id'];
			$queryResult=$connect -> query("SELECT *,ifnull(tb_inmeeting.user_id,tb_user.user_id) as user_id FROM tb_user left join tb_inmeeting on tb_user.user_id=tb_inmeeting.user_id left join tb_reservation on tb_inmeeting.reserve_id=tb_reservation.reserve_id left join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id where tb_user.permission = 'Participant' && tb_inmeeting.Invitestatus='0' && tb_user.user_id='$user_id' && dateout >=CURDATE()" );

	

	$result = array ();

while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);
	

?>