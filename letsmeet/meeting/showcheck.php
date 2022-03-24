<?php 
	include 'conn.php';

$host_id =$_GET['host_id'];

			$queryResult=$connect -> query("SELECT * FROM tb_checkmeet WHERE chk_reservation = $host_id ");

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>