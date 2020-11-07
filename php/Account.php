<?php
if (isset($_POST['action'])) {
    
    $action = $_POST['action'];
    $userId = $_POST['userId'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $newPassword = $_POST['newPassword'];
    
    
    include "dbconnect.php";
    include "Output.php";
    
    switch ($action) {
        
        case "login":
            login($conn, $email, $password);
            break;

        case "googleLogin":
            googleLogin($conn, $email);
            break;
        
        case "registerAccount":
            registerAccount($conn, $email, $password);
            break;
        
        case "resetPassword":
            resetPassword($conn, $email, $password);
            break;
        
        case "changePassword":
            changePassword($conn, $userId, $password, $newPassword);
            break;
        
        default:
            OutputStatusWithData(false, "Error: No action");
    }
    
    $conn->close();
}

function login($conn, $email, $password)
{
    
    $sql = "SELECT * FROM user WHERE email='$email' AND password='$password'";
    
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            OutputStatusWithData(true, $row["user_id"]);
        }
        
    } else {
        
        if (checkEmailExists($conn, $email)) {
            OutputStatusWithData(false, "Kata laluan salah.");
        } else {
            OutputStatusWithData(false, "Email tiada dalam sistem.");
        }
    }
}

function googleLogin($conn, $email){
    $sql = "SELECT * FROM user WHERE email='$email'";
    
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            OutputStatusWithData(true, $row["user_id"]);
        }
        
    } else {
        $sql = "INSERT INTO user (email) VALUES ('$email')";

        if ($conn->query($sql) === TRUE) {
            $last_id = $conn->insert_id;
            OutputStatusWithData(true, $last_id);
        }
    }
}

function registerAccount($conn, $email, $password){

    if(!CheckEmailExists($conn, $email)){

        $sql = "INSERT INTO user (email, password) VALUES ('$email', '$password')";

        if ($conn->query($sql) === TRUE) {
            OutputStatus(true);
        } else {
            OutputStatus(false);
        }
    }else{
        OutputStatusWithData(false,"Email tersebut telah didaftarkan.");
    }
    
}


function resetPassword($conn, $email, $password){

    $sql = "UPDATE user SET password = '$password' WHERE email = '$email'";

    if ($conn->query($sql) === TRUE) {
        OutputStatus(true);
    } else {
        OutputStatus(false);
    }
}

function changePassword($conn, $userId, $password, $newPassword){

    $sql = "SELECT * FROM user WHERE user_id = $userId AND password='$password'";
    
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $sql = "UPDATE user SET password = '$newPassword' WHERE user_id = $userId";

        if ($conn->query($sql) === TRUE) {
            OutputStatus(true);
        } else {
            OutputStatus(false);
        }
    }else{
        OutputStatusWithData(false,"Kata laluan salah.");
    }

   
}

function checkEmailExists($conn, $email)
{
    $sql = "SELECT * FROM user WHERE email='$email'";
    
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        return true;
    }
    return false;
}

?>