<?php

include 'conn.php';


$fullname = $_GET['fullname'];
$status = $_GET['status'];

if ($status == 'Managers') {

if (isset($_GET['search'])) {
    $search = $_GET['search'];
    $fullname = $_GET['fullname'];
    $queryResult = $connect->query("SELECT * FROM tb_teams where team_name like '%$search%' AND username = '" . $fullname . "'  ");
} else {
    $queryResult = $connect->query("SELECT * FROM tb_teams WHERE username = '" . $fullname . "'");
}
$result = array();
while ($fetchData = $queryResult->fetch_assoc()) {
    $result[] = $fetchData;
}

echo json_encode($result);

} else {

    if (isset($_GET['search'])) {
        $search = $_GET['search'];
        $fullname = $_GET['fullname'];
        $queryResult = $connect->query("SELECT * FROM tb_teams  Inner Join
        tb_memberteams On tb_memberteams.team_name = tb_teams.team_name where tb_teams.team_name like '%$search%' AND tb_memberteams.username = '" . $fullname . "' ");
    } else {
        $queryResult = $connect->query("SELECT * FROM tb_teams  Inner Join
        tb_memberteams On tb_memberteams.team_name = tb_teams.team_name WHERE tb_memberteams.username = '" . $fullname . "'");
    }
    $result = array();
    while ($fetchData = $queryResult->fetch_assoc()) {
        $result[] = $fetchData;
    }

    echo json_encode($result);
}


// include 'conn.php';



// $fullname = $_GET['fullname'];
// $status = $_GET['status'];


// if (isset($_GET['search'])) {
//     $search = $_GET['search'];
//     $fullname = $_GET['fullname'];
//     if ($status == "Managers") {
//         $queryResult = $connect->query("SELECT * FROM tb_teams where team_name like '%$search%' AND username = '" . $fullname . "'  ");
//     } else {
//         $queryResult = $connect->query("SELECT * FROM tb_teams  Inner Join
//         tb_memberteams On tb_memberteams.team_name = tb_teams.team_name where tb_teams.team_name like '%$search%' AND tb_memberteams.username = '" . $fullname . "' ");
//     }

// } else {
//     if ($status == "Managers") {
//         $queryResult = $connect->query("SELECT * FROM tb_teams WHERE username = '" . $fullname . "'");
//     } else {
//         $queryResult = $connect->query("SELECT * FROM tb_teams  Inner Join
//         tb_memberteams On tb_memberteams.team_name = tb_teams.team_name WHERE tb_memberteams.username = '" . $fullname . "'");
//     }
// }

// $result = array();
// while ($fetchData = $queryResult->fetch_assoc()) {
//     $result[] = $fetchData;
// }

// echo json_encode($result);
