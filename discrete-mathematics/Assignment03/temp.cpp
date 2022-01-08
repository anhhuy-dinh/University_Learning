#include <iostream>
#include <fstream>
#include <vector>
#include <string>
using namespace std;

struct path
{
    int src, dst;
    vector<int> M;
    int s;
};

vector<path> readLines(string filename, int& typegraph, int& nP, int& src, int&dst)
{
    ifstream in(filename);
    vector<int> itemp;
    vector<path> res;
    if (in.is_open())
    {
        string stemp;
        while (!in.eof())
        {
            in >> stemp;
            itemp.push_back(stoi(stemp));
        }
    }
    in.close();
    path ptemp;
    for (int i = 0; i < itemp.size(); i++)
    {
        if (i == 0)
            typegraph = itemp[i];
        else if (i == 1)
            nP = itemp[i];
        else if (i == itemp.size()-2)
            src = itemp[i]-1;
        else if (i == itemp.size()-1)
            dst = itemp[i]-1;
        else
        {
            if (i % 3 == 2)
                ptemp.src = itemp[i]-1;
            else if (i % 3 == 0)
                ptemp.dst = itemp[i]-1;
            else if (i % 3 == 1)
            {
                ptemp.s = itemp[i];
                res.push_back(ptemp);
            }
        }
    }
    return res;
}

bool dijkstra(vector<vector<int>> a, int nP, int src, int dst, path& res)
{
    int maxs = 0;
    for (int i = 0; i < nP; i++)
    {
        for (int j = 0; j < nP; j++)
        {
            if (a[i][j] > 0)
             maxs += a[i][j];
        }
    }
    for (int i = 0; i < nP; i++)
    {
        for (int j = 0; j < nP; j++)
        {
            if (a[i][j] == -1)
                a[i][j] = maxs;
        }
    }

    vector<int> s(nP, 0),
                pl(nP, src),
                len(nP, maxs);
    len[src] = 0;
    int i = 0;
    while (s[dst] == 0)
    {
        for (i = 0; i < nP; i++)
        {
            if (!s[i] && len[i] < maxs)
                break;
        }
        if (i >= nP)
            break;
        for (int j = 0; j < nP; j++)
        {
            if (!s[j] && len[i] > len[j])
            {
                i = j;
            }
        }
        s[i] = 1;

        for (int j = 0; j < nP; j++)
        {
            if (!s[j] && len[i] + a[i][j] < len[j])
            {
                len[j] = len[i] + a[i][j];
                pl[j] = i;
            }
        }
    }
    if (len[dst] > 0 && len[dst] < maxs)
    {
        res.s = len[dst];
        res.src = src;
        res.dst = dst;
        while (pl[i] != src)
        {
            (res.M).push_back(pl[i]);
            i = pl[i];
        }
        return true;
    }
    else
        return false;
}

void adjanMatrix(int np, int typegraph, vector<path> l, vector<vector<int>>& res)
{
    int nl = l.size();
    for (int i = 0; i < nl; i++)
    {
        int indexSrc = l[i].src,
            indexDst = l[i].dst;
        if (!res[indexSrc][indexDst] || res[indexSrc][indexDst] > l[i].s)
            res[indexSrc][indexDst] = l[i].s;
        if (typegraph == 0)
        {
            indexSrc = l[i].dst, indexDst = l[i].src;
            if (!res[indexSrc][indexDst] || res[indexSrc][indexDst] > l[i].s)
                res[indexSrc][indexDst] = l[i].s;
        }
    }
    for (int i = 0; i < np; i++)
    {
        for (int j = 0; j < np; j++)
        {
            if (i != j && res[i][j] == 0)
                res[i][j] = -1;
        }
    }
}

void writefile(string filename, path shortestpath, int nP)
{
    ofstream fout;
    fout.open(filename, ofstream::out);
    fout << "Tong chi phi di chuyen = " << shortestpath.s << endl;
    fout << "Duong di ngan nhat cua do thi la: " << shortestpath.src + 1 << " ";
    int nM = (shortestpath.M).size();
    for (int l = nM - 1; l >= 0; l--)
    {
        fout << "-> " << (shortestpath.M)[l] + 1 << " ";
    }
    fout << "-> " << shortestpath.dst + 1 << " ";
    fout.close();
}

int main()
{
    string filename = "Queen of heart.txt";
    int typegraph, nP, src, dst;
    vector<path> lines = readLines(filename, typegraph, nP, src, dst);
    vector<vector<int>> adjancyM(nP, vector<int>(nP, 0));
    adjanMatrix(nP, typegraph, lines, adjancyM);
    path shortestpath; 
    if (dijkstra(adjancyM, nP, src, dst, shortestpath))
        writefile("ket_qua_bai_3_MSSV.txt", shortestpath, nP);
    else
    {
        ofstream fout;
        fout.open("ket_qua_bai_3_MSSV.txt", ofstream::out);
        fout << "Khong co duong di ngan nhat";
        fout.close();
    }
    return 0;
}