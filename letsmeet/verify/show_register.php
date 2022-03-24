<?php

include 'conn.php';
$sql = "SELECT * FROM tb_user WHERE verify_account= '0' ";
$query = $connect->query($sql);
$resultquery = array();
while ($fetchData = $query->fetch_assoc()) {
	$resultquery[] = $fetchData;
	
}echo json_encode($resultquery);