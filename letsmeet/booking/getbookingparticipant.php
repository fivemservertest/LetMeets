<?php 

	include 'conn.php';

	$user_id = $_GET['user_id'];
	$timeold = date("Y-m-d");



	if(isset($_GET['search'])){
	$search=$_GET['search'];


	$queryResult=$connect -> query("SELECT * FROM tb_inmeeting join tb_reservation on tb_inmeeting.reserve_id = tb_reservation.reserve_id join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id where tb_inmeeting.user_id ='$user_id' && tb_inmeeting.Invitestatus='1' && tb_reservation.status='1'  && DATE_FORMAT(tb_reservation.dateTime, '%Y-%m-%d') LIKE '%$search%' group by tb_reservation.reserve_id order by tb_reservation.datein desc");


	}else{

		$queryResult=$connect -> query("SELECT * FROM tb_inmeeting join tb_reservation on tb_inmeeting.reserve_id = tb_reservation.reserve_id join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id where tb_inmeeting.user_id ='$user_id' && tb_inmeeting.Invitestatus='1' && tb_reservation.status='1' group by tb_reservation.reserve_id order by tb_reservation.datein asc");


	}


	

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>