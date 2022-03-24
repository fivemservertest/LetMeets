<?php

include 'conn.php';


$user_id = $_GET['user_id'];



$queryResult = $connect->query("SELECT * FROM tb_user WHERE user_id = $user_id");

//	$result = array ();

while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);
