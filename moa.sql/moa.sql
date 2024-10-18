CREATE DATABASE moa_db;
USE moa_db;

# 유저
CREATE TABLE Users (
	user_id VARCHAR(255) PRIMARY KEY,
    user_password VARCHAR(255),
    user_birthDate VARCHAR(255),
    user_gender ENUM('male', 'female'),
    user_name VARCHAR(255),
    user_nickname VARCHAR(255),
    security_question ENUM("1","2","3","4","5"),
    security_answer VARCHAR(255),
    hobby ENUM('취미', '문화&예술', '스포츠&운동', '푸드&맛집', '자기계발', '여행', '연애', '힐링'),
    profile_image BLOB, 
    region ENUM('부산', '대구', '인천', '광주', '대전', '울산', '서울', '제주', '세종', '경기', '강원', '충북', '충남', '전북', '전남', '경북', '경남')
);

# 그룹
CREATE TABLE Meeting_Group (
	group_id INT AUTO_INCREMENT PRIMARY KEY,
    creator_id VARCHAR(255),
    group_title VARCHAR(255),
    group_content VARCHAR(255),
    group_type ENUM('단기모임', '정기모임'),
    meeting_type ENUM('온라인', '오프라인'),
    group_address VARCHAR(255),
    group_image BLOB,
    group_supplies VARCHAR(255),
    group_date DATE,
    group_question VARCHAR(255),
    FOREIGN KEY (creator_id) REFERENCES Users(user_id)
);

# 추천
CREATE TABLE Recommendation (
	group_id INT,
    user_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id)
);

# 유저리스트에 답변 저장
# 질문 & 답변 테이블 만들지
CREATE TABLE User_Answers (
    answer_id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT,  -- 어느 모임에 대한 답변인지
    user_id VARCHAR(255),  -- 답변한 사용자
    user_answer VARCHAR(255),  -- 사용자가 제출한 답변
    answer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 답변 제출 날짜
    is_approved BOOLEAN DEFAULT FALSE,  -- 관리자가 승인을 했는지 여부
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
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
	review_id INT AUTO_INCREMENT PRIMARY KEY,
	group_id INT, 
    user_id VARCHAR(255),
    review_content VARCHAR(255),
    review_image BLOB,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id)
);

# 투표  개설
CREATE TABLE Votes (
	vote_id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT, 
    creator_id VARCHAR(255), # 생성자
    vote_content VARCHAR(255),
    vote_update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    vote_close_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (creator_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id)
);

# 투표 참여
CREATE TABLE Vote_Results (
	vote_result_id INT AUTO_INCREMENT PRIMARY KEY,
    vote_id INT,
    user_id VARCHAR(255),
    vote_answer ENUM("O", "X"),
    vote_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vote_id) REFERENCES Votes(vote_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

# 신고
CREATE TABLE Reports (
	report_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255),
    group_id INT,
    report_type ENUM('욕설', '사기', '성추행', '폭행', '기타'),
    report_detail VARCHAR(255),
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    report_user VARCHAR(255),
    report_image BLOB,
    report_result ENUM("처리중", "추방", "유지") DEFAULT "처리중",
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id),
    FOREIGN KEY (report_user) REFERENCES Users(user_id) # 가해자 정보
    
);

# 블랙리스트
CREATE TABLE Black_List (
	black_list_id INT AUTO_INCREMENT PRIMARY KEY,
	user_id VARCHAR(255),
    group_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id)
);

CREATE TABLE Notice (
	notice_id INT AUTO_INCREMENT PRIMARY KEY,
    notice_title VARCHAR(255),
    notice_content VARCHAR(255),
    notice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

