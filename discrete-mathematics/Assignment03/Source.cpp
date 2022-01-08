/*
MSSV: 18110171				
Họ tên: Vũ Thiện Nhân	
IDE: Visual Studio 2015		
Môn: Toán rời rạc			
Assignment 3			
Ngày làm: 26/12/2021		
*/
#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <complex>
#include <string.h>
#include <vector>
#include <iomanip>
#include <stdlib.h>
#include <stack>
#include <windows.h>
using namespace std;

void docfile(const char tenfile[], vector<string>& A, vector <int> & A1)
{
	freopen(tenfile, "r", stdin);
	int n;
	cin >> n;
	for (int i = 0; i < 2; i++)
	{
		int a1;
		string a;
		cin >> a;
		a1 = atoi(a.c_str());
		cout << a1;
		A1.push_back(a1);
	}
	int t = 0;
	for (int i = 0; i < 0.5 * n * (n - 1); i++)
	{
		string a;
		cin >> a;
		A.push_back(a);
		if (A[t] == "")
		{
			break;
		}
		t = t + 1;
	}
	A.pop_back();
}
void taomangbien(vector<string> A, vector<string> &B)
{
	for (int i = 0; i < A.size(); i++)
	{
		string bien1;
		string bien2;
		int k = 0;
		for (int j = 0; j < A[i].size(); j++)
		{

			if ((A[i][j] > 64 && A[i][j] < 91) || (A[i][j] > 96 && A[i][j] < 123))
			{
				bien1 += A[i][j];
			}
			if (A[i][j] == 44)
			{
				k = j;
				break;
			}
		}
		B.push_back(bien1);
		for (int j = k + 1; j < A[i].size(); j++)
		{
			int k;
			if ((A[i][j] > 64 && A[i][j] < 91) || (A[i][j] > 96 && A[i][j] < 123))
			{
				bien2 += A[i][j];
			}
		}
		B.push_back(bien2);
	}
}
void taomangbiensapxep(vector<string> B, vector<string>& D)
{
	for (int i = 0; i < B.size(); i++)
	{
		D.push_back(B[i]);
	}

	for (int i = 0; i < B.size(); i++)
	{
		for (int j = i + 1; j < B.size(); j++)
		{

			for (int k = 0; k < B[min(D[i].size(), D[j].size())].size() + 1; k++)
			{
				if (D[i][k] == D[j][k])
				{
					continue;

				}

				if (D[i][k] > D[j][k])
				{
					swap(D[i], D[j]);

				}
				break;
			}

		}
	}

}
void timcacbien(vector<string> D, vector <string>& C)
{
	int c = 0;
	for (int i = 0; i < D.size() - 1; i++)
	{

		if (D[i] != D[i + 1])
		{
			C.push_back(D[i]);
			c = c + 1;
		}

	}
	C.push_back(D[D.size() - 1]);

}
void taodothi(vector<string>& A, vector<string>& B, vector<string> &C, int bc[100][100])
{

	std::vector <string> F;
	for (int i = 0; i < A.size(); i++)
	{
		string df;
		for (int j = 0; j < A[i].size(); j++)
		{

			if (A[i][j] > 47 && A[i][j] < 58)
			{
				df += A[i][j];
			}
		}
		F.push_back(df);
	}
	string BC[100][100];
	for (int i = 0; i < C.size(); i++)
	{
		for (int j = 0; j < C.size(); j++)
		{
			BC[i][j] = '0';
		}
	}

	for (int i = 0; i < B.size(); i = i + 2)
	{
		for (int j = 0; j < C.size(); j++)
		{
			for (int k = 0; k < C.size(); k++)
			{
				if (B[i] == C[j] && B[i + 1] == C[k])
				{
					BC[j][k] = F[i / 2];
					BC[k][j] = F[i / 2];
				}

			}
		}
	}
	for (int i = 0; i < C.size(); i++)
	{
		for (int j = 0; j < C.size(); j++)
		{
			bc[i][j] = atoi(BC[i][j].c_str());
		}
	}
}
void xuatdothi(vector<string> C, int BC[100][100])
{

	cout << "Do thi co dang la " << endl << endl;

	int t = 7;
	int t1 = 4;
	cout << setw(11);
	for (int j = 0; j < C.size(); j++)
	{
		cout << C[j] << setw(t);
	}
	cout << endl;
	for (int i = 0; i < C.size(); i++)
	{
		cout << C[i] << setw(t1);
		for (int j = 0; j < C.size(); j++)
		{

			cout << BC[i][j] << setw(t);

		}
		cout << endl;
	}
}

void dijkstra(int BC[100][100], int size, int a, int b, vector<string> C)
{
	int BC1[100][100], kc[100], pred[100], visit[100], kcnn, c, t;
	for (int i = 0; i < size; i++)
	{
		for (int j = 0; j < size; j++)
		{
			if (BC[i][j] == 0)
				BC1[i][j] = 999;
			else
				BC1[i][j] = BC[i][j];
		}
	}
	for (int i = 0; i < size; i++)
	{
		kc[i] = BC1[a][i];
		pred[i] = (a);
		visit[i] = 0;
	}
	kc[a] = 0;
	visit[a] = 1;
	t = 1;
	while (t < size - 1)
	{
		kcnn = 999;

		for (int i = 0; i < size; i++)
		{
			if (kc[i] < kcnn && !visit[i])
			{
				kcnn = kc[i];
				c = i;
			}
		}
		visit[c] = 1;
		for (int i = 0; i < size; i++)
			if (!visit[i])
				if (kcnn + BC1[c][i] < kc[i])
				{
					kc[i] = kcnn + BC1[c][i];
					pred[i] = c;
				}
		t++;
	}
	stack <string> duongdi;

	if (b != a)
	{
		if (kc[b] == 999)
		{
			cout << endl << endl << "Khong co duong di tu " << C[a] << " den " << C[b];
		}
		else
		{
			duongdi.push(C[b]);
			int j = b;
			do
			{
				j = pred[j];
				duongdi.push(" -> ");
				duongdi.push(C[j]);
			} while (j != a);
		}

	}
	cout << "Tong chi phi di chuyen = " << kc[b];
	cout << endl << "Duong di ngan nhat cua do thi la: ";
	while (!duongdi.empty())
	{
		cout << duongdi.top();
		duongdi.pop();
	}
	cout << "\n";
}
int main()
{
	int BC[100][100];
	vector<string> A;
	vector<int> A1;
	vector<string> B;
	vector<string> D;
	vector<string> C;
	docfile("graph.txt", A, A1);
	taomangbien(A, B);
	taomangbiensapxep(B, D);
	timcacbien(D, C);
	taodothi(A, B, C, BC);
	xuatdothi(C, BC);
	dijkstra(BC, C.size(), A1[0], A1[1], C);

	return 0;
}
