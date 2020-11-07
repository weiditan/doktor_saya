<?php

    if(isset($_POST['action'])&& $_POST['action']=="get"){
        
        include "dbconnect.php";
        include "Output.php";

        $sql = "SELECT * FROM specialist";

        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $myArray[] = $row;
            }
        }

        OutputArray($myArray);

        $conn->close();
    }
?>