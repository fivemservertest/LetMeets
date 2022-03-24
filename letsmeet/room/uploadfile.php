<?php

include 'conn.php';

$file = $_FILES['file']['name'];
$reserve_id = $_POST['reserve_id'];

if (!is_dir("upload/" . $reserve_id . "/")) {
	mkdir("upload/" . $reserve_id . "/");
}
$path = "upload/" . $reserve_id . "/" . $file . "";
move_uploaded_file($_FILES['file']['tmp_name'], $path);

$sqlch = "SELECT * from tb_fileteam where reserve_id = '" . $reserve_id . "' AND room_file = '" . $file . "'";
$resultch = $connect->query($sqlch);
if ($resultch->num_rows < 1) {
	$sql = "INSERT INTO tb_fileroom (reserve_id , room_file)  VALUES ('" . $reserve_id . "','" . $file . "')";
	$result = $connect->query($sql);
	echo json_encode("suc");
} else {
	echo json_encode("fail");
}
