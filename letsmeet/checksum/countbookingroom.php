<?php

include 'conn.php';
	
	$room_id=$_GET['room_id'];
	$queryResult = $connect->query("SELECT COUNT(reserve_id) AS total  FROM tb_reservation WHERE room_id='$room_id'" );


$result = array();

while ($fetchData = $queryResult->fetch_assoc()) {
	$result[] = $fetchData;
}

echo json_encode($result);