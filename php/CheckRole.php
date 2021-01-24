<?php
    if(isset($_POST['user_id']) && $_POST['role']){
        $user_id = $_POST['user_id'];
        $role = $_POST['role'];

        include "dbconnect.php";
        include "Output.php";

        $doctorstatus = "";

        if($role=="doctor"){
            $doctorstatus = "AND request_status=2";
        }

        $sql = "SELECT * FROM $role WHERE (user_id ='$user_id' $doctorstatus)";
    
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                OutputStatusWithData(true, $row[$role."_id"]);
            }
        }else{
            OutputStatus(false);
        }

        $conn->close();
    }

?>