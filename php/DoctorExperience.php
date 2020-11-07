<?php
  if(isset($_POST['action'])){

    $action = $_POST['action'];
    $role_id = $_POST['role_id'];
    $location = $_POST['location'];
    $startdate = $_POST['startdate'];
    $enddate = $_POST['enddate'];
    $doctor_exp_id = $_POST['doctor_exp_id'];

    include "dbconnect.php";
    include "Output.php";

    switch ($action) {

        case "get":
            getData($conn, $role_id);
            break;

        case "add":
            addData($conn, $role_id, $location, $startdate, $enddate);
            break;

        case "delete":
            deleteData($conn, $doctor_exp_id);
            break;

        default:
            OutputStatusWithData(false, "Error: No action");
    }
    
    $conn->close();
  }

  function getData($conn, $role_id){

    $sql = "SELECT * FROM doctor_exp WHERE doctor_id = '$role_id'";
    
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $myArray[] = $row;
        }
    }

    OutputArray($myArray);
  }

  function addData($conn, $role_id, $location, $startdate, $enddate){
    $sql = "INSERT INTO doctor_exp (doctor_id, location, startdate, enddate)
    VALUES ('$role_id', '$location', '$startdate', '$enddate')";

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

  function deleteData($conn, $doctor_exp_id){
    $sql = "DELETE FROM doctor_exp WHERE doctor_exp_id = $doctor_exp_id";

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

?>