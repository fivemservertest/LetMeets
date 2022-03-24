<?php

include 'conn.php';

$username = $_POST['username'];
$checkedin = $_POST['checkedin'];
$checkedout = $_POST['checkedout'];
$reser_id = $_POST['reser_id'];


if ($checkedin == 'true') {
    $sql = "SELECT * from tb_checkmeet WHERE chk_name = '$username' AND  chk_reservation = '$reser_id'";
    $result = $connect->query($sql);
    if ($result->num_rows < 1) {
        $connect->query("INSERT INTO tb_checkmeet (chk_reservation,chk_name,chk_status) value ('$reser_id','$username','Presented')");
    } else {
        $connect->query("UPDATE  tb_checkmeet  SET chk_status='Presented' where chk_name='$username'AND  chk_reservation = '$reser_id'");
    }
    //ตรวจสอบ
} else {
    $sql = "SELECT * from tb_checkmeet WHERE chk_name = '$username' AND  chk_reservation = '$reser_id' ";
    $result = $connect->query($sql);
    if ($result->num_rows < 1) {
        $connect->query("INSERT INTO tb_checkmeet (chk_reservation,chk_name,chk_status) value ('$reser_id','$username','Absented')");
    } else {
        $connect->query("UPDATE  tb_checkmeet SET chk_status='Absented' where chk_name='$username' AND  chk_reservation = '$reser_id'");
    }
}
