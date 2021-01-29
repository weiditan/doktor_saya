<?php
  if(isset($_POST['role_id'])){
    $role_id = $_POST['role_id'];

        include "dbconnect.php";
        include "Output.php";

        if($role_id[0]=="d"){
            $sql = "SELECT token, doctor.doctor_id, fullname, nickname, gender, birthday, phone, image, mmc, workplace, doctor.state_id, country, doctor.state, user.email, state.state AS selected_state, TIMESTAMPDIFF(MINUTE,last_activity,NOW())<3 AS online
                    FROM doctor 
                    LEFT JOIN user 
                        ON doctor.user_id = user.user_id 
                    LEFT JOIN `state`
                        ON doctor.state_id = state.state_id
                    LEFT JOIN doctor_online
                        ON doctor.doctor_id = doctor_online.doctor_id
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

                $row['status'] = true;

                $doctor_id = substr_replace($role_id,"d",0,1);

                if($role_id[0]=="d"){

                    $sql3 = "SELECT DISTINCT sender FROM message WHERE receiver = '$doctor_id'";
        
                    $result3 = $conn->query($sql3);
        
                    if ($result3->num_rows > 0) {
                        $total = $result3->num_rows;
                        $response = 0;
        
                        while($row3 = $result3->fetch_assoc()) {
        
                            $sql4 = "SELECT * FROM message WHERE sender = '$doctor_id' AND receiver = '".$row3['sender']."'";
        
                            $result4 = $conn->query($sql4);
                        
                            if ($result4->num_rows > 0) {
                                $response++;
                            }
                                
                        }
                    }
        
        
                    if($total==0){
                        $row['rate'] = '100';
                    }else{
                        $row['rate'] = number_format($response/$total*100);
                    }

                }

                $sql5 = "SELECT date_request, date_verification, request_status, comment FROM doctor WHERE doctor_id = '$doctor_id' ";
        
                $result5 = $conn->query($sql5);
            
                if ($result5->num_rows > 0) {
                    while($row5 = $result5->fetch_assoc()) {
                        $row += $row5;
                    }
                }
                
                OutputArray($row);
            }
        }else{
            OutputStatus(false);
        }

        $conn->close();
  }

?>