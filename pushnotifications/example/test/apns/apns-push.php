<?php

/**
 * This is a test script to send a message to an APNS device, i.e. an Apple iOS device using the APNS. 
 * 
 * To use this script you need to set the following 4 peieces of information
 *  - message
 *  - device token
 *  - certificate file
 *  - pass phrase
 *
 * Then run it using php: 
 * <code> php apns-push.php </code> 
 *
 */

// Message to send
$message = 'the test message';

// Put your device token here (without spaces):
$deviceToken = '38893243cc2daf82c7a4ec969b9ab03dece632b3e6f32c3f1fd84018255596dd';


//
//	Certificate Key Details
$certfile = 'ck.pem';
// Put your private key's passphrase here:
$passphrase = 'password';





////////////////////////////////////////////////////////////////////////////////



$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', $certfile);
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
$fp = stream_socket_client(
	'ssl://gateway.sandbox.push.apple.com:2195', $err,
	$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

if (!$fp)
	exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body
$body['aps'] = array(
	'alert' => $message,
	'badge' => 0,
	'sound' => 'default'
	);

// Encode the payload as JSON
$payload = json_encode($body);

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

if (!$result)
	echo 'Message not delivered' . PHP_EOL;
else
	echo 'Message successfully delivered' . PHP_EOL;

// Close the connection to the server
fclose($fp);
