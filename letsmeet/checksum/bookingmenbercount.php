<?php 

	include 'conn.php';
    $room_id=$_GET['room_id'];
	$datein = $_GET['datein'];
	$in2 = strtotime($datein);
	$in = date('Y-m-d H:i:s',$in2);
	$dateout = $_GET['dateout'];
	$out2 = strtotime($dateout);
	$out = date('Y-m-d H:i:s',$out2);

	$queryResult=$connect -> query("Select * from tb_reservation join tb_inmeeting on tb_reservation.reserve_id=tb_inmeeting.reserve_id where room_id ='$room_id' && tb_reservation.datein between '$in' and '$out' && tb_reservation.status='1' GROUP by tb_inmeeting.inmeeting_id");


    echo json_encode($queryResult->num_rows);
    /*if($queryResult->num_rows > 0){
		$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);
	}else{
        echo json_encode("Error");
    }*/
	

?>