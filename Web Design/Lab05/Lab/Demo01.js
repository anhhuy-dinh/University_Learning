m = prompt("Mời bạn nhập M:");
n = prompt("Mời bạn nhập N:");

document.write("<table width='100%' border='1' cellspacing='0' cellpadding='0'");

for(i = 1; i <= m; i++)
{
    document.write("<tr>");
    for(j = 1; j <= n; j++)
    {
        document.write("<td align=center>" + i + j + "</td>");
    }
    document.write("</tr>");
}
document.write("</table>");