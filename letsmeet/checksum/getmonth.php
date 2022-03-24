<?php 

	include 'conn.php';


	$queryResult=$connect -> query("SELECT datein FROM tb_reservation GROUP by DATE_FORMAT(datein, '%m-%Y') ORDER by DATE_FORMAT(datein, '%Y-%m') ASC");

	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>