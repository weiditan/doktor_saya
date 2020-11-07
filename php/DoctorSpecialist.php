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

        case "get":
            getData($conn, $role_id);
            break;

        case "add":
            addData($conn, $role_id, $specialist_id, $sub_specialist);
            break;

        case "delete":
            deleteData($conn, $doctor_spec_id);
            break;

        default:
            OutputStatusWithData(false, "Error: No action");
    }
    
    $conn->close();
  }

  function getData($conn, $role_id){

    $sql = "SELECT * FROM doctor_spec LEFT JOIN specialist ON doctor_spec.specialist_id = specialist.specialist_id WHERE doctor_spec.doctor_id = '$role_id' ORDER BY doctor_spec.specialist_id";
    
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $myArray[] = $row;
        }
    }

    OutputArray($myArray);
  }

  function addData($conn, $role_id, $specialist_id, $sub_specialist){
    $sql = "INSERT INTO doctor_spec(doctor_id, specialist_id, sub_specialist)
    VALUES ('$role_id', $specialist_id, '$sub_specialist')";

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

  function deleteData($conn, $doctor_spec_id){
    $sql = "DELETE FROM doctor_spec WHERE doctor_spec_id = $doctor_spec_id";

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

?>