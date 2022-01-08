id = prompt("Mời bạn nhập MSSV: ");
Name = prompt("Mời bạn nhập Họ và tên: ");
Class = prompt("Mời bạn nhập Lớp: ");

var info = [id, Name, Class];

document.write("<table width='100%' border='1' cellspacing='0' cellpadding='0' >");

document.write("<tr><td colspan='3' align=center> Danh sách sinh viên </td></tr>");
document.write("<tr>");
document.write("<td align=center> MSSV </td>");
document.write("<td align=center> Họ tên </td>");
document.write("<td align=center> Lớp </td>");
document.write("</tr>");

document.write("<tr>");
for (i = 0; i < 3; i++)
{
    document.write("<td align=center>" + info[i] + "</td>");
}
document.write("</tr>");
document.write("</table>");