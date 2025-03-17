use BTT2;
/*1.Liệt kê danh sách sinh viên, gồm các thông tin sau: Mã sinh viên, Họ sinh viên, Tên sinh
viên, Học bổng. Danh sách sẽ được sắp xếp theo thứ tự Mã sinh viên tăng dần.*/
select MaSv, HoSV, TenSV, HocBong
from DSSinhVien
order by MaSV asc;
/*2.Danh sách các sinh viên gồm thông tin sau: Mã sinh viên, họ tên sinh viên, Phái, Ngày sinh.
Danh sách sẽ được sắp xếp theo thứ tự Nam/Nữ*/
select MaSV, HoSV, TenSV, Phai, NgaySinh
from DSSinhVien
order by Phai;
/*3.Thông tin các sinh viên gồm: Họ tên sinh viên, Ngày sinh, Học bổng. Thông tin sẽ được sắp
xếp theo thứ tự Ngày sinh tăng dần và Học bổng giảm dần.*/
select HoSV + ' ' + TenSV as HoTen, NgaySinh, HocBong
from DSSinhVien
order by NgaySinh asc,HocBong desc;
/*4.Liệt kê các sinh viên có học bổng từ 150,000 trở lên và sinh ở Hà Nội, gồm các thông tin:
Họ tên sinh viên, Mã khoa, Nơi sinh, Học bổng.*/
select HoSV + ' ' + TenSV AS HoTen, MaKhoa, NoiSinh, HocBong
from DSSinhVien sv
where sv.HocBong >= 150000 and sv.NoiSinh = N'Hà Nội';
/*5.Danh sách những sinh viên có học bổng từ 80.000 đến 150.000, gồm các thông tin: Mã sinh
viên, Ngày sinh, Phái, Mã khoa*/
select MaSV, NgaySinh, Phai, MaKhoa
from DSSinhVien sv
where sv.HocBong >= 80000 and sv.HocBong <= 150000;
/*6.Cho biết những môn học có số tiết lớn hơn 30 và nhỏ hơn 45, gồm các thông tin: Mã môn
học, Tên môn học, Số tiết*/
select MaMH, TenMH, SoTiet
from DMMonHoc
where SoTiet > 30 and SoTiet < 45;
/*7.Danh sách những sinh viên có tuổi từ 20 đến 25, thông tin gồm: Họ tên sinh viên, Tuổi, Tên
khoa.*/
select HoSV + ' ' + TenSV as HoTen,
	   year(getdate()) - year(sv.NgaySinh) as Tuoi,
	   k.TenKhoa
		
from DSSinhVien sv
join DMKhoa k on sv.MaKhoa = k.MaKhoa
where year(getdate()) - year(sv.NgaySinh) between 20 and 25;

/*8.Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Phái, Mã khoa,
Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá trị của field
học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”*/
select MaSV, Phai, MaKhoa,
	case 
		when HocBong > 500000 then N'Hoc bong cao'
		else N'Muc trung binh'
	end as MucHocBong
from DSSinhVien;
/*9.Cho biết tổng số sinh viên của toàn trường.*/
select count(*) as TongSoSinhVien
from DSSinhVien;
/**/
/*10.Cho biết tổng sinh viên và tổng sinh viên nữ.*/
select count(*) as TongSinhVien,
	   count(case when Phai = N'Nữ' then 1 end) as TongSinhVienNu	
from DSSinhVien;
/*11.Cho biết tổng số sinh viên của từng khoa.*/
select k.MaKhoa, k.TenKhoa , count(*) as TongSoSinhVienTungKhoa
from DSSinhVien sv
join DMKhoa k on k.MaKhoa = sv.MaKhoa
group by k.MaKhoa, k.TenKhoa;
--12.Cho biết số lượng sinh viên học từng môn.
select mh.MaMH, mh.TenMH, count(distinct kq.MaSV) as SoLuongSinhVien
from KetQua kq
join DMMonHoc mh on kq.MaMH = mh.MaMH
group by mh.MaMH, mh.TenMH;
--13.Cho biết số lượng môn học mà sinh viên đã học(tức tổng số môn học có trong bảng kq)
select MaSV, count(distinct MaMH) as SoLuongMonHoc
from KetQua
group by MaSV;
--14.Cho biết tổng số tiền học bổng của mỗi khoa.
select k.MaKhoa, k.TenKhoa, sum(sv.HocBong) as TongSoHocBong 
from DSSinhVien sv
join DMKhoa k on sv.MaKhoa = k.MaKhoa
group by k.MaKhoa, k.TenKhoa
--15.Cho biết học bổng cao nhất của mỗi khoa.
select k.MaKhoa, k.TenKhoa, max(sv.HocBong) as HocBongCaoNhat
from DSSinhVien sv
join DMKhoa k on sv.MaKhoa = k.MaKhoa
group by k.MaKhoa, k.TenKhoa;
--16.Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa
select k.MaKhoa, k.TenKhoa,
	   sum(case when sv.Phai = N'Nam' then 1 else 0 end) as TongSoSinhVienNam,
	   sum(case when sv.Phai = N'Nữ' then 1 else 0 end) as TongSoSinhVienNu
from DSSinhVien sv
join DMKhoa k on sv.MaKhoa = k.MaKhoa
group by k.MaKhoa, k.TenKhoa;
--17.Cho biết những năm sinh nào có 2 sinh viên đang theo học tại trường.select year(NgaySinh) as NamSinh, count(*) as SoLuongSinhVien
from DSSinhVien 
group by YEAR(NgaySinh)
having count(*) = 2;
--18. Cho biết những sinh viên thi lại trên 2 lần.
SELECT sv.MaSV, sv.HoSV, sv.TenSV, COUNT(DISTINCT kq.LanThi) AS SoLanThiLai
FROM KetQua kq
JOIN DSSinhVien sv ON sv.MaSV = kq.MaSV
WHERE kq.LanThi > 1
GROUP BY sv.MaSV, sv.HoSV, sv.TenSV
HAVING COUNT(DISTINCT kq.LanThi) > 2;
--19.Đưa ra điểm trung bình của sinh viên có mã ‘A06’.
select kq.MaSV, sv.HoSV, sv.TenSV, avg(kq.Diem) as DiemTrungBinh
from KetQua kq
join DSSinhVien sv on kq.MaSV = sv.MaSV
WHERE kq.MaSV = 'A06'
GROUP BY kq.MaSV, sv.HoSV, sv.TenSV;
--20.Thống kê số học sinh học cho mỗi môn họcselect mh.MaMH, mh.TenMH, count(distinct kq.MaSV) as SoHocSinh
from KetQua kq
join DMMonHoc mh on mh.MaMH = kq.MaMH
group by mh.MaMH, mh.TenMH;
--21. Đưa ra danh sách sinh viên gồm mã sinh viên, họ và tên, ngày sinh, tên khoa học, điểm trung bình
select sv.MaSv, sv.HoSV + ' ' + sv.TenSV as HoTen, sv.NgaySinh, K.TenKhoa, avg(kq.Diem) as DiemTrungBinh
from DSSinhVien sv
join DMKhoa k on k.MaKhoa = sv.MaKhoa
left join KetQua kq on kq.MaSV = sv.MaSV
group by sv.MaSv, sv.HoSV, sv.TenSV, sv.NgaySinh, K.TenKhoa;
/*22.Đưa ra danh sách sinh viên xuất sắc gồm mã sinh viên, họ và tên, ngày sinh, tên khoa học,
điểm trung bình với điểm trunh bình >=9.0*/
select sv.MaSV, sv.HoSV + ' ' + sv.TenSV as HoTen, sv.NgaySinh, k.TenKhoa, avg(kq.Diem) as DiemTrungBinh
from DSSinhVien sv
join DMKhoa k on k.MaKhoa = sv.MaKhoa
left join KetQua kq on kq.MaSV=sv.MaSV
group by sv.MaSV, sv.HoSV, sv.TenSV, sv.NgaySinh, k.TenKhoa
having avg(kq.Diem) >= 9;
/*23.Cho biết thông tin của các sinh viên, gồm: Mã sinh viên,tên sinh viên, Phái, Mã khoa, Điểm
lần 1 môn có mã 01 (nếu có).*/
select sv.MaSV, sv.HoSV + ' ' + sv.TenSV as HoTen, sv.Phai, sv.MaKhoa, kq.Diem as DiemLan1
from DSSinhVien sv
left join KetQua kq on sv.MaSV = kq.MaSV
and kq.LanThi = 1 and kq.MaMH = '01';
/*24.Thêm trường TinhTrang (tình trạng) vào bảng kết quả. Cập nhật dữ liệu cho trường này biết
rằng nếu điểm trung bình (điểm trung bình được tính như câu 2.3) <4 ghi 0, từ 4 đến dưới
5.5 ghi 1, còn lại không ghi (null).*/
alter table KetQua add TinhTrang int;
update KetQua
set TinhTrang = 
    case 
        when (select avg(Diem) from KetQua kq where kq.MaSV = KetQua.MaSV) < 4 then 0
        when (select AVG(Diem) from KetQua kq where kq.MaSV = KetQua.MaSV) >= 4 
             AND (select AVG(Diem) from KetQua kq where kq.MaSV = KetQua.MaSV) < 5.5 then 1
        else NULL
    end;
select * from KetQua
--25.Xoá tất cả những sinh viên chưa dự thi môn nào.
delete from DSSinhVien
where MaSV not in (select distinct MaSV from KetQua);
--26. Xóa những môn mà không có sinh viên học.
delete from DMMonHoc
where MaMH NOT IN (select distinct MaMH from KetQua);
--27.Thêm vào bảng khoa cột Siso, cập nhật sỉ số vào khoa từ dữ liệu sinh viên.
alter table DMKhoa add SiSo int;
update DMKhoa
set SiSo = (
	select count(MaSV)
	from DSSinhVien
	where DSSinhVien.MaKhoa = DMKhoa.MaKhoa)
select * from DMKhoa
select * from DSSinhVien;
--28.Tăng thêm 1 điểm cho các sinh viên vớt lần 2. Nhưng chỉ tăng tối đa là 5 điểm.
update KetQua
set Diem = case 
              when Diem + 1 > 5 then 5 
              else Diem + 1 
           end
where LanThi = 2;
--29.Tăng học bổng lên 100000 cho những sinh viên có điểm trung bình là 6.5 trở lên.
update DSSinhVien
set HocBong = HocBong + 100000
where MaSV IN (
	select MaSV
	from KetQua
	group by MaSV
	having avg(Diem) >= 6.5
)
select * from DSSinhVien;
--30.Thiết lập học bổng bằng 0 cho những sinh viên thi hai môn rớt ở lần 1.
update DSSinhVien
set HocBong = 0
where MaSV IN (
	select MaSV
	from KetQua
	where LanThi = 1 AND Diem < 4.0
	group by MaSV
	having count(MaMH) >= 2
)
select * from DSSinhVien;