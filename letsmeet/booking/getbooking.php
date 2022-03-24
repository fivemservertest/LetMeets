<?php 

	include 'conn.php';

	$user_id = $_GET['user_id'];
 	$timeold = date("Y-m-d");
	$datetime = new DateTime( "now", new DateTimeZone( "Asia/Bangkok" ) );
	$timeS = $datetime->format( 'Y-m-d H:i:s' );   

	if(isset($_GET['search'])){
		$search=$_GET['search'];

			$queryResult=$connect -> query("SELECT *,tb_reservation.status as meetstatus FROM tb_reservation join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id where tb_reservation.user_id ='$user_id'   
			&&  DATE_FORMAT(tb_reservation.dateout, '%Y-%m-%d') >= $timeold && DATE_FORMAT(tb_reservation.datein, '%Y-%m-%d') LIKE '%$search%'   group by tb_reservation.reserve_id order by tb_reservation.datein asc");

	}else{

		$queryResult=$connect -> query("SELECT *,tb_reservation.status as meetstatus FROM tb_reservation join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id where tb_reservation.user_id = '$user_id'  && datein > '$timeS'  
		  && DATE_FORMAT(tb_reservation.dateout, '%Y-%m-%d') >= $timeold
 			group by tb_reservation.reserve_id order by tb_reservation.datein asc");


	}


	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>