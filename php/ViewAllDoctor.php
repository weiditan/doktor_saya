<?php
  if(isset($_POST['action'])){

    $action = $_POST['action'];


    include "dbconnect.php";
    include "Output.php";

    switch ($action) {

        case "get":
            getData($conn);
            break;

        case "search":

            break;

        default:
            OutputStatusWithData(false, "Error: No action");
    }
    
    $conn->close();
  }

  function getData($conn){

    $sql = "SELECT doctor.doctor_id, fullname, nickname, gender, birthday, phone, image, mmc, workplace, doctor.state_id, country, doctor.state, online, user.email, state.state as selected_state 
                        FROM doctor 
                        LEFT JOIN user 
                        ON doctor.user_id = user.user_id 
                        LEFT JOIN `state`
                        ON doctor.state_id = state.state_id";
    
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $myArray[] = $row;
        }
    }

    OutputArray($myArray);
  }

?>