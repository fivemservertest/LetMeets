<?php

include 'conn.php';

$file = $_FILES['file']['name'];
$team_name = $_POST['team_name'];

	if(!is_dir("upload/". $team_name ."/")) {
    mkdir("upload/". $team_name ."/");
}	
$path = "upload/".$team_name."/".$file."";
move_uploaded_file($_FILES['file']['tmp_name'],$path);

$sqlch = "SELECT * from tb_fileteam where team_name='".$team_name."' AND file_name = '".$file."'";
$resultch = $connect->query($sqlch);
if ($resultch->num_rows < 1	) {
	$sql = "INSERT INTO tb_fileteam
	(team_name,file_name)  VALUES ('" . $team_name . "','" . $file . "')";
$result = $connect->query($sql);
echo json_encode("suc");
}else{
echo json_encode("fail");
}



