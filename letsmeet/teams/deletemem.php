<?php

include 'conn.php';

$username = $_POST['username'];
$team_name = $_POST['team_name'];

//ตรวจสอบ
$connect->query("DELETE FROM tb_memberteams  WHERE  username = '$username' and team_name = '$team_name' ");
