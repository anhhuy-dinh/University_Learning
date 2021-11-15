#include <iostream>
#include <string>
#include <math.h>

using namespace std;

void chuyenSangNhiPhan(int n, int soBien, int ketQua[])
{
    for (int i = soBien - 1; i >= 0; i--)
    {
        ketQua[i] = n % 2;
        n = n / 2;
    }
}

int xacDinhSoBien(char s[])
{
    
    if (s[0] == '~')
        return 1;
    else if (s[0] == '^' || s[0] == 'v' || s[0] == '-' || s[0] == '<')
        return 2;
    else
        cout << "Phep toan khong hop le.";
}

int phepToan2Ngoi(int p, int q, char s[])
{
    if (s[0] == '^')
    {
        if (p == 1 && q == 1)
            return 1;
        else return 0;
    }
    else
        if (s[0] == 'v')
        {
            if (p == 0 && q == 0)
                return 0;
            else return 1;
        }
        else
            if (s[0] == '-')
            {
                if (p == 1 && q == 0)
                    return 0;
                else return 1;
            }
            else if (s[0] == '<')
                if (p == q)
                    return 1;
                else return 0;
                else
                    cout << "Phep toan khong hop le.";
}

int phuDinh(int p)
{
    if (p == 0)
        return 1;
    else return 0;
}

void printTruthTable(char s[])
{
    int soBien = xacDinhSoBien(s);
    string hangTieuDe[10];
    int bangChanTri[10][10];
    if (soBien == 1)
    {
        hangTieuDe[0] = "p";
        hangTieuDe[1] = "~p";
    }
    else
    {
        hangTieuDe[0] = "p";
        hangTieuDe[1] = "q";
        hangTieuDe[2] = "p " + string(s) + " q";
    }
    for (int i = 0; i < pow(2, soBien); i++)
    {
        chuyenSangNhiPhan(i, soBien, bangChanTri[i]);
        if (soBien == 1)
            bangChanTri[i][soBien] = phuDinh(bangChanTri[i][soBien-1]);
        else
            bangChanTri[i][soBien] = phepToan2Ngoi(bangChanTri[i][soBien-2], bangChanTri[i][soBien-1], s);
    }

    for (int i = 0; i < soBien + 1; i++)
        cout << hangTieuDe[i] << "\t";
    cout << endl;
    for (int i = 0; i < pow(2, soBien); i++)
    {
        for (int j = 0; j < soBien + 1; j++)
            if (bangChanTri[i][j] == 0)
                cout << "F" << "\t";
            else
                cout << "T" << "\t";
        cout << endl;
    }
}

int main()
{
    char s[][10] = {"~", "^", "v", "->", "<->"};
    for (int i = 0; i < 5; i++)
    {
        printTruthTable(s[i]);
        cout << endl;
    }
    // printTruthTable(opt[0]);
    return 0;
}