<?php

include 'conn.php';
$username = $_POST['username'];
$sql = "SELECT * FROM tb_user WHERE username = '".$username."' AND permission = 'Managers'";
$result = $connect->query($sql);
$resultt = array();


if ($result->num_rows > 0) {
    while ($row = mysqli_fetch_array($result)) {
        $resultt[] = $row;
    }

    echo json_encode("pass");
} else {
    echo json_encode("Error");
}