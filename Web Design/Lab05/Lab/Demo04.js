function calculate() {
    num1 = document.frm1.txtNum1.value;
    num2 = document.frm1.txtNum2.value;
    op = document.frm1.op.value;
    s = num1 + op + num2;
    result = eval(s);
    document.frm1.txtResult.value = result;
}