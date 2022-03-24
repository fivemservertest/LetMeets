<?php

include 'conn.php';

$team_id = $_GET['team_id'];

$queryResult = $connect->query("SELECT * FROM tb_teams  WHERE team_id=$team_id  ");

$result = array();
while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);
