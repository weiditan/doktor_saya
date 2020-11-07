<?php

if (isset($_POST['role_id'])) {
    $role_id = $_POST['role_id'];
    $token = $_POST['token'];

    include "dbconnect.php";
    include "Output.php";

    if($role_id[0]=="d"){
        $sql = "UPDATE doctor SET token = '$token' WHERE doctor_id='$role_id'";
    }else{
        $sql = "UPDATE patient SET token = '$token' WHERE patient_id='$role_id'";
    }

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }

    $conn->close();
}

?>