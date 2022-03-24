<?php 

	include 'conn.php';
if(isset($_GET['search'])){
	$search = $_GET['search'];
	$queryResult=$connect -> query("SELECT *,ifnull(tb_inmeeting.user_id,tb_user.user_id) as user_id FROM tb_user left join tb_inmeeting on tb_user.user_id=tb_inmeeting.user_id left join tb_reservation on tb_inmeeting.reserve_id=tb_reservation.reserve_id where tb_user.permission = 'Participant' && (tb_user.firstname like '%$search%' || tb_user.lastname like '%$search%' || tb_user.department like '%$search%' ) group by tb_user.user_id");
}else{
	$queryResult=$connect -> query("SELECT *,ifnull(tb_inmeeting.user_id,tb_user.user_id) as user_id FROM tb_user left join tb_inmeeting on tb_user.user_id=tb_inmeeting.user_id left join tb_reservation on tb_inmeeting.reserve_id=tb_reservation.reserve_id where tb_user.permission = 'Participant' group by tb_user.user_id");
}

		

	

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>