<!DOCTYPE html>
<html>
<head>
    <link href="Demo05.css" rel="stylesheet" type="text/css"/>
</head>

<body>
    <?php 
        $Type = $_GET['ConnectType'];
        if(strcmp($Type, 'ConnectToMySQL') == 0)
        {
            $servername = "localhost";
            $username = "root";
            $password = "";
            $dbname = "accountinfo";

            // Create connection
            $conn = new mysqli($servername, $username, $password, $dbname);

            // Check connection
            if ($conn->connect_error) {
                echo "Connection to MySQL could not be established. <br/><br/>";
                die("Connection failed: " . $conn->connect_error);
            }
        }

        $sql = "SELECT FirstName, LastName, Email, ID FROM account";
        $result = $conn->query($sql);

        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            echo "<td id='ID'>" . $row['ID'] . "</td>";
            echo "<td id='FirstName'>" . $row['FirstName'] . "</td>";
            echo "<td id='LastName'>" . $row['LastName'] . "</td>";
            echo "<td id='Email'>" . $row['Email'] . "</td>";
            echo "</tr>";
        }
        mysqli_close($conn);
    ?>
</body>
</html>