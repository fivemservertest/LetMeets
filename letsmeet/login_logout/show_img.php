<?php 

	include 'conn.php';

	$queryResult=$connect -> query("SELECT image FROM tb_user ");

//	$result = array ();

	while ($fetchData = $queryResult->fetch_assoc()) {
		$result[] = $fetchData;
	}

	echo json_encode($result);

?>