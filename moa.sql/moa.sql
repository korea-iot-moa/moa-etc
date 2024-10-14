# 유저
CREATE TABLE Users (
	user_id VARCHAR(255) PRIMARY KEY,
    user_password VARCHAR(255),
    user_birthDate VARCHAR(255),
    user_gender ENUM('male', 'female'),
    user_name VARCHAR(255),
    user_nickname VARCHAR(255),
    securityQuestion ENUM("1","2","3","4","5"),
    securityAnswer VARCHAR(255),
    hobby ENUM('취미', '문화&예술', '스포츠&운동', '푸드&맛집', '자기계발', '여행', '연애', '힐링'),
    profile_image BLOB, 
    region ENUM('부산', '대구', '인천', '광주', '대전', '울산', '서울', '제주', '세종', '경기', '강원', '충북', '충남', '전북', '전남', '경북', '경남')
);

# 그룹
CREATE TABLE Meeting_Group (
	group_id INT PRIMARY KEY,
    creator_id VARCHAR(255),
    group_title VARCHAR(255),
    group_content VARCHAR(255),
    group_type ENUM('단기모임', '정기모임'),
    meeting_type ENUM('온라인', '오프라인'),
    group_address VARCHAR(255),
    group_image BLOB,
    group_supplies VARCHAR(255),
    group_date DATE,
    FOREIGN KEY (creator_id) REFERENCES Users(user_id)
);

# 추천
CREATE TABLE Recommendation (
	group_id INT PRIMARY KEY,
    user_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id)
);

# 그룹 내 유저리스트
CREATE TABLE User_List (
	group_id INT, 
    user_id VARCHAR(255),
    user_level ENUM("관리자", "우수회원", "일반 회원"),
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (group_id, user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id)
);

# 후기 
CREATE TABLE Reviews (
	review_id INT PRIMARY KEY,
	group_id INT, 
    user_id VARCHAR(255),
    review_content VARCHAR(255),
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id)
);

# 투표 (보류)
CREATE TABLE Votes (
	vote_id INT PRIMARY KEY,
    group_id INT, 
    user_id VARCHAR(255),
    
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id)
);

# 신고
CREATE TABLE Reports (
	report_id INT PRIMARY KEY,
    user_id VARCHAR(255),
    group_id INT,
    report_type ENUM('욕설', '사기', '성추행', '폭행', '기타'),
    report_detail VARCHAR(255),
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    report_user VARCHAR(255),
    report_image BLOB,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id),
    FOREIGN KEY (report_user) REFERENCES Users(user_id) # 가해자 정보
);

# 블랙리스트
CREATE TABLE Black_List (
	user_id VARCHAR(255),
    group_id INT,
    PRIMARY KEY (group_id, user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id)
);

