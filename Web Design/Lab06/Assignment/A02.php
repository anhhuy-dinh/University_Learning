<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title> A02 </title>
    <link href="A02.css" rel="stylesheet" type="text/css" />
    <?php
        // define variables and set to empty values
        $nameErr = $emailErr = $genderErr = "";
        $nameStyle = $emailStyle = $genderStyle = "";
        $name = $email = $gender = $website = $comment = "";

        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            if (empty($_POST["name"])) {
                $nameErr = "Name is required";
                $nameStyle='style="background-color: #FDECB2;"'; 
            } else {
                $name = test_input($_POST["name"]); 
            }

            if (empty($_POST["email"])) {
                $emailErr = "Email is required";
                $emailStyle='style="background-color: #FDECB2;"'; 
            } else {
                $email = test_input($_POST["email"]);
            }

            if (empty($_POST["website"])) {
                $website = "";
            } else {
                $website = test_input($_POST["website"]);
            }

            if (empty($_POST["comment"])) {
                $comment = "";
            } else {
                $comment = test_input($_POST["comment"]);
            }

            if (empty($_POST["gender"])) {
                $genderErr = "Gender is required";
                $genderStyle='style="background-color: #FDECB2;"'; 
            } else {
                $gender = test_input($_POST["gender"]);
            }
        }

        function test_input($data) {
            $data = trim($data);
            $data = stripslashes($data);
            $data = htmlspecialchars($data);
            return $data;
        }
    ?>
</head>
<body>
    <div id="container">
        <h2> PHP Form Validation Example </h2>
        <p><span class="error"> * require field. </span></p>
        <form method="post" action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']);?>">
            <div id="row-name" <?php echo $nameStyle; ?>>
                <div id="col1"> Name: </div>
                <div id="col2"> 
                    <input type="text" name="name"/> 
                    <span class="error">* <?php echo $nameErr;?></span>
                </div>
            </div>
            <div id="row-email" <?php echo $emailStyle; ?>>
                <div id="col1"> Email: </div>
                <div id="col2">
                    <input type="text" name="email"/>
                    <span class="error">* <?php echo $emailErr;?></span>
                </div>
            </div>
            <div id="row-website">
                <div id="col1"> Website: </div>
                <div id="col2">
                    <input type="text" name="website"/>
                </div>
            </div>
            <div id="row-cmt">
                <div id="col1"> Comment: </div>
                <div id="col2" class="cmt">
                    <textarea name="comment" rows="5" cols="40"></textarea>
                </div>
            </div>
            <div id="row-gender" <?php echo $genderStyle; ?>>
                <div id="col1"> Gender: </div>
                <div id="col2">
                    <input type="radio" name="gender" value="female"> Female
                    <input type="radio" name="gender" value="male"> Male
                    <span class="error">* <?php echo $genderErr;?></span>
                </div>
            </div>
            <div id="row">
                <div id="col1"></div>
                <div id="col2">
                    <input type="submit" name="submit" value="Submit">
                </div>
            </div>
        </form>
    </div>
    <?php
        echo "<h3> Your Input: </h3>";
        echo "<table> 
              <tr> 
              <td id='col'> Name: </td>
              <td>";
        echo $name;
        echo "</td> </tr> <tr>
              <td id='col'> Email: </td> <td>";
        echo $email;
        echo "</td> </tr> <tr>
              <td id='col'> Website: </td> <td>";
        echo $website;
        echo "</td> </tr> <tr>
              <td id='col'> Comment: </td> <td>";
        echo $comment;
        echo "</td> </tr> <tr>
              <td id='col'> Gender: </td> <td>";
        echo $gender;
        echo "</td> </tr> </table>";
    ?>
</body>
</html>