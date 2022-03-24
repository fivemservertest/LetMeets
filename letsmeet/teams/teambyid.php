<?php

include 'conn.php';

if (isset($_GET['team_name'])) {
    $team_name = $_GET['team_name'];
    $queryResult = $connect->query("SELECT * FROM tb_teams where team_name =  '".$team_name."' ");
} else {
 echo json_encode("emptydata");
}
$result = array();
while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);
