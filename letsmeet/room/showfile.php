<?php

include 'conn.php';

$reser_id = $_GET['reser_id'];

$sql = "SELECT room_file FROM tb_fileroom WHERE reserve_id = '".$reser_id ."'";

$result = $connect->query($sql);
$resultquery = array();
while ($fetchData = $result->fetch_assoc()) {
    $resultquery[] = $fetchData;
}

echo json_encode($resultquery);