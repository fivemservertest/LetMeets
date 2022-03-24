<?php
/** Error reporting */
//error_reporting(0);
//ini_set('display_errors', FALSE);
//ini_set('display_startup_errors', FALSE);
require_once __DIR__ . '/vendor/autoload.php';
?>
<!DOCTYPE html>
<html>
  <head>
    <title>Google Calendar API </title>
    <meta charset='utf-8' />
  </head>
  <body>
    <p>Add new Event</p>
      
<?php
define('APPLICATION_NAME', 'CALENDAR-PHP-2021');
define('CREDENTIALS_PATH', __DIR__ . 'calendar.json');
define('CLIENT_SECRET_PATH', __DIR__ . 'token.json');
// If modifying these scopes, delete your previously saved credentials
// at ~/.credentials/calendar-php-quickstart.json
define('SCOPES', implode(' ', array(
  Google_Service_Calendar::CALENDAR_EVENTS)
));
// https://developers.google.com/resources/api-libraries/documentation/calendar/v3/php/latest/class-Google_Service_Calendar.html 
/*if (php_sapi_name() != 'cli') {
  throw new Exception('This application must be run on the command line.');
}*/
  
/**
 * Returns an authorized API client.
 * @return Google_Client the authorized client object
 */
function getClient() {
  $client = new Google_Client();
  $client->setApplicationName(APPLICATION_NAME);
  $client->setScopes(SCOPES);
  $client->setAuthConfig('credentials.json');
  $client->setAccessType('offline');
    $guzzleClient = new \GuzzleHttp\Client(array( 'curl' => array( CURLOPT_SSL_VERIFYPEER => false, ), ));
    $client->setHttpClient($guzzleClient);  
  
  // Load previously authorized credentials from a file.
  $credentialsPath = expandHomeDirectory(CREDENTIALS_PATH);
  if (file_exists($credentialsPath)) {
    $accessToken = json_decode(file_get_contents($credentialsPath), true);
  } else {
    // Request authorization from the user.
    $authUrl = $client->createAuthUrl();
    printf("Open the following link in your browser:\n%s\n", $authUrl);
    print 'Enter verification code: ';
    $authCode = trim(fgets(STDIN));
  
    // Exchange authorization code for an access token.
    $accessToken = $client->fetchAccessTokenWithAuthCode($authCode);
  
    // Store the credentials to disk.
    if(!file_exists(dirname($credentialsPath))) {
      mkdir(dirname($credentialsPath), 0700, true);
    }
    file_put_contents($credentialsPath, json_encode($accessToken));
    printf("Credentials saved to %s\n", $credentialsPath);
  }
  $client->setAccessToken($accessToken);
  
  // Refresh the token if it's expired.
  if ($client->isAccessTokenExpired()) {
    $client->fetchAccessTokenWithRefreshToken($client->getRefreshToken());
    file_put_contents($credentialsPath, json_encode($client->getAccessToken()));
  }
  return $client;
}
  
/**
 * Expands the home directory alias '~' to the full path.
 * @param string $path the path to expand.
 * @return string the expanded path.
 */
function expandHomeDirectory($path) {
  $homeDirectory = getenv('HOME');
  if (empty($homeDirectory)) {
    $homeDirectory = getenv('HOMEDRIVE') . getenv('HOMEPATH');
  }
  return str_replace('~', realpath($homeDirectory), $path);
}
  
// Get the API client and construct the service object.
$client = getClient();
$service = new Google_Service_Calendar($client);
 
 /////////// ส่วนของการเพิ่ม Event
// ตัวแปรโครงสร้าง parameter สำหรับสร้าง event
$event_data = array(
  'summary' => 'Google I/O 2021', // หัวเรื่อง
  'location' => '800 Howard St., San Francisco, CA 94103', // สถานที่
  'description' => 'A chance to hear more about Google\'s developer products.', // รายละเอียด
  'start' => array( // วันที่เวลาเริ่มต้น
    'dateTime' => '2021-12-28T09:00:00-07:00',
    'timeZone' => 'Asia/Bangkok',
  ),
  'end' => array( // วันที่เวลาสิ้นสุด
    'dateTime' => '2021-12-28T17:00:00-07:00',
    'timeZone' => 'Asia/Bangkok',
  ),
  'recurrence' => array( // การทำซ้ำ
    'RRULE:FREQ=DAILY;COUNT=2'
  ),
  'attendees' => array( // ผู้เข้าร่วม อีเมล
    array('email' => 'lpage@example.com'),
    array('email' => 'sbrin@example.com'),
  ),
  'reminders' => array( // การแจ้งเตือน
    'useDefault' => FALSE,
    'overrides' => array(
      array('method' => 'email', 'minutes' => 24 * 60),
      array('method' => 'popup', 'minutes' => 10),
    ),
  ),
);
$event = new Google_Service_Calendar_Event($event_data); // สร้าง event object
 
$calendarId = 'primary'; // calendar หลัก
$event = $service->events->insert($calendarId, $event); // ทำคำสั่งเพิ่มข้อมูล
printf('Event created: %s', $event->htmlLink); // หากเพิ่มข้อมูลสำเร็จ จะได้ค่า ลิ้งค์
 
?>
  
  </body>
</html>