<?php

include 'conn.php';

date_default_timezone_set('Asia/Bangkok');  
$white = "";
$pro = "";
$pod = "";
$mic = "";
$com = "";
// $datein =$_GET['start'];
// $dateout=$_GET['end'];
// $in2 = strtotime($datein);     
// $in = date('Y-m-d H:i:s',$in2);     
// $out2 = strtotime($dateout);     
// $out = date('Y-m-d H:i:s',$out2);       
// $chk = strtotime('23:59:59'); 
// $chk1 = date('H:i:s', $chk);

// echo($datein);
// echo($dateout);


if (isset($_GET['search'])) {
	$search = $_GET['search'];
	$queryResult = $connect->query("SELECT * FROM tb_meetingroom where name like '%$search%' && status ='1'");
} elseif (isset($_GET['whiteboardandchalk']) || isset($_GET['projectorandscreen']) || isset($_GET['podium']) || isset($_GET['microphoneandspeaker']) || isset($_GET['computer'])) {
	$whiteboardandchalk = $_GET['whiteboardandchalk'];
	$projectorandscreen = $_GET['projectorandscreen'];
	$podium = $_GET['podium'];
	$microphoneandspeaker = $_GET['microphoneandspeaker'];
	$computer = $_GET['computer'];
	if ($whiteboardandchalk == "true") {
		$white = "whiteboardandchalk";
	}
	if ($projectorandscreen == "true") {
		$pro = "projectorandscreen";
	}
	if ($podium == "true") {
		$pod = "podium";
	}
	if ($microphoneandspeaker == "true") {
		$mic = "microphoneandspeaker";
	}
	if ($computer == "true") {
		$com = "computer";
	}
	if ($white != "" || $pro != "" || $pod != "" || $mic != "" || $com != "") {
		$queryResult = $connect->query("SELECT DISTINCT tb_detailroom.name, tb_meetingroom.image, tb_meetingroom.size, tb_meetingroom.price
FROM tb_detailroom
INNER JOIN tb_meetingroom ON tb_detailroom.name=tb_meetingroom.name && tb_meetingroom.status ='1' 
WHERE tb_detailroom.det_detail = '" . $white . "' OR  tb_detailroom.det_detail = '" . $pro . "' 
OR  tb_detailroom.det_detail = '" . $pod . "'OR  tb_detailroom.det_detail = '" . $mic . "'
OR  tb_detailroom.det_detail = '" . $com . "';");
	} else {
		$queryResult = $connect->query("SELECT * FROM tb_meetingroom where status ='1'");
	}
} else {
	$queryResult = $connect->query("SELECT * FROM tb_meetingroom where status ='1'");
}


$result = array();

while ($fetchData = $queryResult->fetch_assoc()) {
	$result[] = $fetchData;
}

echo json_encode($result);