<?php

/*--- Config ---*/

$percentStart = 25;   // Range: 0 to 100
$percentEnd   = 100;  // Range: 0 to 100
$percentStep  = 5;

$channelIntensities = array(  // Range: 0.0 to 1.0
    'red'   => 1.0,
    'green' => 0.79,
    'blue'  => 0.58
);

$plainTextFileName = 'Presets.txt';
$dapFileName       = 'Presets.dap';


/*--- Constants ---*/

define('CHAR_NEWLINE_CR',   "\r");
define('CHAR_NEWLINE_CRLF', "\r\n");
define('CHAR_TAB',          "\t");

define('PERCENT_TO_FRACTION', 100.0);

define('CHANNEL_FULL_BRIGHTNESS', 255);

define('ENCODED_WRAP_WIDTH', 76);


/*--- Generate plain text output ---*/

$plainTextOutputLines = array(
    'DarkAdapted Presets File',
    '200'
);

for ($p = $percentStart; $p <= $percentEnd; $p += $percentStep) {

    $fraction      = $p / PERCENT_TO_FRACTION;
    $channelValues = array();

    foreach ($channelIntensities as $channelIntensity) {
        $value = CHANNEL_FULL_BRIGHTNESS * $fraction * $channelIntensity;
        $channelValues[] = (int) round($value);
    }

    $plainTextOutputLines[] = 'Warm ' . $p . '%' . CHAR_TAB . implode(',', $channelValues);

}

$plainTextOutput = implode(CHAR_NEWLINE_CR, $plainTextOutputLines);


/*--- Save plain text file ---*/

$writeSuccess = file_put_contents($plainTextFileName, $plainTextOutput);

if ($writeSuccess === false) {
    die('Failed to write ' . $plainTextFileName);
}


/*--- Generate Base64-encoded DAP output ---*/

$dapOutput = base64_encode($plainTextOutput);

if ($dapOutput === false) {
    die('Failed to Base64-encode DAP output');
}

$dapOutputWrapped = wordwrap($dapOutput, ENCODED_WRAP_WIDTH, CHAR_NEWLINE_CRLF, true);


/*--- Save Base64-encoded DAP file ---*/

$writeSuccess = file_put_contents($dapFileName, $dapOutputWrapped);

if ($writeSuccess === false) {
    die('Failed to write ' . $dapFileName);
}
