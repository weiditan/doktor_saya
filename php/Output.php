<?php

    function OutputStatus(bool $status){
        // Declare an array  
        $value = array( 
            "status"=> $status
        ); 

        // Use json_encode() function 
        $json = json_encode($value); 

        // Display the output 
        echo($json); 
    }

    function OutputStatusWithData(bool $status, $data){
        // Declare an array  
        $value = array( 
            "status"=> $status,
            "data"=> $data
        ); 

        // Use json_encode() function 
        $json = json_encode($value); 

        // Display the output 
        echo($json); 
    }

    function OutputArray($value){

        // Use json_encode() function 
        $json = json_encode($value); 

        // Display the output 
        echo($json); 
    }

?>