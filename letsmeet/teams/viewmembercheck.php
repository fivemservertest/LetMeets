<?php

include 'conn.php';

if (isset($_GET['team_name'])) {
    $reser_id = $_GET['reser_id'];
    $team_name = $_GET['team_name'];
    $queryResult = $connect->query("SELECT * FROM tb_memberteams inner join tb_checkmeet on tb_memberteams.username = tb_checkmeet.chk_name  WHERE tb_memberteams.team_name = '$team_name' and tb_checkmeet.chk_reservation='$reser_id'");
} else {
 echo json_encode("emptydata");
}
$result = array();
while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);
