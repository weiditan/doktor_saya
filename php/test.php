<?php

$files = glob( __DIR__ . '/*.php');

foreach ($files as $file) {
   echo $file."<br>";   
}
    

?>