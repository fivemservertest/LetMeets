<?php
    include 'conn.php';
    error_reporting(0);
    $Roomname = $_POST['Roomname'];
    $Roomdetail = $_POST['detail'];
    $Roomsize = $_POST['Roomsize'];
    $Roomprice = $_POST['Roomprice'];
    $image = $_FILES['image']['name'];
    $imagePath = 'roomimg/'.$image;
    $tmp_name = $_FILES['image']['tmp_name'];
    $datetime=date("dmYHis");
    $file_name=substr($_FILES['image']['name'],-4);
    $image=$datetime.'_roomimg'.$type.$file_name;
    
    $whiteboardandchalk =$_POST['whiteboardandchalk'];
    $projectorandscreen =$_POST['projectorandscreen'];
    $podium =$_POST['podium'];
    $microphoneandspeaker =$_POST['microphoneandspeaker'];
    $computer =$_POST['computer'];

$chk = $connect->query("SELECT * FROM tb_meetingroom WHERE tb_meetingroom.name = '".$Roomname."'");
if ($chk->num_rows < 1) {
        move_uploaded_file($_FILES["image"]["tmp_name"],"roomimg/".$image);
if($whiteboardandchalk == "true" || $projectorandscreen== "true" || $podium == "true" || $microphoneandspeaker == "true" || $computer == "true"){
    $que = $connect->query("INSERT INTO tb_meetingroom(name,detail,size,price,image)VALUES('".$Roomname."','".$Roomdetail."','".$Roomsize."','".$Roomprice."','".$image."')");
  if($que){
            $acc = array();
            if($whiteboardandchalk == "true"){
                array_push($acc,"whiteboardandchalk" )    ;    
            }
            if($projectorandscreen == "true"){
                array_push($acc,"projectorandscreen" )    ;    
            }if($podium == "true"){
                array_push($acc,"podium" )    ;    
            }if($microphoneandspeaker == "true"){
                array_push($acc,"microphoneandspeaker" );        
            }if($computer == "true"){
                array_push($acc,"computer" );        
            }
       for ($i = 0; $i < count($acc); $i++)  {
                $connect->query("INSERT INTO tb_detailroom(name,det_detail)VALUES('".$Roomname."','".$acc[$i]."')");
        }
        echo json_encode ('suc');
            }else{
            
            }
}else{    echo json_encode ('wanning');}

}else{
        echo json_encode ('dup room');

}


?>