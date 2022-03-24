<?php

date_default_timezone_set('Asia/Bangkok');

$out1 = strtotime('00:49:00');
$outc1 = date('H:i:s', $out1);
$out2 = strtotime('00:50:00');
$outc2 = date('H:i:s', $out2);

$out3 =  date('H:i:s', time());
if ($out3 >= $outc1 && $out3 <= $outc2) {
    echo ('timeout');
    echo ($out3);
} else {
    echo ($out3);
}
