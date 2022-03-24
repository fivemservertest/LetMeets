<?php

include 'conn.php';

$userid_host = $_GET['userid_host'];

$queryResult = $connect->query("SELECT * FROM tb_user  WHERE user_id=$userid_host");

$result = array();
while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);
