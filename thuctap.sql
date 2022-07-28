-- 1/Yêu cầu tạo database như hình vẽ.
create database thuctap;
use thuctap;
create table khoa(
	makhoa char(10),
	tenkhoa char(30),
	dienthoai char(11),
	primary key(makhoa)
);
create table giangvien(
	magv int,
    hotengv char(30),
    luong decimal(5,2),
    makhoa char(10),
    primary key(magv),
    foreign key(makhoa) references khoa(makhoa)
);
create table sinhvien(
	masv int,
    hotensv char(30),
    makhoa char(10),
    namsinh int,
    quequan char(30),
    primary key(masv),
    foreign key(makhoa) references khoa(makhoa)
);
create table detai(
	madt char(10),
    tendt char(30),
    kinhphi double,
    noithuctap char(30),
    primary key(madt)
);
create table huongdan(
	masv int,
    madt char(10),
    magv int,
    ketqua decimal(5,2),
    primary key(masv,madt,magv),
    foreign key (masv) references sinhvien(masv),
    foreign key (madt) references detai(madt),
    foreign key (magv) references giangvien(magv)
);

insert into khoa values
('Geo','Địa lý và QLTN',3855413),
('Math','Toán',3855411),
('Bio','Công nghệ sinh học',3855412);

insert into giangvien values
(11,'Thanh Xuan',700,'Geo'),
(12,'Thu Minh',500,'Math'),
(13,'Chu Tuan',650,'Geo'),
(14,'Le Thi Lan',500,'Bio'),
(15,'Tran Xoay',900,'Math');

insert into sinhvien values
(1,'Le Van Sao','Bio',1990,'Nghe An'),
(2,'Nguyen Thi My','Geo',1990,'Thanh Hoa'),
(3,'Bui Xuan Duc','Math',1992,'Ha Noi'),
(4,'Nguyen Van Tung','Bio',null,'Ha Tinh'),
(5,'Le Khanh Linh','Bio',1989,'Ha Nam'),
(6,'Tran Khac Trong','Geo',1991,'Thanh Hoa'),
(7,'Le Thi Van','Math',null,'null'),
(8,'Hoang Van Duc','Bio',1992,'Nghe An');

insert into detai values
('DT01','GIS',100,'Nghe An'),
('DT02','ARC GIS',500,'Nam Dinh'),
('DT03','Spatial DB',100,'Ha Tinh'),
('DT04','MAP',300,'Quang Binh');

insert into huongdan values
(1,'DT01',13,8),
(2,'DT03',14,0),
(3,'DT03',12,10),
(5,'DT04',14,7),
(6,'DT01',13,null),
(7,'DT04',11,10),
(8,'DT03',15,6);

-- 2/ Đưa ra thông tin gồm mã số, họ tên, tên khoa của tất cả giảng viên.
select magv, hotengv, tenkhoa
from giangvien gv
join khoa k on gv.makhoa=k.makhoa;

-- 3/ Xuất ra mã số, họ tên, tên khoa của giảng viên hướng dẫn từ 2 sinh viên trở lên.
select hd.magv, gv.hotengv, k.tenkhoa
from huongdan hd
join giangvien gv on hd.magv=gv.magv
join khoa k on gv.makhoa=k.makhoa
group by hd.magv, gv.hotengv, k.tenkhoa
having count(hd.magv) >= 2;

-- 4/ Xuất thông tin những sinh viên chưa có điểm thực tập.
select *
from huongdan hd
join sinhvien sv on sv.masv=hd.masv
where hd.ketqua is null;

-- 5/ Xuất ra SĐT của khoa mà sinh viên Le Van Sao đang học.
select k.dienthoai
from sinhvien sv
join khoa k on sv.makhoa=k.makhoa
where sv.hotensv='Le Van Sao';

-- 6/ Lấy ra mã số và tên các đề tài có nhiều hơn 2 sinh viên thực tập.
select madt, tendt
from detai
where madt in (
				select madt
				from huongdan
				group by madt
				having count(madt)>2
			  );

-- 7/ Lấy ra mã số, tên đề tài của đề tài có kinh phí cao nhất.
select madt,tendt
from detai
having max(kinhphi);

-- 8/ Xuất ra tên khoa, số lượng sinh viên mỗi khoa.alter
select k.tenkhoa, count(sv.makhoa) as soluongsv
from khoa k
join sinhvien sv on k.makhoa=sv.makhoa
group by sv.makhoa, k.tenkhoa;

-- 9/ Xuất ra mã số, họ tên, điểm của các sinh viên khoa 'Địa lý và QLTN'
select sv.masv,sv.hotensv,hd.ketqua
from khoa k
join sinhvien sv on k.makhoa=sv.makhoa
join huongdan hd on sv.masv=hd.masv
where k.tenkhoa='Địa lý và QLTN';

-- 10/ Xuất ra danh sách gồm mã số, họ tên, tuổi của các sinh viên khoa 'Toán'
select sv.masv, sv.hotensv, year(now())-sv.namsinh as tuoi
from sinhvien sv
join khoa k on k.makhoa=sv.makhoa
where k.tenkhoa='Toán';












