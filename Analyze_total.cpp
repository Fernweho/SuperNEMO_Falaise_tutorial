#include <iostream>
#include <string>
#include <cmath>
#include <TFile.h>
#include <TTree.h>

void analyze(const std::string& filePath)
{
    TFile* f = new TFile(filePath.c_str());
    if (!f || f->IsZombie()) {
        std::cerr << "Error opening file: " << filePath << std::endl;
        return;
    }

    TTree* strom = (TTree*)(f->Get("Sensitivity"));
    if (!strom) {
        std::cerr << "Error: TTree 'Sensitivity' not found in file: " << filePath << std::endl;
        return;
    }

    //strom->GetListOfBranches()->Print();

    int n_calos = 0, n_electrons = 0;
    double calo_energy;
    bool are_two_tracks;

    strom->SetBranchAddress("reco.calorimeter_hit_count", &n_calos);
    strom->SetBranchAddress("reco.passes_two_tracks", &are_two_tracks);
    strom->SetBranchAddress("reco.number_of_electrons", &n_electrons);
    strom->SetBranchAddress("reco.total_calorimeter_energy", &calo_energy);

    int passed1 = 0;
    int passed2 = 0;
    int passed3 = 0;
    int passed4 = 0;
    int N = strom->GetEntries();

    for (int i = 0; i < N; i++)
    {
        strom->GetEntry(i);
        if (n_calos == 2) passed1++;
        if (n_calos == 2 && are_two_tracks) passed2++;
        if (n_calos == 2 && are_two_tracks && n_electrons == 2) passed3++;
        if (n_calos == 2 && are_two_tracks && n_electrons == 2 && calo_energy > 2.0) passed4++;
    }

    std::cout << std::endl << "EFFICIENCIES :" << std::endl;
    std::cout << "eps1 = " << (100.0 * passed1) / N << "% +- " << (100.0 * std::sqrt(double(passed1))) / N << "%" << std::endl;
    std::cout << "eps2 = " << (100.0 * passed2) / N << "% +- " << (100.0 * std::sqrt(double(passed2))) / N << "%" << std::endl;
    std::cout << "eps3 = " << (100.0 * passed3) / N << "% +- " << (100.0 * std::sqrt(double(passed3))) / N << "%" << std::endl;
    std::cout << "eps4 = " << (100.0 * passed4) / N << "% +- " << (100.0 * std::sqrt(double(passed4))) / N << "%" << std::endl;

    delete f;
}

int main(int argc, char* argv[])
{
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <path_to_root_file>" << std::endl;
        return 1;
    }

    std::string filePath = argv[1];
    analyze(filePath);

    return 0;
}
