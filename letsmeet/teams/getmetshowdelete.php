<?php

include 'conn.php';

$team_id = $_GET['team_id'];
$datetime = new DateTime( "now", new DateTimeZone( "Asia/Bangkok" ) );
$timeS = $datetime->format( 'Y-m-d H:i:s' );  


$queryResult = $connect->query("SELECT * FROM tb_reservation join tb_meetingroom on tb_reservation.room_id=tb_meetingroom.room_id 
 WHERE tb_reservation.team_id ='$team_id'  AND tb_reservation.status ='1' && datein > '$timeS' order by datein asc " );

$result = array();
while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);
