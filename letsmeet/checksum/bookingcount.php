<?php 

    include 'conn.php';
    $room_id = $_GET['room_id'];
    $search = $_GET['search'];


    $queryResult=$connect -> query("SELECT * FROM tb_meetingroom left join tb_reservation on tb_meetingroom.room_id=tb_reservation.room_id
     where  DATE_FORMAT(tb_reservation.datein, '%d') between 01 and 31 && tb_meetingroom.room_id='$room_id' && tb_reservation.status='1' && DATE_FORMAT(tb_reservation.datein, '%M %Y') = '$search'  
     GROUP by tb_reservation.dateTime");
    echo json_encode($queryResult->num_rows);
    /*$result = array ();

    while ($fetchData = $queryResult->fetch_assoc()) {
        $result[] = $fetchData;
    }

    echo json_encode($result);*/

?>