function validateEmail(email) {
    var re = /[^\s@]+@[^\s@]+\.[^\s@]+/;
    return re.test(email);
}
function validate() {
    var email = document.frm.email.value;
    var info = document.getElementById("information");

    if (validateEmail(email)) {
        info.innerHTML = email + " is valid :)";
        info.style.color = "green";
    }
    else
    {
        info.innerHTML = email + " is invalid :)";
        info.style.color = "red";
    }
}

function check()
{
    var chkNode = document.getElementById("chkDisable");

    if (chkNode.checked == true) {
        document.getElementById("email").disabled = true;
    }
    else
    {
        document.getElementById("email").disabled = false;
    }
}