#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <algorithm>

using namespace std;

vector<string> doc_file(string ten_file)
{
    vector<string> ma_tran_ke;
    string dong;

    ifstream file(ten_file);

    while(getline(file, dong))
    {
        ma_tran_ke.push_back(dong);
    }
    file.close();
    
    for (int i = 0; i < ma_tran_ke.size(); i++)
    {
        ma_tran_ke[i].erase(remove(ma_tran_ke[i].begin(), ma_tran_ke[i].end(), ' '), ma_tran_ke[i].end());
    }

    return ma_tran_ke;
}

void kiem_tra_thanh_phan_lien_thong(vector<string> ma_tran_ke)
{
    vector<int> so_sanh;
    int so_dinh = ma_tran_ke.size();

    for (int i = 0; i < so_dinh; i++)
    {
        so_sanh.push_back(i);
    }

    for (int i = 0; i < so_dinh; i++)
    {
        for (int j = 0; j < so_dinh; j++)
        {
            if (ma_tran_ke[i][j] == '1')
            {
                if (so_sanh[i] != so_sanh[j])
                {
                    if (so_sanh[i] < so_sanh[j])
                        so_sanh[j] = so_sanh[i];
                    else
                        so_sanh[i] = so_sanh[j];
                }   
            }
        }
    }

    vector<int> tam;
    for (int i = 0; i < so_dinh; i++)
    {
        int danh_dau = 0;
        for (int j = 0; j < tam.size(); j++)
            if (so_sanh[i] == tam[j])
            {
                danh_dau = 1;
                break;
            }
        if (danh_dau == 1)
            continue;
        else
            tam.push_back(so_sanh[i]);
    }

    vector<vector<int>> cac_thanh_phan_lien_thong;
    
    for (int i = 0; i < tam.size(); i++)
    {
        vector<int> thanh_phan_lien_thong;    
        for (int j = 0; j < so_dinh; j++)
        {
            if (so_sanh[j] == tam[i])
                thanh_phan_lien_thong.push_back(j);
        }
        cac_thanh_phan_lien_thong.push_back(thanh_phan_lien_thong);
    }

    cout << "So thanh phan lien thong: " << cac_thanh_phan_lien_thong.size() << endl;
    for (int i = 0; i < cac_thanh_phan_lien_thong.size(); i++)
    {
        cout << "Thanh phan lien thong thu " << i+1 << ": ";
        for (int j = 0; j < cac_thanh_phan_lien_thong[i].size(); j++)
        {
            cout << cac_thanh_phan_lien_thong[i][j] + 1 << " ";
        }
        cout << endl;
    }
}

int main()
{
    vector<string> ma_tran_ke;
    ma_tran_ke = doc_file("input_dothi.txt");
    kiem_tra_thanh_phan_lien_thong(ma_tran_ke);
    return 0;
}