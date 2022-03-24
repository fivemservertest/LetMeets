<?php
	include 'conn.php';

 
	$room_id = $_POST['room_id'];     
	$user_id = $_POST['user_id'];     
	$datein = $_POST['bookingin'];     
	$dateout = $_POST['bookingout'];
	$in2 = strtotime($datein);     
	$in = date('Y-m-d H:i:s',$in2);     
	$out2 = strtotime($dateout);     
	$out = date('Y-m-d H:i:s',$out2);       
	date_default_timezone_set('Asia/Bangkok');  
	$chk = strtotime('23:59:59'); 
	$chk1 = date('H:i:s', $chk);

if($out < $chk1 && $in > $out || $in == $out){

	echo json_encode('timeout'); 
}else{

	$queryResultt = $connect->query("SELECT * from tb_reservation join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id where tb_reservation.status='1' and tb_reservation.room_id = '$room_id' && 
	(('$in' between tb_reservation.datein and tb_reservation.dateout || '$out' between tb_reservation.datein and tb_reservation.dateout) ||
	 (tb_reservation.datein between '$in' and '$out' || tb_reservation.dateout between '$in' and '$out' ))  group by tb_reservation.reserve_id");
	if($queryResultt->num_rows > 0){
		echo json_encode("Error");
	}else{
		$connect->query("INSERT INTO tb_reservation(room_id,user_id,datein,dateout)VALUES('".$room_id."','".$user_id."','".$in."','".$out."')");
		$queryResult = $connect->query("SELECT * from tb_reservation join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id where tb_reservation.room_id = '$room_id' && tb_reservation.user_id = '$user_id' && tb_reservation.datein='$in' && tb_reservation.dateout='$out' group by tb_reservation.reserve_id");
		
		$result = array ();
	
		while ($fetchData = $queryResult->fetch_assoc()) {
			$result[] = $fetchData;
		}
	
		echo json_encode($result);
	}

}

	

    // echo ($out3);


	
	