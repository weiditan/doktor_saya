<?php
  if(isset($_POST['action'])){

    $action = $_POST['action'];
    $role_id = $_POST['role_id'];
    $sender = $_POST['sender'];
    $receiver = $_POST['receiver'];
    $context = $_POST['context'];
    $type = $_POST['type'];
    $message_id = $_POST['message_id'];

    include "dbconnect.php";
    include "Output.php";

    switch ($action) {

        case "get":
            getData($conn, $sender, $receiver);
            break;

        case "add":
            addData($conn, $sender, $receiver, $type, $context);
            break;

        case "getlist":
            getList($conn, $role_id);
            break;

        case "addAttachments":
            addAttachments($conn, $sender, $receiver, $type, $context);
            break;

        case "delete":
            deleteData($conn, $message_id);
            break;

        default:
            OutputStatusWithData(false, "Error: No action");
    }
    
    $conn->close();
  }

  function getData($conn, $sender, $receiver){

    $sql = "SELECT * FROM message WHERE (sender = '$sender' OR receiver = '$sender') AND (sender = '$receiver' OR receiver = '$receiver') ORDER BY sendtime DESC";
    
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            $myArray[] = $row;
        }
    }

    $sql2 = "UPDATE message SET readstatus=1 WHERE sender = '$receiver' AND receiver = '$sender' AND readstatus = 0";
    
    if ($conn->query($sql2) === TRUE) {
        OutputArray($myArray);
    }

    
  }

  function addData($conn, $sender, $receiver, $type, $context){
    $sql = "INSERT INTO message (sender, receiver, type, context, sendtime, readstatus)
                        VALUES ('$sender', '$receiver', '$type', '$context', NOW(), 0)";

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

  function getList($conn, $role_id){

    $sql = "SELECT * FROM message WHERE sender = '$role_id' OR receiver = '$role_id' ORDER BY sendtime DESC";
    
    $result = $conn->query($sql);

    $a=array();

    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            if($row['sender']==$role_id){
                
                if(!in_array($row['receiver'],$a)){
                    array_push($a, $row['receiver']);
                }
            }else{
                if(!in_array($row['sender'], $a)){
                    array_push($a, $row['sender']);
                }
                
            }
        }

    }

    for ($i = 0; $i < count($a); $i++){
        $a[$i] = getDetail($conn, $role_id, $a[$i]);
    }

    OutputArray($a);


  }

  function getDetail($conn, $role_id, $receiver){

    if($receiver[0]=="d"){
        $sql1 = "SELECT * FROM doctor WHERE doctor_id = '$receiver'";
    }else{
        $sql1 = "SELECT * FROM patient WHERE patient_id = '$receiver'";
    }
    
    
    $result1 = $conn->query($sql1);

    if ($result1->num_rows > 0) {
        while($row1 = $result1->fetch_assoc()) {
            $nickname = $row1['nickname'];
            $image = $row1['image'];
        }
    }

    $sql2 = "SELECT context,sendtime,type FROM message WHERE (sender = '$role_id' OR receiver = '$role_id') AND (sender = '$receiver' OR receiver = '$receiver') ORDER BY sendtime DESC LIMIT 1";
    
    $result2 = $conn->query($sql2);

    if ($result2->num_rows > 0) {
        while($row2 = $result2->fetch_assoc()) {
            $lastmessage = $row2['context'];
            $lastmessagetype = $row2['type'];
            $sendtime = $row2['sendtime'];
        }
    }

    $sql3 = "SELECT COUNT(message_id) AS count FROM message WHERE sender = '$receiver' AND receiver = '$role_id' AND readstatus = 0";
    
    $result3 = $conn->query($sql3);

    if ($result3->num_rows > 0) {
        while($row3 = $result3->fetch_assoc()) {
            $unread = $row3['count'];
        }
    }

    $value = array( 
        "doctor_id" => $receiver,
        "nickname" => $nickname,
        "image" => $image,
        "message"=> $lastmessage,
        "sendtime" => $sendtime,
        "unread" => $unread,
        "type" => $lastmessagetype
    ); 

    return $value;
  }

  
function addAttachments($conn, $sender, $receiver, $type, $context){

    $attachmentName = $_FILES['file']['name'];
    $attachmentFolder = "Files/Attachments/";

    move_uploaded_file($_FILES['file']['tmp_name'], $attachmentFolder.$attachmentName);

    $sql = "INSERT INTO message (sender, receiver, type, context, filepath, sendtime, readstatus)
                        VALUES ('$sender', '$receiver', '$type', '$context', '$attachmentName', NOW(), 0)";

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
}

function deleteData($conn, $message_id){
    $sql = "DELETE FROM message WHERE message_id = $message_id";

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
  }

?>