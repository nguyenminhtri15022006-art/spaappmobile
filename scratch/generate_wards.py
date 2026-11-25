# -*- coding: utf-8 -*-
import sys

wards_data = [
    # 1. Thành phố Hà Nội
    ('VN-HN', 'Quận Hoàn Kiếm', 'VN-HN-HG', 'Phường Hàng Gai', ['Pho Co', 'Hang Gai', 'Hoan Kiem']),
    ('VN-HN', 'Quận Hoàn Kiếm', 'VN-HN-CD', 'Phường Cửa Đông', ['Cua Dong', 'Hoan Kiem']),
    ('VN-HN', 'Quận Hoàn Kiếm', 'VN-HN-TT', 'Phường Tràng Tiền', ['Trang Tien', 'Nha Hat Lon', 'Ho Guom']),
    ('VN-HN', 'Quận Ba Đình', 'VN-HN-TV', 'Phường Trúc Bạch', ['Truc Bach', 'Tran Vu', 'Ho Tay', 'Ba Dinh']),
    ('VN-HN', 'Quận Ba Đình', 'VN-HN-KM', 'Phường Kim Mã', ['Kim Ma', 'Lotte Lieu Giai']),
    ('VN-HN', 'Quận Cầu Giấy', 'VN-HN-CG', 'Phường Dịch Vọng Hậu', ['Cau Giay', 'Dich Vong Hau']),
    ('VN-HN', 'Quận Cầu Giấy', 'VN-HN-TH', 'Phường Trung Hòa', ['Trung Hoa Nhan Chinh', 'Tran Duy Hung']),
    ('VN-HN', 'Quận Đống Đa', 'VN-HN-LH', 'Phường Láng Hạ', ['Lang Ha', 'Dong Da']),
    ('VN-HN', 'Quận Đống Đa', 'VN-HN-OCD', 'Phường Ô Chợ Dừa', ['O Cho Dua', 'Xap Dan']),
    ('VN-HN', 'Quận Hai Bà Trưng', 'VN-HN-BK', 'Phường Bách Khoa', ['Bach Khoa', 'Dai Co Viet']),
    ('VN-HN', 'Quận Thanh Xuân', 'VN-HN-TX', 'Phường Thanh Xuân Trung', ['Thanh Xuan', 'Nguyen Trai']),
    ('VN-HN', 'Quận Tây Hồ', 'VN-HN-QA', 'Phường Quảng An', ['Quang An', 'Ho Tay', 'Phu Tay Ho']),
    ('VN-HN', 'Quận Hoàng Mai', 'VN-HN-HM', 'Phường Hoàng Liệt', ['Hoang Mai', 'Linh Dam']),
    ('VN-HN', 'Quận Nam Từ Liêm', 'VN-HN-MT', 'Phường Mễ Trì', ['Me Tri', 'Keangnam', 'The Manor']),
    ('VN-HN', 'Quận Hà Đông', 'VN-HN-QT', 'Phường Quang Trung', ['Ha Dong', 'Quang Trung Ha Dong']),

    # 2. Thành phố Hồ Chí Minh
    ('VN-SG', 'Quận 1', 'VN-SG-BN', 'Phường Bến Nghé', ['Ben Nghe', 'Trung tam Q1', 'Dong Khoi']),
    ('VN-SG', 'Quận 1', 'VN-SG-BT', 'Phường Bến Thành', ['Ben Thanh', 'Cho Ben Thanh']),
    ('VN-SG', 'Quận 1', 'VN-SG-DK', 'Phường Đa Kao', ['Da Kao', 'Dinh Tien Hoang']),
    ('VN-SG', 'Quận 1', 'VN-SG-TD1', 'Phường Tân Định', ['Tan Dinh', 'Cho Tan Dinh', 'Nha tho Tan Dinh']),
    ('VN-SG', 'Quận 3', 'VN-SG-VTS', 'Phường Võ Thị Sáu', ['Vo Thi Sau', 'Quan 3']),
    ('VN-SG', 'TP. Thủ Đức', 'VN-SG-TD', 'Phường Thảo Điền', ['Quận 2', 'Thao Dien', 'Quan 2', 'Thu Duc']),
    ('VN-SG', 'TP. Thủ Đức', 'VN-SG-LT', 'Phường Linh Tây', ['Quan Thu Duc', 'Linh Tay', 'Thu Duc']),
    ('VN-SG', 'TP. Thủ Đức', 'VN-SG-AP', 'Phường An Phú', ['An Phu', 'Quan 2', 'Cantavil']),
    ('VN-SG', 'Quận 7', 'VN-SG-TP', 'Phường Tân Phong', ['Phu My Hung', 'Tan Phong', 'Quan 7']),
    ('VN-SG', 'Quận 7', 'VN-SG-TPH', 'Phường Tân Phú', ['Tan Phu Quan 7', 'Benh vien FV']),
    ('VN-SG', 'Quận Tân Bình', 'VN-SG-TB2', 'Phường 2', ['Tân Bình', 'Quan Tan Binh', 'San bay Tan Son Nhat']),
    ('VN-SG', 'Quận Bình Thạnh', 'VN-SG-BT1', 'Phường 1', ['Bình Thạnh', 'Binh Thanh', 'Ba Chieu']),
    ('VN-SG', 'Quận Bình Thạnh', 'VN-SG-BT25', 'Phường 25', ['Bình Thạnh', 'Landmark 81', 'Vinhomes']),
    ('VN-SG', 'Quận Phú Nhuận', 'VN-SG-PN7', 'Phường 7', ['Phú Nhuận', 'Phu Nhuan', 'Phan Xich Long']),
    ('VN-SG', 'Quận Gò Vấp', 'VN-SG-GV10', 'Phường 10', ['Gò Vấp', 'Go Vap', 'Quang Trung']),
    ('VN-SG', 'Quận 10', 'VN-SG-Q10', 'Phường 12', ['Quận 10', 'Su Van Hanh', 'Van Hanh Mall']),
    ('VN-SG', 'TP. Thủ Dầu Một (Bình Dương)', 'VN-SG-BD', 'Phường Phú Lợi', ['Bình Dương', 'Thu Dau Mot', 'Binh Duong']),
    ('VN-SG', 'TP. Thuận An (Bình Dương)', 'VN-SG-BD-LT', 'Phường Lái Thiêu', ['Bình Dương', 'Thuận An', 'Lai Thieu', 'Aeon Binh Duong']),
    ('VN-SG', 'TP. Dĩ An (Bình Dương)', 'VN-SG-BD-DA', 'Phường Dĩ An', ['Bình Dương', 'Dĩ An', 'Lang Dai Hoc']),
    ('VN-SG', 'TP. Bến Cát (Bình Dương)', 'VN-SG-BD-BC', 'Phường Mỹ Phước', ['Bình Dương', 'Bến Cát', 'My Phuoc']),
    ('VN-SG', 'TP. Vũng Tàu (Bà Rịa - Vũng Tàu)', 'VN-SG-VT', 'Phường 1', ['Bà Rịa Vũng Tàu', 'Vung Tau', 'Bai Truoc']),
    ('VN-SG', 'TP. Vũng Tàu (Bà Rịa - Vũng Tàu)', 'VN-SG-VT-TT', 'Phường Thắng Tam', ['Bà Rịa Vũng Tàu', 'Vung Tau', 'Bai Sau']),
    ('VN-SG', 'TP. Bà Rịa (Bà Rịa - Vũng Tàu)', 'VN-SG-VT-BR', 'Phường Phước Trung', ['Bà Rịa Vũng Tàu', 'TP Bà Rịa']),

    # 3. Thành phố Đà Nẵng
    ('VN-DN', 'Quận Hải Châu', 'VN-DN-TT', 'Phường Thạch Thang', ['Thach Thang', 'Song Han', 'Đà Nẵng']),
    ('VN-DN', 'Quận Hải Châu', 'VN-DN-HC1', 'Phường Hải Châu 1', ['Hải Châu 1', 'Hai Chau', 'Đà Nẵng']),
    ('VN-DN', 'Quận Sơn Trà', 'VN-DN-AC', 'Phường An Hải Bắc', ['Bien My Khe', 'An Hai Bac', 'Sơn Trà', 'Đà Nẵng']),
    ('VN-DN', 'Quận Thanh Khê', 'VN-DN-TK2', 'Phường Vĩnh Trung', ['Thanh Khê', 'Thanh Khe', 'Vinh Trung', 'Đà Nẵng']),
    ('VN-DN', 'Quận Ngũ Hành Sơn', 'VN-DN-NHS', 'Phường Mỹ An', ['Ngũ Hành Sơn', 'Ngu Hanh Son', 'My An', 'Đà Nẵng']),
    ('VN-DN', 'Quận Cẩm Lệ', 'VN-DN-CL', 'Phường Khuê Trung', ['Cẩm Lệ', 'Cam Le', 'Khue Trung']),
    ('VN-DN', 'Quận Liên Chiểu', 'VN-DN-LC', 'Phường Hòa Khánh Bắc', ['Liên Chiểu', 'Lien Chieu', 'Hoa Khanh']),
    ('VN-DN', 'TP. Hội An (Quảng Nam)', 'VN-DN-HA', 'Phường Minh An', ['Quảng Nam', 'Hội An', 'Hoi An', 'Phố Cổ Hội An', 'Quang Nam']),
    ('VN-DN', 'TP. Hội An (Quảng Nam)', 'VN-DN-HA-CP', 'Phường Cẩm Phô', ['Quảng Nam', 'Hội An', 'Hoi An', 'Cẩm Phô', 'Cam Pho', 'Quang Nam']),
    ('VN-DN', 'TP. Tam Kỳ (Quảng Nam)', 'VN-DN-TK', 'Phường An Mỹ', ['Quảng Nam', 'TP Tam Kỳ', 'Tam Ky', 'An My', 'Quang Nam']),
    ('VN-DN', 'Thị xã Điện Bàn (Quảng Nam)', 'VN-DN-DB', 'Phường Vĩnh Điện', ['Quảng Nam', 'Điện Bàn', 'Dien Ban', 'Vinh Dien', 'Quang Nam']),
    ('VN-DN', 'Huyện Duy Xuyên (Quảng Nam)', 'VN-DN-DX', 'Thị trấn Nam Phước', ['Quảng Nam', 'Duy Xuyên', 'Nam Phuoc', 'Thánh địa Mỹ Sơn', 'My Son', 'Quang Nam']),
    ('VN-DN', 'Huyện Đại Lộc (Quảng Nam)', 'VN-DN-DL', 'Thị trấn Ái Nghĩa', ['Quảng Nam', 'Đại Lộc', 'Dai Loc', 'Ai Nghia']),

    # 4. Thành phố Hải Phòng
    ('VN-HP', 'Quận Hồng Bàng', 'VN-HP-HB', 'Phường Hoàng Văn Thụ', ['Quận Hồng Bàng', 'Hong Bang', 'Hai Phong']),
    ('VN-HP', 'Quận Ngô Quyền', 'VN-HP-NP', 'Phường Lạc Viên', ['Quận Ngô Quyền', 'Ngo Quyen', 'Lac Vien']),
    ('VN-HP', 'Quận Lê Chân', 'VN-HP-LC', 'Phường An Biên', ['Quận Lê Chân', 'Le Chan', 'An Bien']),
    ('VN-HP', 'Quận Đồ Sơn', 'VN-HP-DS', 'Phường Vạn Hương', ['Đồ Sơn', 'Do Son', 'Biển Đồ Sơn', 'Khu du lịch Đồ Sơn']),
    ('VN-HP', 'Huyện Cát Hải', 'VN-HP-CH', 'Thị trấn Cát Bà', ['Cát Bà', 'Cat Ba', 'Quần đảo Cát Bà', 'Vịnh Lan Hạ']),
    ('VN-HP', 'Huyện Thủy Nguyên', 'VN-HP-TN', 'Thị trấn Núi Đèo', ['Thủy Nguyên', 'Thuy Nguyen', 'Nui Deo']),
    ('VN-HP', 'TP. Hải Dương', 'VN-HP-HD', 'Phường Lê Thanh Nghị', ['Hải Dương', 'TP Hải Dương', 'Hai Duong']),

    # 5. Thành phố Cần Thơ
    ('VN-CT', 'Quận Ninh Kiều', 'VN-CT-NK', 'Phường Tân An', ['Quận Ninh Kiều', 'Ben Ninh Kieu', 'Can Tho', 'Ninh Kieu']),
    ('VN-CT', 'Quận Ninh Kiều', 'VN-CT-AK', 'Phường An Khánh', ['Quận Ninh Kiều', 'An Khanh', 'Dai hoc Can Tho']),
    ('VN-CT', 'Quận Cái Răng', 'VN-CT-CR', 'Phường Lê Bình', ['Quận Cái Răng', 'Cho noi Cai Rang', 'Cai Rang', 'Le Binh']),
    ('VN-CT', 'Quận Bình Thủy', 'VN-CT-BT', 'Phường Bình Thủy', ['Bình Thủy', 'Binh Thuy', 'Nhà cổ Bình Thủy']),
    ('VN-CT', 'TP. Vị Thanh (Hậu Giang)', 'VN-CT-HG', 'Phường 1', ['Hậu Giang', 'TP Vị Thanh', 'Vi Thanh', 'Hau Giang']),
    ('VN-CT', 'TP. Sóc Trăng', 'VN-CT-ST', 'Phường 1', ['Sóc Trăng', 'TP Sóc Trăng', 'Soc Trang', 'Chùa Dơi']),

    # 6. Thành phố Huế
    ('VN-HUE', 'Thành phố Huế', 'VN-HUE-VT', 'Phường Vĩnh Ninh', ['Huế', 'Thừa Thiên Huế', 'Vinh Ninh', 'Song Huong']),
    ('VN-HUE', 'Thành phố Huế', 'VN-HUE-PH', 'Phường Phú Hội', ['Huế', 'Phu Hoi', 'Pho Tay Hue']),
    ('VN-HUE', 'Thành phố Huế', 'VN-HUE-TH', 'Phường Thuận Thành', ['Đại Nội', 'Kinh Thanh Hue', 'Thuan Thanh', 'Hoang Thanh Hue']),
    ('VN-HUE', 'Thành phố Huế', 'VN-HUE-HL', 'Phường Hương Long', ['Chùa Thiên Mụ', 'Huong Long', 'Kim Long']),
    ('VN-HUE', 'Thị xã Hương Thủy', 'VN-HUE-HT', 'Phường Phú Bài', ['Hương Thủy', 'Phú Bài', 'Phu Bai', 'San bay Phu Bai']),
    ('VN-HUE', 'Huyện Phú Lộc', 'VN-HUE-PL', 'Thị trấn Lăng Cô', ['Lăng Cô', 'Lang Co', 'Vịnh Lăng Cô', 'Đèo Hải Vân']),

    # 7. Tỉnh Quảng Ninh
    ('VN-QN', 'Thành phố Hạ Long', 'VN-QN-HL', 'Phường Bãi Cháy', ['TP Hạ Long', 'Ha Long', 'Bai Chay', 'Sun World Ha Long']),
    ('VN-QN', 'Thành phố Hạ Long', 'VN-QN-HG', 'Phường Hòn Gai', ['TP Hạ Long', 'Hon Gai', 'Vịnh Hạ Long']),
    ('VN-QN', 'Thành phố Hạ Long', 'VN-QN-TC', 'Phường Tuần Châu', ['Đảo Tuần Châu', 'Tuan Chau']),
    ('VN-QN', 'Thành phố Cẩm Phả', 'VN-QN-CP', 'Phường Cẩm Trung', ['TP Cẩm Phả', 'Cam Pha', 'Cam Trung']),
    ('VN-QN', 'Thành phố Uông Bí', 'VN-QN-UB', 'Phường Yên Thanh', ['TP Uông Bí', 'Uong Bi', 'Chùa Ba Vàng', 'Yên Tử']),
    ('VN-QN', 'Thành phố Móng Cái', 'VN-QN-MC', 'Phường Trần Phú', ['TP Móng Cái', 'Mong Cai', 'Cửa khẩu Móng Cái', 'Trà Cổ']),
    ('VN-QN', 'Huyện Vân Đồn', 'VN-QN-VD', 'Thị trấn Cái Rồng', ['Vân Đồn', 'Van Don', 'San bay Van Don', 'Cai Rong']),

    # 8. Tỉnh Cao Bằng
    ('VN-CB', 'Thành phố Cao Bằng', 'VN-CB-HG', 'Phường Hợp Giang', ['TP Cao Bằng', 'Cao Bang', 'Hop Giang']),
    ('VN-CB', 'Thành phố Cao Bằng', 'VN-CB-SB', 'Phường Sông Bằng', ['TP Cao Bằng', 'Song Bang']),
    ('VN-CB', 'Huyện Trùng Khánh', 'VN-CB-TK', 'Thị trấn Trùng Khánh', ['Trùng Khánh', 'Thác Bản Giốc', 'Ban Gioc', 'Động Ngườm Ngao']),

    # 9. Tỉnh Lạng Sơn
    ('VN-LS', 'Thành phố Lạng Sơn', 'VN-LS-VL', 'Phường Vĩnh Trại', ['TP Lạng Sơn', 'Lang Son', 'Vinh Trai']),
    ('VN-LS', 'Thành phố Lạng Sơn', 'VN-LS-TT', 'Phường Tam Thanh', ['TP Lạng Sơn', 'Tam Thanh', 'Chùa Tam Thanh', 'Động Nhị Thanh']),
    ('VN-LS', 'Huyện Cao Lộc', 'VN-LS-DD', 'Thị trấn Đồng Đăng', ['Đồng Đăng', 'Dong Dang', 'Cửa khẩu Quốc tế Hữu Nghị']),

    # 10. Tỉnh Lai Châu
    ('VN-LC', 'Thành phố Lai Châu', 'VN-LC-DL', 'Phường Đoàn Kết', ['TP Lai Châu', 'Lai Chau', 'Doan Ket']),
    ('VN-LC', 'Thành phố Lai Châu', 'VN-LC-TP', 'Phường Tân Phong', ['TP Lai Châu', 'Tan Phong']),

    # 11. Tỉnh Điện Biên
    ('VN-DB', 'Thành phố Điện Biên Phủ', 'VN-DB-MC', 'Phường Mường Thanh', ['TP Điện Biên Phủ', 'Dien Bien', 'Muong Thanh', 'Hầm Đờ Cát']),
    ('VN-DB', 'Thành phố Điện Biên Phủ', 'VN-DB-TB', 'Phường Thanh Bình', ['TP Điện Biên Phủ', 'Thanh Binh']),
    ('VN-DB', 'Thị xã Mường Lay', 'VN-DB-ML', 'Phường Sông Đà', ['Mường Lay', 'Muong Lay']),

    # 12. Tỉnh Sơn La
    ('VN-SL', 'Thành phố Sơn La', 'VN-SL-QL', 'Phường Quyết Thắng', ['TP Sơn La', 'Son La', 'Quyet Thang']),
    ('VN-SL', 'Huyện Mộc Châu', 'VN-SL-MC', 'Thị trấn Mộc Châu', ['Mộc Châu', 'Moc Chau', 'Cao nguyên Mộc Châu', 'Đồi chè Mộc Châu']),
    ('VN-SL', 'Huyện Mộc Châu', 'VN-SL-NT', 'Thị trấn Nông trường Mộc Châu', ['Nông trường Mộc Châu', 'Thác Dải Yếm']),

    # 13. Tỉnh Thanh Hóa
    ('VN-TH', 'Thành phố Thanh Hóa', 'VN-TH-LB', 'Phường Lam Sơn', ['TP Thanh Hóa', 'Thanh Hoa', 'Lam Son']),
    ('VN-TH', 'Thành phố Thanh Hóa', 'VN-TH-BD', 'Phường Ba Đình', ['TP Thanh Hóa', 'Ba Dinh Thanh Hoa']),
    ('VN-TH', 'Thành phố Sầm Sơn', 'VN-TH-SS', 'Phường Trường Sơn', ['TP Sầm Sơn', 'Sam Son', 'Biển Sầm Sơn', 'Hòn Trống Mái']),
    ('VN-TH', 'Thành phố Sầm Sơn', 'VN-TH-BS', 'Phường Bắc Sơn', ['TP Sầm Sơn', 'Bac Son']),
    ('VN-TH', 'Thị xã Bỉm Sơn', 'VN-TH-BS2', 'Phường Ba Đình', ['Bỉm Sơn', 'Bim Son']),
    ('VN-TH', 'Thị xã Nghi Sơn', 'VN-TH-NS', 'Phường Hải Hòa', ['Nghi Sơn', 'Nghi Son', 'Cảng Nghi Sơn']),
    ('VN-TH', 'Huyện Hoằng Hóa', 'VN-TH-HH', 'Thị trấn Bút Sơn', ['Hoằng Hóa', 'Hoang Hoa', 'Biển Hải Tiến', 'Hai Tien']),

    # 14. Tỉnh Nghệ An
    ('VN-22', 'Thành phố Vinh', 'VN-22-TT', 'Phường Trường Thi', ['TP Vinh', 'Thành phố Vinh', 'Truong Thi', 'Quảng trường Hồ Chí Minh']),
    ('VN-22', 'Thành phố Vinh', 'VN-22-QT', 'Phường Quang Trung', ['TP Vinh', 'Thành phố Vinh', 'Quang Trung']),
    ('VN-22', 'Thành phố Vinh', 'VN-22-HD', 'Phường Hưng Dũng', ['TP Vinh', 'Thành phố Vinh', 'Hung Dung']),
    ('VN-22', 'Thành phố Vinh', 'VN-22-LL', 'Phường Lê Lợi', ['TP Vinh', 'Thành phố Vinh', 'Le Loi']),
    ('VN-22', 'Thị xã Cửa Lò', 'VN-22-NH', 'Phường Nghi Hương', ['Thị xã Cửa Lò', 'Thi xa Cua Lo', 'Cua Lo', 'Bien Cua Lo', 'Nghi Huong']),
    ('VN-22', 'Thị xã Cửa Lò', 'VN-22-TT2', 'Phường Thu Thủy', ['Cửa Lò', 'Thu Thuy']),
    ('VN-22', 'Huyện Nam Đàn', 'VN-22-ND', 'Thị trấn Nam Đàn', ['Nam Đàn', 'Nam Dan', 'Quê Bác', 'Kim Liên', 'Làng Sen']),
    ('VN-22', 'Huyện Diễn Châu', 'VN-22-DC', 'Thị trấn Diễn Châu', ['Diễn Châu', 'Dien Chau', 'Biển Diễn Thành']),

    # 15. Tỉnh Hà Tĩnh
    ('VN-HT', 'Thành phố Hà Tĩnh', 'VN-HT-NB', 'Phường Nam Hà', ['TP Hà Tĩnh', 'Ha Tinh', 'Nam Ha']),
    ('VN-HT', 'Thành phố Hà Tĩnh', 'VN-HT-BH', 'Phường Bắc Hà', ['TP Hà Tĩnh', 'Bac Ha']),
    ('VN-HT', 'Thị xã Hồng Lĩnh', 'VN-HT-HL', 'Phường Bắc Hồng', ['Hồng Lĩnh', 'Hong Linh', 'Núi Hồng Lĩnh']),
    ('VN-HT', 'Huyện Nghi Xuân', 'VN-HT-NX', 'Thị trấn Tiên Điền', ['Nghi Xuân', 'Khu lưu niệm Đại thi hào Nguyễn Du']),

    # 16. Tỉnh Tuyên Quang
    ('VN-TQ', 'Thành phố Tuyên Quang', 'VN-TQ-TB', 'Phường Tân Quang', ['TP Tuyên Quang', 'Tuyen Quang', 'Tan Quang']),
    ('VN-TQ', 'Thành phố Tuyên Quang', 'VN-TQ-PT', 'Phường Phan Thiết', ['TP Tuyên Quang', 'Phan Thiet Tuyen Quang']),
    ('VN-TQ', 'Thành phố Hà Giang', 'VN-TQ-HG', 'Phường Trần Phú', ['Hà Giang', 'TP Hà Giang', 'Ha Giang', 'Tran Phu']),
    ('VN-TQ', 'Huyện Đồng Văn (Hà Giang)', 'VN-TQ-DV', 'Thị trấn Đồng Văn', ['Hà Giang', 'Đồng Văn', 'Dong Van', 'Cao nguyên đá Đồng Văn', 'Cột cờ Lũng Cú']),

    # 17. Tỉnh Lào Cai
    ('VN-LCA', 'Thành phố Lào Cai', 'VN-LCA-CC', 'Phường Cốc Lếu', ['TP Lào Cai', 'Lao Cai', 'Coc Leu', 'Cửa khẩu Lào Cai']),
    ('VN-LCA', 'Thành phố Lào Cai', 'VN-LCA-KT', 'Phường Kim Tân', ['TP Lào Cai', 'Kim Tan']),
    ('VN-LCA', 'Thị xã Sa Pa', 'VN-LCA-SP', 'Phường Sa Pa', ['Thị xã Sa Pa', 'Sapa', 'Sa Pa', 'Fansipan', 'Nhà thờ đá Sapa']),
    ('VN-LCA', 'Thị xã Sa Pa', 'VN-LCA-HR', 'Phường Hàm Rồng', ['Sa Pa', 'Núi Hàm Rồng']),
    ('VN-LCA', 'TP. Yên Bái', 'VN-LCA-YB', 'Phường Đồng Tâm', ['Yên Bái', 'TP Yên Bái', 'Yen Bai', 'Dong Tam']),
    ('VN-LCA', 'Huyện Mù Cang Chải (Yên Bái)', 'VN-LCA-MCC', 'Thị trấn Mù Cang Chải', ['Mù Cang Chải', 'Mu Cang Chai', 'Ruộng bậc thang']),

    # 18. Tỉnh Thái Nguyên
    ('VN-TN', 'Thành phố Thái Nguyên', 'VN-TN-PD', 'Phường Phan Đình Phùng', ['TP Thái Nguyên', 'Thai Nguyen', 'Phan Dinh Phung']),
    ('VN-TN', 'Thành phố Thái Nguyên', 'VN-TN-QT', 'Phường Quang Trung', ['TP Thái Nguyên', 'Quang Trung Thai Nguyen']),
    ('VN-TN', 'Thành phố Phổ Yên', 'VN-TN-PY', 'Phường Ba Hàng', ['Phổ Yên', 'Pho Yen', 'Samsung Thai Nguyen']),
    ('VN-TN', 'TP. Bắc Kạn', 'VN-TN-BK', 'Phường Phùng Chí Kiên', ['Bắc Kạn', 'TP Bắc Kạn', 'Bac Kan', 'Hồ Ba Bể']),

    # 19. Tỉnh Phú Thọ
    ('VN-PT', 'Thành phố Việt Trì', 'VN-PT-VT', 'Phường Gia Cẩm', ['TP Việt Trì', 'Viet Tri', 'Phu Tho', 'Gia Cam']),
    ('VN-PT', 'Thành phố Việt Trì', 'VN-PT-TC', 'Phường Tiên Cát', ['TP Việt Trì', 'Khu di tích Đền Hùng', 'Den Hung']),
    ('VN-PT', 'Thị xã Phú Thọ', 'VN-PT-TX', 'Phường Âu Cơ', ['Thị xã Phú Thọ', 'Au Co']),
    ('VN-PT', 'TP. Vĩnh Yên (Vĩnh Phúc)', 'VN-PT-VP', 'Phường Khai Quang', ['Vĩnh Phúc', 'TP Vĩnh Yên', 'Vinh Yen', 'Vinh Phuc']),
    ('VN-PT', 'TP. Phúc Yên (Vĩnh Phúc)', 'VN-PT-PY', 'Phường Trưng Nhị', ['Phúc Yên', 'Flamingo Đại Lải', 'Dai Lai']),
    ('VN-PT', 'TP. Hòa Bình', 'VN-PT-HB', 'Phường Phương Lâm', ['Hòa Bình', 'TP Hòa Bình', 'Hoa Binh', 'Thủy điện Hòa Bình']),

    # 20. Tỉnh Bắc Ninh
    ('VN-BN', 'Thành phố Bắc Ninh', 'VN-BN-ST', 'Phường Suối Hoa', ['TP Bắc Ninh', 'Bac Ninh', 'Suoi Hoa']),
    ('VN-BN', 'Thành phố Bắc Ninh', 'VN-BN-TA', 'Phường Tiền An', ['TP Bắc Ninh', 'Tien An']),
    ('VN-BN', 'Thị xã Từ Sơn', 'VN-BN-TS', 'Phường Đông Ngàn', ['Từ Sơn', 'Tu Son', 'Đền Đô', 'Làng tranh Đông Hồ']),
    ('VN-BN', 'TP. Bắc Giang', 'VN-BN-BG', 'Phường Ngô Quyền', ['Bắc Giang', 'TP Bắc Giang', 'Bac Giang', 'Ngo Quyen']),
    ('VN-BN', 'Thị xã Việt Yên (Bắc Giang)', 'VN-BN-VY', 'Phường Bích Động', ['Việt Yên', 'Viet Yen', 'KCN Quang Chau']),

    # 21. Tỉnh Hưng Yên
    ('VN-HY', 'Thành phố Hưng Yên', 'VN-HY-HC', 'Phường Hiến Nam', ['TP Hưng Yên', 'Hung Yen', 'Pho Hien', 'Hien Nam']),
    ('VN-HY', 'Huyện Văn Giang', 'VN-HY-VG', 'Xã Xuân Quan', ['Văn Giang', 'Khu đô thị Ecopark', 'Ecopark']),
    ('VN-HY', 'TP. Thái Bình', 'VN-HY-TB', 'Phường Lê Hồng Phong', ['Thái Bình', 'TP Thái Bình', 'Thai Binh', 'Le Hong Phong']),
    ('VN-HY', 'TP. Thái Bình', 'VN-HY-BX', 'Phường Bồ Xuyên', ['Thái Bình', 'Bo Xuyen']),

    # 22. Tỉnh Ninh Bình
    ('VN-NB', 'Thành phố Ninh Bình', 'VN-NB-VT', 'Phường Vân Giang', ['TP Ninh Bình', 'Ninh Binh', 'Van Giang']),
    ('VN-NB', 'Thành phố Ninh Bình', 'VN-NB-NT', 'Phường Nam Thành', ['Ninh Bình', 'Quần thể danh thắng Tràng An', 'Chùa Bái Đính']),
    ('VN-NB', 'Thành phố Tam Điệp', 'VN-NB-TD', 'Phường Bắc Sơn', ['Tam Điệp', 'Tam Diep']),
    ('VN-NB', 'TP. Nam Định', 'VN-NB-ND', 'Phường Vị Xuyên', ['Nam Định', 'TP Nam Định', 'Nam Dinh', 'Vi Xuyen', 'Đền Trần']),
    ('VN-NB', 'TP. Phủ Lý (Hà Nam)', 'VN-NB-HN', 'Phường Minh Khai', ['Hà Nam', 'TP Phủ Lý', 'Phu Ly', 'Ha Nam', 'Chùa Tam Chúc']),

    # 23. Tỉnh Quảng Trị (Bao gồm Quảng Bình)
    ('VN-QT', 'TP. Đồng Hới (Quảng Bình)', 'VN-QT-QB', 'Phường Đồng Mỹ', ['Quảng Bình', 'TP Đồng Hới', 'Dong Hoi', 'Quang Binh', 'Đồng Mỹ']),
    ('VN-QT', 'TP. Đồng Hới (Quảng Bình)', 'VN-QT-QB-HP', 'Phường Hải Thành', ['Quảng Bình', 'TP Đồng Hới', 'Dong Hoi', 'Hải Thành', 'Biển Nhật Lệ']),
    ('VN-QT', 'Huyện Bố Trạch (Quảng Bình)', 'VN-QT-QB-PN', 'Thị trấn Phong Nha', ['Quảng Bình', 'Bố Trạch', 'Bo Trach', 'Phong Nha', 'Vườn quốc gia Phong Nha Kẻ Bàng']),
    ('VN-QT', 'Thị xã Ba Đồn (Quảng Bình)', 'VN-QT-QB-BD', 'Phường Ba Đồn', ['Quảng Bình', 'Thị xã Ba Đồn', 'Ba Don', 'Quang Binh']),
    ('VN-QT', 'Huyện Lệ Thủy (Quảng Bình)', 'VN-QT-QB-LT', 'Thị trấn Kiến Giang', ['Quảng Bình', 'Lệ Thủy', 'Le Thuy', 'Kien Giang', 'Quê hương Đại tướng Võ Nguyên Giáp']),
    ('VN-QT', 'TP. Đông Hà (Quảng Trị)', 'VN-QT-DH', 'Phường 1', ['TP Đông Hà', 'Dong Ha', 'Quang Tri', 'Quảng Trị']),
    ('VN-QT', 'TP. Đông Hà (Quảng Trị)', 'VN-QT-DH-P2', 'Phường 2', ['TP Đông Hà', 'Dong Ha', 'Quang Tri', 'Quảng Trị']),
    ('VN-QT', 'Thị xã Quảng Trị', 'VN-QT-TX', 'Phường 1', ['Thị xã Quảng Trị', 'Thành cổ Quảng Trị', 'Quang Tri']),
    ('VN-QT', 'Huyện Gio Linh (Quảng Trị)', 'VN-QT-GL', 'Thị trấn Gio Linh', ['Gio Linh', 'Cửa Việt', 'Quang Tri']),
    ('VN-QT', 'Huyện Hướng Hóa (Quảng Trị)', 'VN-QT-HH', 'Thị trấn Khe Sanh', ['Khe Sanh', 'Hướng Hóa', 'Huong Hoa', 'Lao Bảo']),

    # 24. Tỉnh Quảng Ngãi
    ('VN-QNG', 'Thành phố Quảng Ngãi', 'VN-QNG-QN', 'Phường Trần Phú', ['TP Quảng Ngãi', 'Quang Ngai', 'Tran Phu']),
    ('VN-QNG', 'Thành phố Quảng Ngãi', 'VN-QNG-LH', 'Phường Lê Hồng Phong', ['TP Quảng Ngãi', 'Le Hong Phong']),
    ('VN-QNG', 'Huyện Lý Sơn', 'VN-QNG-LS', 'Xã An Vĩnh', ['Đảo Lý Sơn', 'Ly Son', 'Tỏi Lý Sơn']),
    ('VN-QNG', 'TP. Kon Tum', 'VN-QNG-KT', 'Phường Quyết Thắng', ['Kon Tum', 'TP Kon Tum', 'Quyet Thang', 'Nhà thờ gỗ Kon Tum']),
    ('VN-QNG', 'Huyện Kon Plông (Kon Tum)', 'VN-QNG-MD', 'Thị trấn Măng Đen', ['Măng Đen', 'Mang Den', 'Đà Lạt thứ hai']),

    # 25. Tỉnh Gia Lai
    ('VN-GL', 'Thành phố Pleiku', 'VN-GL-PK', 'Phường Diên Hồng', ['TP Pleiku', 'Pleiku', 'Gia Lai', 'Biển Hồ T\'Nưng']),
    ('VN-GL', 'Thành phố Pleiku', 'VN-GL-HL', 'Phường Hoa Lư', ['TP Pleiku', 'Hoa Lu Pleiku']),
    ('VN-GL', 'Thị xã An Khê', 'VN-GL-AK', 'Phường Tây Sơn', ['An Khê', 'An Khe', 'Tây Sơn']),
    ('VN-GL', 'TP. Quy Nhơn (Bình Định)', 'VN-GL-BD', 'Phường Lê Lợi', ['Bình Định', 'TP Quy Nhơn', 'Quy Nhon', 'Binh Dinh', 'Eo Gió', 'Kỳ Co']),
    ('VN-GL', 'TP. Quy Nhơn (Bình Định)', 'VN-GL-GR', 'Phường Ghềnh Ráng', ['Ghềnh Ráng Tiên Sa', 'Hàn Mặc Tử', 'Quy Nhơn']),
    ('VN-GL', 'Thị xã An Nhơn (Bình Định)', 'VN-GL-AN', 'Phường Bình Định', ['An Nhơn', 'An Nhon', 'Thành Hoàng Đế']),

    # 26. Tỉnh Đắk Lắk
    ('VN-DL', 'Thành phố Buôn Ma Thuột', 'VN-DL-BM', 'Phường Thắng Lợi', ['TP Buôn Ma Thuột', 'Buon Ma Thuot', 'BMT', 'Dak Lak', 'Thủ phủ cà phê']),
    ('VN-DL', 'Thành phố Buôn Ma Thuột', 'VN-DL-TL', 'Phường Tân Lợi', ['TP Buôn Ma Thuột', 'Tan Loi']),
    ('VN-DL', 'Thị xã Buôn Hồ', 'VN-DL-BH', 'Phường An Lạc', ['Buôn Hồ', 'Buon Ho']),
    ('VN-DL', 'TP. Tuy Hòa (Phú Yên)', 'VN-DL-PY', 'Phường 1', ['Phú Yên', 'TP Tuy Hòa', 'Tuy Hoa', 'Phu Yen', 'Tháp Nhạn', 'Gành Đá Đĩa']),
    ('VN-DL', 'TP. Tuy Hòa (Phú Yên)', 'VN-DL-PY7', 'Phường 7', ['Tuy Hòa', 'Biển Tuy Hòa']),
    ('VN-DL', 'Thị xã Sông Cầu (Phú Yên)', 'VN-DL-SC', 'Phường Xuân Đài', ['Sông Cầu', 'Song Cau', 'Vịnh Xuân Đài']),

    # 27. Tỉnh Khánh Hòa
    ('VN-KH', 'Thành phố Nha Trang', 'VN-KH-NT', 'Phường Lộc Thọ', ['TP Nha Trang', 'Nha Trang', 'Loc Tho', 'Bien Nha Trang', 'Trần Phú Nha Trang']),
    ('VN-KH', 'Thành phố Nha Trang', 'VN-KH-PH', 'Phường Phước Hải', ['TP Nha Trang', 'Phuoc Hai']),
    ('VN-KH', 'Thành phố Nha Trang', 'VN-KH-VH', 'Phường Vĩnh Hải', ['TP Nha Trang', 'Vinh Hai', 'Hòn Chồng']),
    ('VN-KH', 'Thành phố Cam Ranh', 'VN-KH-CR', 'Phường Cam Linh', ['Cam Ranh', 'Vịnh Cam Ranh', 'San bay Cam Ranh']),
    ('VN-KH', 'Thị xã Ninh Hòa', 'VN-KH-NH', 'Phường Ninh Hiệp', ['Ninh Hòa', 'Ninh Hoa', 'Dốc Lết']),
    ('VN-KH', 'TP. Phan Rang - Tháp Chàm (Ninh Thuận)', 'VN-KH-PR', 'Phường Thanh Sơn', ['Ninh Thuận', 'TP Phan Rang - Tháp Chàm', 'Phan Rang', 'Tháp Chàm Po Klong Garai']),
    ('VN-KH', 'TP. Phan Rang - Tháp Chàm (Ninh Thuận)', 'VN-KH-KD', 'Phường Kinh Dinh', ['Phan Rang', 'Kinh Dinh']),

    # 28. Tỉnh Lâm Đồng
    ('VN-LD', 'Thành phố Đà Lạt', 'VN-LD-DL', 'Phường 1', ['TP Đà Lạt', 'Da Lat', 'Dalat', 'Hồ Xuân Hương', 'Lam Dong', 'Chợ Đà Lạt']),
    ('VN-LD', 'Thành phố Đà Lạt', 'VN-LD-DL2', 'Phường 2', ['TP Đà Lạt', 'Phan Dinh Phung Da Lat']),
    ('VN-LD', 'Thành phố Đà Lạt', 'VN-LD-DL8', 'Phường 8', ['Đà Lạt', 'Thung Lũng Tình Yêu', 'Đồi Mộng Mơ']),
    ('VN-LD', 'Thành phố Bảo Lộc', 'VN-LD-BL', 'Phường 1', ['Bảo Lộc', 'Bao Loc', 'Thác Dambri', 'Trà B\'Lao']),
    ('VN-LD', 'Huyện Đức Trọng', 'VN-LD-DT', 'Thị trấn Liên Nghĩa', ['Đức Trọng', 'Duc Trong', 'San bay Lien Khuong']),
    ('VN-LD', 'TP. Phan Thiết (Bình Thuận)', 'VN-LD-BT', 'Phường Mũi Né', ['Bình Thuận', 'TP Phan Thiết', 'Phan Thiet', 'Mũi Né', 'Mui Ne', 'Đồi cát bay']),
    ('VN-LD', 'TP. Phan Thiết (Bình Thuận)', 'VN-LD-HT', 'Phường Hàm Tiến', ['Phan Thiết', 'Ham Tien', 'Resort Mũi Né']),
    ('VN-LD', 'TP. Gia Nghĩa (Đắk Nông)', 'VN-LD-DN', 'Phường Nghĩa Đức', ['Đắk Nông', 'TP Gia Nghĩa', 'Gia Nghia', 'Dak Nong', 'Hồ Tà Đùng']),

    # 29. Tỉnh Đồng Nai (Đã có đầy đủ chi tiết)
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-BH', 'Phường Trung Dũng', ['Bien Hoa', 'Trung Dung']),
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-LH', 'Xã Long Hưng', ['Bien Hoa', 'Long Hung', 'Aqua City']),
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-BH-QT', 'Phường Quyết Thắng', ['Bien Hoa', 'Quyet Thang', 'Ga Bien Hoa']),
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-BH-TN', 'Phường Thống Nhất', ['Bien Hoa', 'Thong Nhat', 'Duong Vo Thi Sau']),
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-BH-TP', 'Phường Tân Phong', ['Bien Hoa', 'Tan Phong']),
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-BH-TD', 'Phường Trảng Dài', ['Bien Hoa', 'Trang Dai']),
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-BH-TH', 'Phường Tam Hiệp', ['Bien Hoa', 'Tam Hiep']),
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-BH-TM', 'Phường Tân Mai', ['Bien Hoa', 'Tan Mai']),
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-BH-HN', 'Phường Hố Nai', ['Bien Hoa', 'Ho Nai']),
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-BH-BL', 'Phường Bửu Long', ['Bien Hoa', 'Buu Long', 'Khu du lich Buu Long']),
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-BH-HA', 'Phường Hóa An', ['Bien Hoa', 'Hoa An']),
    ('VN-39', 'Thành phố Biên Hòa', 'VN-39-BH-AB', 'Phường An Bình', ['Bien Hoa', 'An Binh', 'KCN Bien Hoa 1']),
    ('VN-39', 'Thành phố Long Khánh', 'VN-39-LK-XA', 'Phường Xuân An', ['TP Long Khanh', 'Long Khanh', 'Xuan An']),
    ('VN-39', 'Thành phố Long Khánh', 'VN-39-LK-XB', 'Phường Xuân Bình', ['TP Long Khanh', 'Long Khanh', 'Xuan Binh']),
    ('VN-39', 'Thành phố Long Khánh', 'VN-39-LK-XH', 'Phường Xuân Hòa', ['TP Long Khanh', 'Long Khanh', 'Xuan Hoa']),
    ('VN-39', 'Thành phố Long Khánh', 'VN-39-LK-PB', 'Phường Phú Bình', ['TP Long Khanh', 'Long Khanh', 'Phu Binh']),
    ('VN-39', 'Thành phố Long Khánh', 'VN-39-LK-ST', 'Phường Suối Tre', ['TP Long Khanh', 'Long Khanh', 'Suoi Tre']),
    ('VN-39', 'Huyện Long Thành', 'VN-39-LT-TT', 'Thị trấn Long Thành', ['Long Thanh', 'Thi tran Long Thanh']),
    ('VN-39', 'Huyện Long Thành', 'VN-39-LT-BS', 'Xã Bình Sơn', ['Long Thanh', 'Binh Son', 'San bay Quoc te Long Thanh', 'San bay Long Thanh']),
    ('VN-39', 'Huyện Long Thành', 'VN-39-LT-AP', 'Xã An Phước', ['Long Thanh', 'An Phuoc']),
    ('VN-39', 'Huyện Long Thành', 'VN-39-LT-LA', 'Xã Lộc An', ['Long Thanh', 'Loc An']),
    ('VN-39', 'Huyện Long Thành', 'VN-39-LT-PT', 'Xã Phước Thái', ['Long Thanh', 'Phuoc Thai']),
    ('VN-39', 'Huyện Nhơn Trạch', 'VN-39-NT-HP', 'Thị trấn Hiệp Phước', ['Nhon Trach', 'Hiep Phuoc']),
    ('VN-39', 'Huyện Nhơn Trạch', 'VN-39-NT-PH', 'Xã Phú Hội', ['Nhon Trach', 'Phu Hoi']),
    ('VN-39', 'Huyện Nhơn Trạch', 'VN-39-NT-PT', 'Xã Phước Thiền', ['Nhon Trach', 'Phuoc Thien']),
    ('VN-39', 'Huyện Nhơn Trạch', 'VN-39-NT-DP', 'Xã Đại Phước', ['Nhon Trach', 'Dai Phuoc', 'Dao SwanBay']),
    ('VN-39', 'Huyện Trảng Bom', 'VN-39-TB-TT', 'Thị trấn Trảng Bom', ['Trang Bom', 'Thi tran Trang Bom']),
    ('VN-39', 'Huyện Trảng Bom', 'VN-39-TB-HN', 'Xã Hố Nai 3', ['Trang Bom', 'Ho Nai 3']),
    ('VN-39', 'Huyện Trảng Bom', 'VN-39-TB-BS', 'Xã Bắc Sơn', ['Trang Bom', 'Bac Son']),
    ('VN-39', 'Huyện Trảng Bom', 'VN-39-TB-ST', 'Xã Sông Trầu', ['Trang Bom', 'Song Trau']),
    ('VN-39', 'Huyện Vĩnh Cửu', 'VN-39-VC-VA', 'Thị trấn Vĩnh An', ['Vinh Cuu', 'Vinh An', 'Ho Tri An']),
    ('VN-39', 'Huyện Vĩnh Cửu', 'VN-39-VC-TP', 'Xã Thạnh Phú', ['Vinh Cuu', 'Thanh Phu']),
    ('VN-39', 'Huyện Thống Nhất', 'VN-39-TN-DG', 'Thị trấn Dầu Giây', ['Thong Nhat', 'Dau Giay', 'Nga 3 Dau Giay']),
    ('VN-39', 'Huyện Thống Nhất', 'VN-39-TN-GK', 'Xã Gia Kiệm', ['Thong Nhat', 'Gia Kiem']),
    ('VN-39', 'Huyện Xuân Lộc', 'VN-39-XL-GR', 'Thị trấn Gia Ray', ['Xuan Loc', 'Gia Ray', 'Nui Chua Chan']),
    ('VN-39', 'Huyện Xuân Lộc', 'VN-39-XL-SC', 'Xã Suối Cát', ['Xuan Loc', 'Suoi Cat']),
    ('VN-39', 'Huyện Định Quán', 'VN-39-DQ-TT', 'Thị trấn Định Quán', ['Dinh Quan', 'Thi tran Dinh Quan']),
    ('VN-39', 'Huyện Định Quán', 'VN-39-DQ-LN', 'Xã La Ngà', ['Dinh Quan', 'La Nga']),
    ('VN-39', 'Huyện Tân Phú', 'VN-39-TP-TT', 'Thị trấn Tân Phú', ['Tan Phu Dong Nai', 'Thi tran Tan Phu']),
    ('VN-39', 'Huyện Tân Phú', 'VN-39-TP-CT', 'Xã Nam Cát Tiên', ['Tan Phu Dong Nai', 'Nam Cat Tien', 'Vuon Quoc gia Cat Tien']),
    ('VN-39', 'Huyện Cẩm Mỹ', 'VN-39-CM-LG', 'Thị trấn Long Giao', ['Cam My', 'Long Giao']),

    # 30. Tỉnh Tây Ninh
    ('VN-TNI', 'Thành phố Tây Ninh', 'VN-TNI-TN', 'Phường 1', ['TP Tây Ninh', 'Tay Ninh', 'Núi Bà Đen']),
    ('VN-TNI', 'Thành phố Tây Ninh', 'VN-TNI-P3', 'Phường 3', ['TP Tây Ninh', 'Phường 3 Tây Ninh']),
    ('VN-TNI', 'Thị xã Trảng Bàng', 'VN-TNI-TB', 'Phường Trảng Bàng', ['Trảng Bàng', 'Trang Bang', 'Bánh canh Trảng Bàng']),
    ('VN-TNI', 'Thị xã Hòa Thành', 'VN-TNI-HT', 'Phường Long Hoa', ['Hòa Thành', 'Tòa Thánh Tây Ninh', 'Chợ Long Hoa']),
    ('VN-TNI', 'TP. Tân An (Long An)', 'VN-TNI-LA', 'Phường 1', ['Long An', 'TP Tân An', 'Tan An']),
    ('VN-TNI', 'TP. Tân An (Long An)', 'VN-TNI-LA2', 'Phường 2', ['Long An', 'Tân An']),
    ('VN-TNI', 'Huyện Bến Lức (Long An)', 'VN-TNI-BL', 'Thị trấn Bến Lức', ['Bến Lức', 'Ben Luc', 'Long An']),

    # 31. Tỉnh Đồng Tháp
    ('VN-DT', 'Thành phố Cao Lãnh', 'VN-DT-CL', 'Phường 1', ['TP Cao Lãnh', 'Cao Lanh', 'Dong Thap']),
    ('VN-DT', 'Thành phố Cao Lãnh', 'VN-DT-CL2', 'Phường 2', ['TP Cao Lãnh', 'Cao Lanh']),
    ('VN-DT', 'Thành phố Sa Đéc', 'VN-DT-SD', 'Phường 1', ['Sa Đéc', 'Sa Dec', 'Làng hoa Sa Đéc']),
    ('VN-DT', 'Thành phố Hồng Ngự', 'VN-DT-HN', 'Phường An Thạnh', ['Hồng Ngự', 'Hong Ngu']),
    ('VN-DT', 'TP. Mỹ Tho (Tiền Giang)', 'VN-DT-TG', 'Phường 1', ['Tiền Giang', 'TP Mỹ Tho', 'My Tho', 'Tien Giang']),
    ('VN-DT', 'TP. Mỹ Tho (Tiền Giang)', 'VN-DT-TG5', 'Phường 5', ['Mỹ Tho', 'My Tho']),
    ('VN-DT', 'Thị xã Gò Công (Tiền Giang)', 'VN-DT-GC', 'Phường 1', ['Gò Công', 'Go Cong']),

    # 32. Tỉnh Vĩnh Long
    ('VN-VL', 'Thành phố Vĩnh Long', 'VN-VL-VL', 'Phường 1', ['TP Vĩnh Long', 'Vinh Long']),
    ('VN-VL', 'Thành phố Vĩnh Long', 'VN-VL-VL4', 'Phường 4', ['TP Vĩnh Long', 'Phường 4 Vĩnh Long']),
    ('VN-VL', 'Thị xã Bình Minh', 'VN-VL-BM', 'Phường Cái Vồn', ['Bình Minh', 'Binh Minh', 'Cai Von']),
    ('VN-VL', 'TP. Bến Tre', 'VN-VL-BT', 'Phường An Hội', ['Bến Tre', 'TP Bến Tre', 'Ben Tre', 'Xứ dừa']),
    ('VN-VL', 'TP. Bến Tre', 'VN-VL-BT6', 'Phường 6', ['Bến Tre', 'Phường 6 Bến Tre']),
    ('VN-VL', 'TP. Trà Vinh', 'VN-VL-TV', 'Phường 1', ['Trà Vinh', 'TP Trà Vinh', 'Tra Vinh', 'Chùa Hang']),
    ('VN-VL', 'TP. Trà Vinh', 'VN-VL-TV3', 'Phường 3', ['Trà Vinh', 'Ao Bà Om']),

    # 33. Tỉnh An Giang
    ('VN-AG', 'Thành phố Long Xuyên', 'VN-AG-LX', 'Phường Mỹ Bình', ['TP Long Xuyên', 'Long Xuyen', 'An Giang', 'My Binh']),
    ('VN-AG', 'Thành phố Long Xuyên', 'VN-AG-ML', 'Phường Mỹ Long', ['Long Xuyên', 'My Long', 'Chợ nổi Long Xuyên']),
    ('VN-AG', 'Thành phố Châu Đốc', 'VN-AG-CD', 'Phường Châu Phú A', ['TP Châu Đốc', 'Chau Doc', 'Miếu Bà Chúa Xứ', 'Núi Sam']),
    ('VN-AG', 'Thành phố Châu Đốc', 'VN-AG-NS', 'Phường Núi Sam', ['Châu Đốc', 'Nui Sam']),
    ('VN-AG', 'TP. Rạch Giá (Kiên Giang)', 'VN-AG-RG', 'Phường Vĩnh Thanh Vân', ['Kiên Giang', 'TP Rạch Giá', 'Rach Gia', 'Kien Giang']),
    ('VN-AG', 'TP. Phú Quốc (Kiên Giang)', 'VN-AG-PQ', 'Phường Dương Đông', ['Kiên Giang', 'TP Phú Quốc', 'Phú Quốc', 'Phu Quoc', 'Chợ đêm Phú Quốc']),
    ('VN-AG', 'TP. Phú Quốc (Kiên Giang)', 'VN-AG-AT', 'Phường An Thới', ['Phú Quốc', 'An Thoi', 'Cáp treo Hòn Thơm']),
    ('VN-AG', 'TP. Hà Tiên (Kiên Giang)', 'VN-AG-HT', 'Phường Đông Hồ', ['Hà Tiên', 'Ha Tien', 'Thạch Động']),

    # 34. Tỉnh Cà Mau
    ('VN-CM', 'Thành phố Cà Mau', 'VN-CM-CM', 'Phường 5', ['TP Cà Mau', 'Ca Mau']),
    ('VN-CM', 'Thành phố Cà Mau', 'VN-CM-CM1', 'Phường 1', ['TP Cà Mau', 'Phường 1 Cà Mau']),
    ('VN-CM', 'Huyện Ngọc Hiển', 'VN-CM-DM', 'Xã Đất Mũi', ['Mũi Cà Mau', 'Đất Mũi', 'Dat Mui', 'Cột mốc tọa độ Quốc gia']),
    ('VN-CM', 'Huyện Năm Căn', 'VN-CM-NC', 'Thị trấn Năm Căn', ['Năm Căn', 'Nam Can']),
    ('VN-CM', 'TP. Bạc Liêu', 'VN-CM-BL', 'Phường 3', ['Bạc Liêu', 'TP Bạc Liêu', 'Bac Lieu', 'Nhà Công tử Bạc Liêu']),
    ('VN-CM', 'TP. Bạc Liêu', 'VN-CM-BL7', 'Phường 7', ['Bạc Liêu', 'Phường 7 Bạc Liêu']),
    ('VN-CM', 'Thị xã Giá Rai (Bạc Liêu)', 'VN-CM-GR', 'Phường 1', ['Giá Rai', 'Gia Rai', 'Nhà thờ Tắc Sậy', 'Cha Diệp']),
]

lines = ['  static const List<AdministrativeUnit> _wards = [']
for parent_code, district_name, code, name, aliases in wards_data:
    clean_aliases = [a.replace("'", "\\'") for a in aliases]
    aliases_str = ', '.join(f"'{a}'" for a in clean_aliases)
    clean_name = name.replace("'", "\\'")
    clean_district = district_name.replace("'", "\\'")
    lines.append('    AdministrativeUnit(')
    lines.append(f"      code: '{code}',")
    lines.append(f"      name: '{clean_name}',")
    lines.append('      type: AdministrativeType.ward,')
    lines.append(f"      parentCode: '{parent_code}',")
    lines.append(f"      districtName: '{clean_district}',")
    lines.append(f"      aliases: [{aliases_str}],")
    lines.append('    ),')
lines.append('  ];')

wards_code = '\n'.join(lines)

file_path = r'lib/shared/data/mock_administrative_repository.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

start_marker = '  static const List<AdministrativeUnit> _wards = ['
end_marker = '  @override\n  Future<List<AdministrativeUnit>> getProvinces'

start_idx = content.find(start_marker)
end_idx = content.find(end_marker)

if start_idx == -1 or end_idx == -1:
    print(f"Error markers not found: {start_idx}, {end_idx}")
    sys.exit(1)

new_content = content[:start_idx] + wards_code + '\n\n' + content[end_idx:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(new_content)

print(f"Successfully updated mock_administrative_repository.dart with {len(wards_data)} wards across all 34 provinces!")
