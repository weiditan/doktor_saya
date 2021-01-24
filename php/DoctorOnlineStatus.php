<?php
  if(isset($_POST['action'])){

    $action = $_POST['action'];
    $doctor_id = $_POST['doctor_id'];
    $status = $_POST['status'];

    include "dbconnect.php";
    include "Output.php";

    switch ($action) {

        case "get":
            getData($conn, $doctor_id);
            break;

        case "update":
            updateData($conn, $doctor_id, $status);
            break;

        default:
            OutputStatusWithData(false, "Error: No action");
    }
    
    $conn->close();
  }

  function getData($conn, $doctor_id){

    $sql = "SELECT * FROM doctor_online WHERE doctor_id='$doctor_id' AND TIMESTAMPDIFF(MINUTE,last_activity,NOW())<3";
    
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            OutputStatusWithData(true, "1");
        }
    }else{
        OutputStatusWithData(true, "0");
    }
  }

  function updateData($conn, $doctor_id, $status){

    if($status=='online'){
        $sql = "INSERT INTO doctor_online(doctor_id, last_activity)
                    VALUES ('$doctor_id', NOW()) 
                ON DUPLICATE KEY UPDATE    
                    last_activity = NOW()";
    }else{
        $sql = "UPDATE doctor_online SET    
                    last_activity = '0000-00-00 00:00:00'
                WHERE doctor_id = '$doctor_id'";
    }

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

?>