<?php

/**
 * Created by PhpStorm.
 * User: RanEndelman
 * Date: 15/10/2017
 * Time: 13:02
 */

class email
{
//    Generate unique token for user confirmation email
    function generateToken($length)
    {
        $chars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";
        $charsLength = srtlen($chars);
        $token = '';
        for ($i = 0; i < $charsLength; $i++) {
            $token .= $chars[rand(0, $charsLength - 1)];
        }
        return $token;
    }

    function confirmationTemplate()
    {
        $file = fopen("templates/confirmationTemplate.html", "r") or die("Unable to open file");
        $template = fread($file, filesize("templates/confirmationTemplate.html"));

        fclose($file);

        return $template;
    }

//    Send email using PHP
    function sendEmail($details) {
        $subject = $details["subject"];
        $to = $details["to"];
        $fromName = $details["fromName"];
        $fromEmail = $details["fromEmail"];
        $body = $details["body"];

        $headers = "MIME-Vesion: 1.0" . "\r\n";
        $headers .= "Content-type:text/html;content=UTF-8" . "\r\n";
        $headers .= "From: " . $fromName . " <" . $fromEmail . ">" . "\r\n";

        mail($to, $subject, $body, $headers);

    }

}


?>