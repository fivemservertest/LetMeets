<?php
include 'conn.php';

use PHPMailer\PHPMailer\PHPMailer;

$mess = $_GET['status'];
$subject = $_GET['subject'];
$body = $_GET['body'];
if ($mess == 'team') {
    $reserve_id = $_GET['reserve_id'];
    $sql = "SELECT team_id FROM tb_reservation WHERE reserve_id = '$reserve_id'";
    $query = $connect->query($sql);
    while ($row = mysqli_fetch_array($query)) {
        $team_id = $row['team_id'];
    }
    $sql2 = "SELECT team_name FROM tb_teams WHERE team_id = '$team_id'";
    $query2 = $connect->query($sql2);
    while ($row2 = mysqli_fetch_array($query2)) {
        $team_name = $row2['team_name'];
    }
    $sql3 = "SELECT username FROM tb_memberteams WHERE team_name = '$team_name'";
    $query3 = $connect->query($sql3);
    while ($row3 = mysqli_fetch_array($query3)) {
        $username = $row3['username'];

        $sql4 = "SELECT email,firstname FROM tb_user WHERE username = '$username'";
        $query4 = $connect->query($sql4);
        while ($row4 = mysqli_fetch_array($query4)) {
            $email = $row4['email'];
            $name = $row4['firstname'];


            require_once "PHPMailer/PHPMailer.php";
            require_once "PHPMailer/SMTP.php";
            require_once "PHPMailer/Exception.php";

            $mail = new PHPMailer();

            //smtp settings
            $mail->CharSet = "utf-8";
            $mail->isSMTP();
            $mail->Host = "smtp.gmail.com";
            $mail->SMTPAuth = true;
            $mail->Username = "letsmeetapp01@gmail.com";
            $mail->Password = 'w1a2s3d4';
            $mail->Port = 465;
            $mail->SMTPSecure = "ssl";

            //email settings
            $mail->isHTML(true);
            $mail->setFrom($email, $name);
            $mail->addAddress("$email");
            $mail->Subject = ("$email ($subject)");
            $mail->Body = $body;

            $mail->send();
            $mail->ClearAllRecipients();
            $mail->ClearAttachments();
        }
    }
} else {
    if (isset($_GET['name']) && isset($_GET['email'])) {
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
        $mail->Username = "letsmeetapp01@gmail.com";
        $mail->Password = 'w1a2s3d4';
        $mail->Port = 465;
        $mail->SMTPSecure = "ssl";

        //email settings
        $mail->isHTML(true);
        $mail->setFrom($email, $name);
        $mail->addAddress("$email");
        $mail->Subject = ("$email ($subject)");
        $mail->Body = $body;

        if ($mail->send()) {
            $status = "success";
            $response = "Email is sent!";
        } else {
            $status = "failed";
            $response = "Something is wrong: <br>" . $mail->ErrorInfo;
        }

        exit(json_encode(array("status" => $status, "response" => $response)));
    } else {
        echo "you miss";
    }
}
