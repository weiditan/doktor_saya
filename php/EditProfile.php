<?php

if (isset($_POST['role_id'])) {
    
    $role_id     = $_POST['role_id'];
    $user_id     = $_POST['user_id'];
    $role        = $_POST['role'];
    $fullname    = $_POST['fullname'];
    $nickname    = $_POST['nickname'];
    $gender      = $_POST['gender'];
    $birthday    = $_POST['birthday'];
    $phone       = $_POST['phone'];
    $image_name  = $_POST['image_name'];
    $base64Image = base64_decode($_POST['base64image']);
    $mmc         = $_POST['mmc'];
    
    $profileFolder = "Images/Profiles/";
    
    if ($image_name != null) {
        file_put_contents($profileFolder . $image_name, $base64Image);
    }
    
    include "dbconnect.php";
    include "Output.php";
    
    
    
    if (CheckRoleExists($conn, $user_id, $role)) {
        
        if ($role == "patient") {
            updatePatientDatabase($conn, $role_id, $fullname, $nickname, $gender, $birthday, $phone, $image_name);
        } elseif ($role == "doctor") {
            updateDoctorDatabase($conn, $role_id, $fullname, $nickname, $gender, $birthday, $phone, $image_name, $mmc);
        }
        
    } else {
        if ($role == "patient") {
            SavePatientDatabase($conn, $role_id, $user_id, $fullname, $nickname, $gender, $birthday, $phone, $image_name);
        } elseif ($role == "doctor") {
            SaveDoctorDatabase($conn, $role_id, $user_id, $fullname, $nickname, $gender, $birthday, $phone, $image_name, $mmc);
        }
    }
    
    
    $conn->close();
    
}

function CheckRoleExists($conn, $user_id, $role)
{
    
    $sql = "SELECT * FROM $role WHERE (user_id ='$user_id')";
    
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        return true;
    }
    return false;
}

function SavePatientDatabase($conn, $role_id, $user_id, $fullname, $nickname, $gender, $birthday, $phone, $image)
{
    
    $sql = "INSERT INTO patient(patient_id, user_id, fullname, nickname, gender, birthday, phone, image)
                            VALUES ('$role_id', '$user_id', '$fullname', '$nickname', '$gender', '$birthday', '$phone' ,'$image')";
    
    if ($conn->query($sql) === TRUE) {
        OutputStatusWithData(true, $role_id);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
}

function SaveDoctorDatabase($conn, $role_id, $user_id, $fullname, $nickname, $gender, $birthday, $phone, $image, $mmc)
{
    
    $sql = "INSERT INTO doctor(doctor_id, user_id, fullname, nickname, gender, birthday, phone, image, mmc)
                            VALUES ('$role_id', '$user_id', '$fullname', '$nickname', '$gender', '$birthday', '$phone', '$image', '$mmc')";
    
    if ($conn->query($sql) === TRUE) {
        OutputStatusWithData(true, $role_id);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
}

function updateDoctorDatabase($conn, $role_id, $fullname, $nickname, $gender, $birthday, $phone, $image, $mmc)
{
    if($image!=null){
        $updateImageCode = "image = '$image',";
    }else{
        $updateImageCode = "";
    }
    
    
    $sql = "UPDATE doctor SET 
                fullname = '$fullname', 
                nickname = '$nickname', 
                gender = '$gender', 
                birthday = '$birthday', 
                phone = '$phone', 
                ".$updateImageCode."
                mmc = '$mmc'
            WHERE doctor_id='$role_id'";
    
    if ($conn->query($sql) === TRUE) {
        OutputStatusWithData(true, $role_id);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
}

function updatePatientDatabase($conn, $role_id, $fullname, $nickname, $gender, $birthday, $phone, $image)
{
    if($image!=null){
        $updateImageCode = "image = '$image',";
    }else{
        $updateImageCode = "";
    }
    
    
    $sql = "UPDATE patient SET 
                fullname = '$fullname', 
                nickname = '$nickname', 
                gender = '$gender', 
                birthday = '$birthday', 
                ".$updateImageCode."
                phone = '$phone'
            WHERE patient_id='$role_id'";
    
    if ($conn->query($sql) === TRUE) {
        OutputStatusWithData(true, $role_id);
    } else {
        OutputStatusWithData(false, "Error: " . $sql . "<br>" . $conn->error);
    }
}

?>