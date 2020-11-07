<?php

if(isset($_POST['action'])){

    $action = $_POST['action'];
    $role_id = $_POST['role_id'];
    $workplace = $_POST['workplace'];
    $state_id = $_POST['state_id'];
    $country = $_POST['country'];
    $state = $_POST['state'];

    include "dbconnect.php";
    include "Output.php";

    switch ($action) {

        case "get":
            getDoctorWorkplace($conn, $role_id);
            break;

        case "update":
            updateDoctorWorkplace($conn, $role_id, $workplace, $state_id, $country, $state);
            break;

        default:
            OutputStatusWithData(false, "Error: No action");
    }
    
    $conn->close();
}

function getDoctorWorkplace($conn, $role_id){

    $sql = "SELECT * FROM doctor WHERE doctor_id = '$role_id'";
        
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            OutputArray($row);
        }
    }else{
        OutputStatus(false);
    }
}

function updateDoctorWorkplace($conn, $role_id, $workplace, $state_id, $country, $state){

    if($country!=null){
        $sql = 
        "UPDATE doctor SET 
            `workplace`= '$workplace',
            `state_id`= null,
            `country`= '$country',
            `state`= '$state' 
        WHERE doctor_id = '$role_id'";
    }else{
        $sql = 
        "UPDATE doctor SET 
            `workplace`= '$workplace',
            `state_id`= $state_id,
            `country`= '',
            `state`= '' 
        WHERE doctor_id = '$role_id'";
    }

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
}


?>