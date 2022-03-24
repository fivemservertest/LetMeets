<?php
use PHPMailer\PHPMailer\PHPMailer;

if(isset($_GET['name']) && isset($_GET['email'])){
    $name = $_GET['name'];
    $email = $_GET['email'];
    $subject = $_GET['subject'];
    $body = $_GET['body'];

    require_once "PHPMailer/PHPMailer.php";
    require_once "PHPMailer/SMTP.php";
    require_once "PHPMailer/Exception.php";

    $mail = new PHPMailer();

    //smtp settings
    $mail->CharSet = "utf-8";
    $mail->isSMTP();
    $mail->Host = "smtp.gmail.com";
    $mail->SMTPAuth = true;
    $mail->Username = "heroofthegame81@gmail.com";
    $mail->Password = 'Dear1590057*';
    $mail->Port = 465;
    $mail->SMTPSecure = "ssl";

    //email settings
    $mail->isHTML(false);
    $mail->setFrom($email, $name);
    $mail->addAddress("$email");
    $mail->Subject = ("$email ($subject)");
	
	$event_id = 1234;
	$sequence = 0;
	$status = 'TENTATIVE';
	
	// event params
$summary = 'Summary of the event';
$venue = 'Simbawanga';
$start = '20210929';
$start_time = '150000';
$end = '20210930';
$end_time = '160000';
	
	$ical = "BEGIN:VCALENDAR\r\n";
$ical .= "VERSION:2.0\r\n";
$ical .= "PRODID:-//YourCassavaLtd//EateriesDept//EN\r\n";
$ical .= "METHOD:PUBLISH\r\n";
$ical .= "BEGIN:VEVENT\r\n";
$ical .= "ORGANIZER;SENT-BY=\"MAILTO:$email\":MAILTO:heroofthegame81@gmail.com";
$ical .= "ATTENDEE;CN=them@kaserver.com;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;RSVP=TRUE:mailto:organizer@kaserver.com\r\n";
$ical .= "UID:".strtoupper(md5($event_id))."-kaserver.com\r\n";
$ical .= "SEQUENCE:".$sequence."\r\n";
$ical .= "STATUS:".$status."\r\n";
$ical .= "DTSTAMPTZID=Africa/Nairobi:".date('Ymd').'T'.date('His')."\r\n";
$ical .= "DTSTART:".$start."T".$start_time."\r\n";
$ical .= "DTEND:".$end."T".$end_time."\r\n";
$ical .= "LOCATION:".$venue."\r\n";
$ical .= "SUMMARY:".$summary."\r\n";
$ical .= "DESCRIPTION:TEST\r\n";
$ical .= "BEGIN:VALARM\r\n";
$ical .= "TRIGGER:-PT15M\r\n";
$ical .= "ACTION:DISPLAY\r\n";
$ical .= "DESCRIPTION:Reminder\r\n";
$ical .= "END:VALARM\r\n";
$ical .= "END:VEVENT\r\n";
$ical .= "END:VCALENDAR\r\n";


	$mail->Body = $ical;
	$mail->Ical = $ical;
   // $mail->Body = $body;

    if($mail->send()){
        $status = "success";
        $response = "Email is sent!";
    }
    else
    {
        $status = "failed";
        $response = "Something is wrong: <br>" . $mail->ErrorInfo;
    }

    exit(json_encode(array("status" => $status, "response" => $response)));
}else {
    echo "you miss";
}

?>