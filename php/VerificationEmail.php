<?php
    // Import PHPMailer classes into the global namespace
    // These must be at the top of your script, not inside a function
    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\SMTP;
    use PHPMailer\PHPMailer\Exception;
    

    if (isset($_POST['action'])) {
    
        $action = $_POST['action'];
        $email = $_POST['email'];
        $code = $_POST['code'];
        $type = $_POST['type'];
        
        include "dbconnect.php";
        include "Output.php";
        
        switch ($action) {
            
            case "sendVerificationEmail":
                sendVerificationEmail($conn, $email, $type);
                break;
            
            case "checkRegisterCode":
                checkCode($conn, $email, $code, $type);
                break;

            default:
                OutputStatusWithData(false, "Error: No action");
        }
        
        $conn->close();
    }

    function checkCode($conn,$email,$code,$type){
    
        $sql = "SELECT * FROM verification_email WHERE (email='$email' AND code=$code AND TIMESTAMPDIFF(SECOND,NOW(),exptime)>0 AND type ='$type')";
    
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            OutputStatus(true);
        } else {
            OutputStatusWithData(false, "Kod pengesahan salah.");
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

    function sendVerificationEmail($conn,$email,$type){
        
        $code = rand(0,9).rand(0,9).rand(0,9).rand(0,9).rand(0,9).rand(0,9);
        

        if($type=="Forgot Password"){
            if(CheckEmailExists($conn, $email)){

                if(SaveToDatabase($conn,$email,$code,$type)=="Done" AND SendMail($email,$code,$type)=="Done"){
                    OutputStatus(true);
                }else{
                    OutputStatus(false);
                }
            }else{
                OutputStatusWithData(false,"Email tiada dalam sistem.");
            }
        }else{
            if(!CheckEmailExists($conn, $email)){

                if(SaveToDatabase($conn,$email,$code,$type)=="Done" AND SendMail($email,$code,$type)=="Done"){
                    OutputStatus(true);
                }else{
                    OutputStatus(false);
                }
            }else{
                OutputStatusWithData(false,"Email tersebut telah didaftarkan.");
            }
        }
        
    }
    

    function SaveToDatabase($conn,$email,$code,$type){

        $sql = "INSERT INTO verification_email (email, code, exptime, type)
                                        VALUES ('$email', $code, (NOW() + INTERVAL 5 MINUTE), '$type')";

        if ($conn->query($sql) === TRUE) {
            $savestatus = "Done";
        } else {
            $savestatus = "Error: " . $sql . "<br>" . $conn->error;
        }

        return $savestatus;
    }

    function SendMail($email,$code,$type){
        
        // Load
        require 'PHPMailer-6.1.7/src/Exception.php';
        require 'PHPMailer-6.1.7/src/PHPMailer.php';
        require 'PHPMailer-6.1.7/src/SMTP.php';

        // Instantiation and passing `true` enables exceptions
        $mail = new PHPMailer(true);

        try {
            //Server settings
            //$mail->SMTPDebug = SMTP::DEBUG_SERVER;                      // Enable verbose debug output
            $mail->isSMTP();                                            // Send using SMTP
            $mail->Host       = 'smtp.hostinger.com';                    // Set the SMTP server to send through
            $mail->SMTPAuth   = true;                                   // Enable SMTP authentication
            $mail->Username   = 'noreply@breakvoid.com';                     // SMTP username
            $mail->Password   = 'oW17&+I!7*';                               // SMTP password
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;         // Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
            $mail->Port       = 587;                                    // TCP port to connect to, use 465 for `PHPMailer::ENCRYPTION_SMTPS` above

            //Recipients
            $mail->setFrom('noreply@breakvoid.com', 'Doktor Saya');
            //$mail->addAddress('joe@example.net', 'Joe User');     // Add a recipient
            $mail->addAddress($email);               // Name is optional
            //$mail->addReplyTo('info@example.com', 'Information');
            //$mail->addCC('cc@example.com');
            //$mail->addBCC('bcc@example.com');

            // Attachments
            //$mail->addAttachment('/var/tmp/file.tar.gz');         // Add attachments
            //$mail->addAttachment('/tmp/image.jpg', 'new.jpg');    // Optional name

            // Content
            $mail->isHTML(true);                                  // Set email format to HTML
            $mail->Subject = 'E-mel Pengesahan';

            if($type=="Forgot Password"){
                $a = "mengguna";
            }else{
                $a = "mendaftar";
            }
            
            $mail->Body    = '  <table align="center" border="0" cellpadding="0" cellspacing="0" style="max-width:600px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <img src="http://www.breakvoid.com/DoktorSaya/Images/logo.png" width="150px"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Terima kasih anda '.$a.' DoktorSaya app.
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <center>
                                                    <h2>Kod pengesahan anda ialah :</h2>
                                                    <h1>'.$code.'</h1>
                                                </center>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            ';
                            
            $mail->AltBody = 'Terima kasih anda mendaftar DoktorSaya app. Kod pengesahan anda ialah : '.$code.'';

            $mail->send();
            $sendstatus = "Done";
        } catch (Exception $e) {
            $sendstatus =  "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
        }

        return $sendstatus;
    }

?>