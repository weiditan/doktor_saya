<?php
  if(isset($_POST['action'])){

    $action = $_POST['action'];
    $name = $_POST['name'];
    $specialistId = $_POST['specialistId'];
    $subSpecialist = $_POST['subSpecialist'];
    $requestStatus = $_POST['requestStatus'];

    include "dbconnect.php";
    include "Output.php";

    switch ($action) {

        case "get":
            getData($conn,$name,$specialistId,$subSpecialist,$requestStatus);
            break;

        default:
            OutputStatusWithData(false, "Error: No action");
    }
    
    $conn->close();
  }

  function getData($conn,$name,$specialistId,$subSpecialist,$requestStatus){

    $selectSql = " WHERE request_status=$requestStatus";

    if($name!="" || $specialistId!="" || $subSpecialist!=""){
        $selectSql .= " AND ";
    }

    if($name!=""){
        if($specialistId!="" || $subSpecialist!=""){
            $selectSql .= "(nickname LIKE '%$name%' OR fullname LIKE '%$name%') AND ";
        }else{
            $selectSql .= "nickname LIKE '%$name%' OR fullname LIKE '%$name%' ";
        }
    }

    if($specialistId!=""){
        if($subSpecialist!=""){
            $selectSql .= "specialist_id = $specialistId AND ";
        }else{
            $selectSql .= "specialist_id = $specialistId ";
        }
    }

    if($subSpecialist!=""){
        $selectSql .= "sub_specialist = '$subSpecialist' ";
    }
    
    $sql = "SELECT doctor.doctor_id, fullname, nickname, gender, birthday, phone, image, mmc, workplace, doctor.state_id, country, doctor.state, user.email, state.state AS selected_state, TIMESTAMPDIFF(MINUTE,last_activity,NOW())<3 AS online
                FROM doctor 
            LEFT JOIN user 
                ON doctor.user_id = user.user_id 
            LEFT JOIN `state`
                ON doctor.state_id = state.state_id
            LEFT JOIN doctor_online
                ON doctor.doctor_id = doctor_online.doctor_id
            LEFT JOIN doctor_spec
                ON doctor.doctor_id = doctor_spec.doctor_id
                ".$selectSql."
            GROUP BY doctor_id
            ORDER BY online DESC, nickname";
    
    $result = $conn->query($sql);

    $myArray = array();
    
    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {

            $sql2 = "SELECT * FROM doctor_spec LEFT JOIN specialist ON doctor_spec.specialist_id = specialist.specialist_id WHERE doctor_spec.doctor_id = '".$row['doctor_id']."' ORDER BY doctor_spec.specialist_id";
            
            $result2 = $conn->query($sql2);
        
            if ($result2->num_rows > 0) {

                $output = "";
                $titleBefore = "";

                while($row2 = $result2->fetch_assoc()) {
                    if($row2['malay']!=$titleBefore){
                        $output .= $row2['malay']."\n";
                    }

                    if($row2['sub_specialist']!=""){
                        $output .= $row2['sub_specialist']."\n";
                    }
                    $titleBefore = $row2['malay'];
                }
                $row['specialist'] = substr($output, 0, -1);
            }

            $doctor_id = $row['doctor_id'];

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

            $myArray[] = $row;
        }
    }
    
    OutputArray($myArray);
  }

?>