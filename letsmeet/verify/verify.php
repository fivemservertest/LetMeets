<?php

include 'conn.php';
if (isset($_POST['user_id'])) {
	if ($_POST['check'] == 'verify') {
		$user_id = $_POST['user_id'];
		$sql = "UPDATE tb_user  SET verify_account = '1'  WHERE user_id = '$user_id' ";
		$query = $connect->query($sql);
		echo json_encode('success');
	} else if ($_POST['check'] == 'reject') {
		$user_id = $_POST['user_id'];
		$comment = $_POST['comment'];
		$sql = "UPDATE tb_user  SET verify_account = '2', comment =  '$comment'  WHERE user_id = '$user_id' ";
		$query = $connect->query($sql);
		echo json_encode('success');
	}
}
