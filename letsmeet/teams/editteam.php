<?php

include 'conn.php';

$oldteam_name = $_POST['oldteam_name'];
$newteam_name = $_POST['newteam_name'];
$team_description = $_POST['team_description'];


$sql = ("SELECT * FROM tb_teams WHERE team_name = '" . $oldteam_name . "' ");
$result = $connect->query($sql);
$sql2 = ("SELECT * FROM tb_teams WHERE team_name = '" . $newteam_name . "' ");
$resultt = $connect->query($sql2);
if($oldteam_name !== $newteam_name ){
if ($result->num_rows > 0 && $resultt->num_rows < 1 ) {
    $queryResult = $connect->query("UPDATE tb_teams SET team_name = '" . $newteam_name . "' 
    ,team_description = '" . $team_description . "' WHERE team_name = '" . $oldteam_name . "'");

    if ($queryResult) {
        $queryResultt = $connect->query("UPDATE tb_memberteams SET team_name = '" . $newteam_name . "' WHERE team_name = '" . $oldteam_name . "'");
        if($queryResultt){
              $queryResulttt = $connect->query("UPDATE tb_fileteam SET team_name = '" . $newteam_name . "' WHERE team_name = '" . $oldteam_name . "'");
                    $oldname = "upload/". $oldteam_name ."";
                    $newname = "upload/". $newteam_name ."";
                    rename($oldname, $newname);
        }else{}
      echo json_encode("edit success");

   } else {
        echo json_encode("fail");
    }
} else {
    echo json_encode("dupicate");
}
}else{
$queryResult = $connect->query("UPDATE tb_teams SET team_name = '" . $oldteam_name . "' 
    ,team_description = '" . $team_description . "' WHERE team_name = '" . $oldteam_name . "'");
}