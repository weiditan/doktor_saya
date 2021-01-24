<?php

if(isset($_POST['action'])){

    $action = $_POST['action'];
    $doctor_spec_id = $_POST['doctor_spec_id'];
    $role_id = $_POST['role_id'];
    $specialist_id = $_POST['specialist_id'];
    $sub_specialist = $_POST['sub_specialist'];

    include "dbconnect.php";
    include "Output.php";

    switch ($action) {

        case "getSpecialist":
            getSpecialist($conn);
            break;

        case "getSubSpecialist":
            getSubSpecialist($conn);
            break;

        default:
            OutputStatusWithData(false, "Error: No action");
    }
    
    $conn->close();
  }

  function getSpecialist($conn){
    $sql = "SELECT * FROM specialist";

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $myArray[] = $row;
        }
    }

    OutputArray($myArray);
  }

  function getSubSpecialist($conn){
    $sql = "SELECT specialist_id, sub_specialist FROM doctor_spec GROUP BY sub_specialist ORDER BY specialist_id,sub_specialist";

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $myArray[] = $row;
        }
    }

    OutputArray($myArray);
  }
?>