<?php

include 'conn.php';
    
    $search=$_GET['search'];
    $queryResult = $connect->query("SELECT *  FROM tb_meetingroom join tb_reservation on tb_meetingroom.room_id = tb_reservation.room_id  
    where  DATE_FORMAT(tb_reservation.datein, '%M %Y') = '$search' &&  tb_meetingroom.status ='1'  group by tb_reservation.room_id " );


$result = array();

while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);