<?php 
        
	$connect = new mysqli("localhost","root","","letsmeet"); 	

	if ($connect) {
	}else{
		echo "Connection Failed";
		exit();
	}
?>