function check() {
    var username = document.frmLogin.txtUserName.value;
    var password = document.frmLogin.txtPassword.value;

    if (username == "admin" && password == "123")
        alert("Welcome to world of JavaScript");
    else
        alert("Invalid Username or password");
}