<?php
  if(isset($_POST['role_id'])){
    $role_id = $_POST['role_id'];

        include "dbconnect.php";
        include "Output.php";

        if($role_id[0]=="d"){
            $sql = "SELECT fullname, nickname, gender, birthday, phone, image, mmc, token, workplace, doctor.state_id, country, doctor.state, online, user.email, state.state as selected_state 
                        FROM doctor 
                        LEFT JOIN user 
                        ON doctor.user_id = user.user_id 
                        LEFT JOIN `state`
                        ON doctor.state_id = state.state_id
                    WHERE doctor.doctor_id = '$role_id'";

        }else{
            $sql = "SELECT * FROM patient 
                        LEFT JOIN user 
                        ON patient.user_id = user.user_id 
                    WHERE patient.patient_id = '$role_id'";
        }

        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                OutputArray($row);
            }
        }else{
            OutputStatus(false);
        }

        $conn->close();
  }

?>