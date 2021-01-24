<?php

if(isset($_POST['action'])){

    $action = $_POST['action'];
    $doctor_id = $_POST['doctor_id'];
    $comment = $_POST['comment'];

    include "dbconnect.php";
    include "Output.php";
    
    switch ($action) {

        case "request":
            requestDoctor($conn,$doctor_id);
            break;

        case "approve":
            approveDoctor($conn,$doctor_id);
            break;

        case "disapprove":
            disapproveDoctor($conn,$doctor_id,$comment);
            break;

        default:
            OutputStatusWithData(false, "Error: No action");
    }
    
    $conn->close();
}

function requestDoctor($conn,$doctor_id)
{
    $sql = "UPDATE doctor SET 
                date_request = NOW(), 
                request_status = 1
            WHERE doctor_id='$doctor_id'";
    
    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
}


function approveDoctor($conn,$doctor_id)
{
    $sql = "UPDATE doctor SET 
                date_verification = NOW(), 
                request_status = 2
            WHERE doctor_id='$doctor_id'";
    
    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
}

function disapproveDoctor($conn,$doctor_id,$comment)
{
    $sql = "UPDATE doctor SET 
                date_verification = NOW(), 
                request_status = 3,
                comment = '$comment'
            WHERE doctor_id='$doctor_id'";
    
    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
}

?>