<?php 

	include 'conn.php';

$inmeeting_id = $_GET['inmeeting_id'];
			$queryResult=$connect -> query("SELECT *,tb_user.firstname as inviter FROM tb_inmeeting left join tb_reservation on tb_inmeeting.reserve_id=tb_reservation.reserve_id left join tb_user on tb_reservation.user_id=tb_user.user_id where tb_inmeeting.inmeeting_id='$inmeeting_id' group by tb_user.user_id");

	

	$result = array ();
if($queryResult->num_rows > 0){
while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);
}else{
	echo json_encode("Error");
}
	

?>