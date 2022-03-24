<?php

include 'conn.php';

if (isset($_GET['search'])) {
    $search = $_GET['search'];
    $teamname = $_GET['teamname'];
    $queryResult = $connect->query("SELECT * FROM tb_user where  tb_user.permission = 'Participant' AND tb_user.verify_account = 1 AND tb_user.username  like '%$search%'   AND NOT  EXISTS (SELECT * FROM tb_memberteams WHERE tb_user.username = tb_memberteams.username AND NOT tb_memberteams.team_name != '$teamname' )");
} else {
$teamname = $_GET['teamname'];
    $queryResult = $connect->query("SELECT *
FROM tb_user
WHERE tb_user.permission = 'Participant' AND tb_user.verify_account = 1 AND NOT  EXISTS (SELECT * FROM tb_memberteams WHERE tb_user.username = tb_memberteams.username AND NOT tb_memberteams.team_name != '$teamname' )");
}
$result = array();
while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);