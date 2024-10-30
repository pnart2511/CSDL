
=SUMPRODUCT((D2:D7="PTV") * (C2:C7>=5000000) * C2:C7)
#include <iostream>
#include <string>
#include <algorithm>

class SinhVien {
protected:
    std::string MaSV;
    std::string HoTen;
    int NamSinh;

public:
    SinhVien() : MaSV(""), HoTen(""), NamSinh(0) {}

    SinhVien(const std::string& maSV, const std::string& hoTen, int namSinh)
        : MaSV(maSV), HoTen(hoTen), NamSinh(namSinh) {}

    virtual void Nhap() {
        std::cout << "Nhap Ma SV: ";
        std::cin >> MaSV;
        std::cout << "Nhap Ho Ten: ";
        std::cin.ignore();
        std::getline(std::cin, HoTen);
        std::cout << "Nhap Nam Sinh: ";
        std::cin >> NamSinh;
    }

    virtual void Xuat() const {
        std::cout << "Ma SV: " << MaSV << ", Ho Ten: " << HoTen << ", Nam Sinh: " << NamSinh << std::endl;
    }
};

class SinhVienCNTT : public SinhVien {
private:
    int SoTCTichLuy;
    float DiemTBTichLuy;

public:
    SinhVienCNTT() : SinhVien(), SoTCTichLuy(0), DiemTBTichLuy(0.0f) {}

    SinhVienCNTT(const std::string& maSV, const std::string& hoTen, int namSinh, int soTC, float diemTB)
        : SinhVien(maSV, hoTen, namSinh), SoTCTichLuy(soTC), DiemTBTichLuy(diemTB) {}

    void Nhap() override {
        SinhVien::Nhap();
        std::cout << "Nhap So TC Tich Luy: ";
        std::cin >> SoTCTichLuy;
        std::cout << "Nhap Diem TB Tich Luy: ";
        std::cin >> DiemTBTichLuy;
    }

    void Xuat() const override {
        SinhVien::Xuat();
        std::cout << "So TC Tich Luy: " << SoTCTichLuy << ", Diem TB Tich Luy: " << DiemTBTichLuy << std::endl;
    }

    float getDiemTBTichLuy() const {
        return DiemTBTichLuy;
    }

    bool operator>(const SinhVienCNTT& other) const {
        return this->DiemTBTichLuy > other.DiemTBTichLuy;
    }
};

void nhapDanhSachSinhVienCNTT(SinhVienCNTT* ds, int n) {
    for (int i = 0; i < n; ++i) {
        std::cout << "Nhap thong tin sinh vien thu " << i + 1 << ":\n";
        ds[i].Nhap();
    }
}

void xuatDanhSachSinhVienCNTT(const SinhVienCNTT* ds, int n) {
    for (int i = 0; i < n; ++i) {
        ds[i].Xuat();
    }
}

void sapXepSinhVienCNTT(SinhVienCNTT* ds, int n) {
    std::sort(ds, ds + n, [](const SinhVienCNTT& a, const SinhVienCNTT& b) {
        return a.getDiemTBTichLuy() < b.getDiemTBTichLuy();
    });
}

int main() {
    int n;
    std::cout << "Nhap so luong sinh vien CNTT: ";
    std::cin >> n;

    SinhVienCNTT* ds = new SinhVienCNTT[n];

    nhapDanhSachSinhVienCNTT(ds, n);

    std::cout << "\nDanh sach sinh vien truoc khi sap xep:\n";
    xuatDanhSachSinhVienCNTT(ds, n);

    sapXepSinhVienCNTT(ds, n);

    std::cout << "\nDanh sach sinh vien sau khi sap xep tang dan theo diem TB Tich Luy:\n";
    xuatDanhSachSinhVienCNTT(ds, n);

    delete[] ds;
    return 0;
}


