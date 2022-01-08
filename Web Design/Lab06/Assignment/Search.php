<?php
    header("Content-Type: application/json; charset=UTF-8");
    $obj = json_decode($_GET["search"], false);

    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "accountinfo";

    //Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

    //Check connection
    if ($conn->connect_error) {
        echo "Connection to MySQL could not be established.<br/>";
        die("Connection failed: " . $conn->connect_error);
    } else {
        $querystr = "SELECT ID, FirstName, LastName, Email FROM " . $obj->table;
        $id = 0; $fn = 0; $ln = 0;
        if ($obj->ID != "" || $obj->FirstName != "" || $obj->LastName != "" || $obj->Email != "") {
            $querystr = $querystr . " WHERE";
            if ($obj->ID != "") {
                $querystr = $querystr . " ID LIKE '" . $obj->ID . "'";
                $id = 1;
            }
            if ($obj->FirstName != "") {
                if ($id == 1)
                    $querystr = $querystr . " AND";
                $querystr = $querystr . " FirstName LIKE '" . $obj->FirstName . "'";
                $fn = 1;
            }
            if ($obj->LastName != "") {
                if ($fn == 1)
                    $querystr = $querystr . " AND";
                $querystr = $querystr . " LastName LIKE '" . $obj->LastName . "'";
                $ln = 1;
            }
            if ($obj->Email != "") {
                if ($ln == 1)
                    $querystr = $querystr . " AND";
                $querystr = $querystr . " Email LIKE '" . $obj->Email . "'";
            }
        }
        $result = $conn->query($querystr);
        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            echo "<td id='ID'>" . $row['ID'] . "</td>";
            echo "<td id='FirstName'>" . $row['FirstName'] . "</td>";
            echo "<td id='LastName'>" . $row['LastName'] . "</td>";
            echo "<td id='Email'>" . $row['Email'] . "</td>";
            echo "</tr>";
        }
    }
?>