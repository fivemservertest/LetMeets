<?php

include 'conn.php';

    $team_name = $_POST['team_name'];
	
		function deletefile($path)
		{
		if ($handle = opendir($path))
		{
		$array = array();
		while (false !== ($file = readdir($handle))) {
			if ($file != "." && $file != "..") {
		
				if(is_dir($path.$file))
				{
					if(!@rmdir($path.$file)) // Empty directory? Remove it
					{
					}
				}
				else
				{
				   @unlink($path.$file);
				}
			}
		}
		closedir($handle);
		
		@rmdir($path);
		}
		}
	
    $queryResult = $connect->query("DELETE  FROM tb_teams WHERE team_name =  '".$team_name."' ");
	
	
	if($queryResult){
		$queryResultt = $connect->query("DELETE  FROM tb_memberteams WHERE team_name =  '".$team_name."' ");
		
		
		
	
		if($queryResultt){
			$path="upload/".$team_name."/";
					$queryResulttt = $connect->query("DELETE  FROM tb_fileteam WHERE team_name =  '".$team_name."' ");
						deletefile($path);
						echo json_encode('success');

		}
		
		
		
		else{echo json_encode('fail delete');}
	}else{
		echo json_encode('fail delete');
	}




