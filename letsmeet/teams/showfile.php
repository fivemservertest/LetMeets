<?php

include 'conn.php';

$team_name = $_GET['team_name'];

$sql = "SELECT file_name FROM tb_fileteam WHERE team_name = '".$team_name."'";

$result = $connect->query($sql);
$resultquery = array();
while ($fetchData = $result->fetch_assoc()) {
    $resultquery[] = $fetchData;
}

echo json_encode($resultquery);