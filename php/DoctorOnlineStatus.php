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

    $sql = "SELECT * FROM doctor WHERE doctor_id = '$doctor_id'";
    
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            OutputStatusWithData(true, $row['online']);
        }
    }
  }

  function updateData($conn, $doctor_id, $status){

    if($status=='online'){
        $sql = "UPDATE doctor SET online = 1 WHERE doctor_id = '$doctor_id'";
    }else{
        $sql = "UPDATE doctor SET online = 0 WHERE doctor_id = '$doctor_id'";
    }

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

?>