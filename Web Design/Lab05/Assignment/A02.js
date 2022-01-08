function chk(row)
{
    var b = parseInt(document.getElementById("B" + row).value);
    var a = parseInt(document.getElementById("A" + row).value);
    if (b < 0 || b > a)
    {
        alert("Số lượng không đủ đáp ứng. Xin hãy nhập lại.");
        document.getElementById('B' + row).value = '';
    }
}

function check(row)
{
    var chkNode = document.getElementById("chk" + row);
    if (chkNode.checked == true) {
        var b = parseInt(document.getElementById('B' + row).value);
        var c = parseInt(document.getElementById('C' + row).value);
        var result = b * c;
        return result;
    }
    else
    {
        return 0;
    }
}

function calculate()
{
    var numRow = parseInt((document.getElementsByName("SoLuongCo")).length);
    var total = 0;
    for (i = 0; i < numRow; i++)
    {
        var i_total = check(i+1);
        total = total + i_total;
    }
    var chkVat = document.getElementById("chkVAT");
    if (chkVat.checked == true)
    {
        total = total + total * 0.1;
    }
    document.frmInvoice.Total.value = total;
}

