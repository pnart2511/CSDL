﻿CREATE DATABASE QUANLYHOCVIEN
USE QUANLYHOCVIEN


CREATE TABLE KHOA
(
    MAKHOA CHAR(4) NOT NULL,
    TENKHOA VARCHAR(40),
    NGTLAP SMALLDATETIME,
    TRGKHOA CHAR(4),
    CONSTRAINT PK_KHOA PRIMARY KEY (MAKHOA),
   
    )

	CREATE TABLE LOP
(
    MALOP CHAR(3) NOT NULL,
    TENLOP VARCHAR(40),
    TRGLOP CHAR(5),
    SISO TINYINT,
    MAGVCN CHAR(4),
    CONSTRAINT PK_LOP PRIMARY KEY (MALOP),
    CONSTRAINT FK_LOP_TRGLOP FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN (MAHV),
    CONSTRAINT FK_LOP_MAGVCN FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN (MAGV)
);
	CREATE TABLE MONHOC
(
    MAMH CHAR(10) NOT NULL,
    TENMH VARCHAR(40),
    TCLT TINYINT,
    TCTH TINYINT,
    MAKHOA CHAR(4),
    CONSTRAINT PK_MONHOC PRIMARY KEY (MAMH),
    CONSTRAINT FK_MONHOC_MAKHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA (MAKHOA)
);
CREATE TABLE DIEUKIEN
(
    MAMH CHAR(10) NOT NULL,
    MAMH_TRUOC CHAR(10) NOT NULL,
    CONSTRAINT PK_DIEUKIEN PRIMARY KEY (MAMH, MAMH_TRUOC),
    CONSTRAINT FK_DIEUKIEN_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC (MAMH),
    CONSTRAINT FK_DIEUKIEN_MAMH_TRUOC FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC (MAMH) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE GIAOVIEN
(
    MAGV CHAR(4) NOT NULL,
    HOTEN VARCHAR(40),
    HOCVI VARCHAR(10),
    HOCHAM VARCHAR(10),
    GIOITINH VARCHAR(3),
    NGSINH SMALLDATETIME,
    NGVL SMALLDATETIME,
    HESO NUMERIC(4,2),
    MUCLUONG MONEY,
    MAKHOA CHAR(4),
    CONSTRAINT PK_GIAOVIEN PRIMARY KEY (MAGV),
    CONSTRAINT CHK_GIOITINH_GV CHECK (GIOITINH IN ('Nam', 'Nu')),
    CONSTRAINT CHK_HOCVI CHECK (HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS')),
    CONSTRAINT FK_GIAOVIEN_MAKHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA (MAKHOA)
);
CREATE TABLE GIANGDAY
(
    MALOP CHAR(3) NOT NULL,
    MAMH CHAR(10) NOT NULL,
    MAGV CHAR(4) NOT NULL,
    HOCKY TINYINT,
    NAM SMALLINT,
    TUNGAY SMALLDATETIME,
    DENNGAY SMALLDATETIME,
    CONSTRAINT PK_GIANGDAY PRIMARY KEY (MALOP, MAMH, MAGV),
    CONSTRAINT FK_GIANGDAY_MALOP FOREIGN KEY (MALOP) REFERENCES LOP (MALOP),
    CONSTRAINT FK_GIANGDAY_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC (MAMH),
    CONSTRAINT FK_GIANGDAY_MAGV FOREIGN KEY (MAGV) REFERENCES GIAOVIEN (MAGV)
);
CREATE TABLE HOCVIEN
(
    MAHV CHAR(5) NOT NULL,
    HO VARCHAR(40),
    TEN VARCHAR(10),
    NGSINH SMALLDATETIME,
    GIOITINH VARCHAR(3),
    NOISINH VARCHAR(40),
    MALOP CHAR(3),

    GHICHU VARCHAR(20),
    DIEMTB NUMERIC(4,2),
    XEPLOAI VARCHAR(20),
    CONSTRAINT PK_HOCVIEN PRIMARY KEY (MAHV),
   
);
CREATE TABLE KETQUATHI
(
    MAHV CHAR(5) NOT NULL,
    MAMH CHAR(10) NOT NULL,
    LANTHI TINYINT NOT NULL,
    NGTHI SMALLDATETIME NOT NULL,
    DIEM NUMERIC(4,2) NOT NULL,
    KQUA VARCHAR(10) NOT NULL,
    CONSTRAINT PK_KETQUATHI PRIMARY KEY (MAHV, MAMH, LANTHI, NGTHI),
    CONSTRAINT FK_KETQUATHI_MAHV FOREIGN KEY (MAHV) REFERENCES HOCVIEN (MAHV),
    CONSTRAINT FK_KETQUATHI_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC (MAMH)
);

ALTER TABLE HOCVIEN
ADD CONSTRAINT CHK_GIOITINH CHECK (GIOITINH IN ('Nam', 'Nu'));

ALTER TABLE KETQUATHI
ADD CONSTRAINT CK_KETQUATHI_KQUA CHECK (DIEM >= 5 AND KQUA = 'Dat' OR DIEM < 5 AND KQUA = 'K Dat');

ALTER TABLE KETQUATHI
ADD CONSTRAINT CK_KETQUATHI_TOIDATHI3LAN CHECK (LANTHI <= 3); --between 1 and 3

ALTER TABLE GIANGDAY
ADD CONSTRAINT CK_GIANGDAY_HOCKY CHECK (HOCKY BETWEEN 1 AND 3); --HOẶC DÙNG IN(1,2,3)

ALTER TABLE GIAOVIEN ADD CONSTRAINT CK_HOCVI_GIAOVIEN CHECK(HOCVI IN ('CN','KS','THS','TS','PTS'));
ALTER TABLE LOP
ADD CONSTRAINT FK_LOP_TRGLOP_HOCVIEN FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN (MAHV) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE KHOA
ADD CONSTRAINT FK_KHOA_TRGKHOA_GIAOVIEN FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN (MAGV);

ALTER TABLE KHOA
ADD CONSTRAINT CK_KHOA_TRGKHOA_HOCVI CHECK (TRGKHOA IN (SELECT MAGV FROM GIAOVIEN WHERE HOCVI IN ('TS', 'PTS')));

ALTER TABLE HOCVIEN ADD CONSTRAINT CK_HOCVIEN_TUOI CHECK(YEAR(GETDATE()) -YEAR(NGSINH)>=18);
ALTER TABLE GIANGDAY ADD CONSTRAINT CK_GIANGDAY CHECK (	TUNGAY < DENNGAY);
ALTER TABLE GIAOVIEN ADD CONSTRAINT CK_TUOIGIAOVIEN CHECK (YEAR(GETDATE()) - YEAR(NGSINH) >=22);

ALTER TABLE MONHOC ADD CONSTRAINT CK_KHONGQUA3TC CHECK (TCLT <=3 AND TCTH <=3);