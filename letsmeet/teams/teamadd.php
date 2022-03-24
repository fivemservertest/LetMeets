<?php
include 'conn.php';
error_reporting(0);
$team_name = $_POST['team_name'];
$team_description = $_POST['team_description'];
$username = $_POST['username'];

$sql = "SELECT * from tb_teams where team_name='".$team_name."'";
$result = $connect->query($sql);
$resultt = array();
if ($result->num_rows < 1) {
    while ($row = mysqli_fetch_assoc($result)) {
        $resultt[] = $row;
    }
    if ($connect->query("INSERT INTO tb_teams(team_name,team_description,username)VALUES('" . $team_name . "','" . $team_description . "','".$username."')")) {
		$sqlch = "SELECT username,firstname,lastname FROM tb_user WHERE username='".$username."'";
		$resultch = $connect->query($sqlch);
		$resulttch = array();
	    while ($row = mysqli_fetch_assoc($resultch)) {
        $resulttch[] = $row;
		if($resulttch[0]['firstname'] != null){
		$username = $resulttch[0]['username'];
		$firstname = $resulttch[0]['firstname'];
		$lastname = $resulttch[0]['lastname'];
			
		$sqlchk = "INSERT INTO tb_memberteams(team_name,username,firstname,lastname,status)  VALUES ('" . $team_name . "','" . $username . "','" . $firstname . "','" . $lastname . "','Host')";
			$chk = $connect->query($sqlchk);
			echo json_encode("success");
		}
		else {
    echo json_encode("fail3");
		
	}
   
}
}else{
	    echo json_encode("fail2");
}
}else {
    echo json_encode("fail1");
}