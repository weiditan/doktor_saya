<?php
  if(isset($_POST['action'])){

    $action = $_POST['action'];
    $role_id = $_POST['role_id'];
    $receiver = $_POST['receiver'];
    $call_id = $_POST['call_id'];
    $prescription = $_POST['prescription'];

    include "dbconnect.php";
    include "Output.php";

    switch ($action) {

      case "checkCall":
        checkCall($conn, $role_id);
        break;

      case "addCall":
        addCall($conn, $role_id, $receiver);
        break;

    case "acceptCall":
        acceptCall($conn, $call_id);
        break;

      case "endCall":
        endCall($conn, $call_id);
        break;

      case "checkEndCall":
        checkEndCall($conn, $call_id);
        break;

      case "getCallList":
        getCallList($conn,$role_id);
        break;

      case "addPrescription":
        addPrescription($conn, $call_id,$prescription);
        break;

      default:
        OutputStatusWithData(false, "Error: No action");
    }
    
    $conn->close();
  }

  function checkCall($conn, $role_id){

    $sql = "SELECT * FROM call_list WHERE receiver = '$role_id' AND endtime = '0000-00-00 00:00:00'";
    
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
          $value = array( 
            "status" => true,
            "call_id" => $row['call_id'],
            "caller" => $row['caller'],
        );  
      }
      OutputArray($value);
      
    }else{
      OutputStatus(false);
    }
  }

  function addCall($conn, $role_id, $receiver){
    
    $sql = "INSERT INTO call_list( caller, receiver, sendtime, accept_call) 
                            VALUES ('$role_id', '$receiver', NOW(), 0)";

    if ($conn->query($sql) === TRUE) {
        $last_id = $conn->insert_id;
        OutputStatusWithData(true, $last_id);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

  function endCall($conn, $call_id){
    
    $sql = "UPDATE call_list SET endtime = NOW() WHERE call_id = $call_id";

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

  
  function acceptCall($conn, $call_id){
    
    $sql = "UPDATE call_list SET accept_call = 1 WHERE call_id = $call_id";

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

  function checkEndCall($conn, $call_id){

    $sql = "SELECT * FROM call_list WHERE call_id = '$call_id'";
    
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {

          if($row['endtime']!='0000-00-00 00:00:00')
          {
            OutputStatus(true);
          }else{
            OutputStatus(false);
          }
      } 
    }
  }

  function addPrescription($conn, $call_id,$prescription){
    
    $sql = "UPDATE call_list SET prescription = '$prescription' WHERE call_id = $call_id";

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

  function getCallList($conn,$role_id){
    $sql = "SELECT * FROM call_list WHERE caller = '$role_id' OR receiver = '$role_id' ORDER BY sendtime DESC";
    
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {

        while($row = $result->fetch_assoc()) {
            if($row["caller"]==$role_id){
                $row["id"] = $row["receiver"];
            }else{
                $row["id"] = $row["caller"];
            }
            
            if($row["id"][0]=="d"){
                $sql1 = "SELECT * FROM doctor WHERE doctor_id = '".$row["id"]."'";
            }else{
                $sql1 = "SELECT * FROM patient WHERE patient_id = '".$row["id"]."'";
            }

            $result1 = $conn->query($sql1);

            if ($result1->num_rows > 0) {
                while($row1 = $result1->fetch_assoc()) {
                    $row['nickname'] = $row1['nickname'];
                    $row['image'] = $row1['image'];
                }
            }
            $myArray[] = $row;
      }  
    }

    OutputArray($myArray);
  }

?>