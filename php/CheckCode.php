<?php
    if(isset($_POST['email']) && $_POST['code']){
        $email = $_POST['email'];
        $code = $_POST['code'];

        CheckData($email,$code);
    }

    function CheckData($email,$code){
        include "dbconnect.php";
        include "Output.php";
    
        $sql = "SELECT * FROM verification_email WHERE (email='$email' AND code=$code AND TIMESTAMPDIFF(SECOND,NOW(),exptime)>0 )";
    
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            OutputStatus(true);
        } else {
            OutputStatusWithData(false, "Kod pengesahan salah.");
        }
    
        $conn->close();
    }

?>