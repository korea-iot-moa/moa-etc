CREATE DATABASE moa_db;
USE moa_db;

# 유저 - 선택 - 취미, 이미지, 지역
CREATE TABLE Users (
	user_id VARCHAR(255) PRIMARY KEY NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    user_birth_date DATE NOT NULL,
    user_gender ENUM('male', 'female') NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    user_nickname VARCHAR(255) NOT NULL UNIQUE,
    security_question ENUM("1","2","3","4","5") NOT NULL,
    security_answer VARCHAR(255) NOT NULL,
    hobby ENUM('취미', '문화&예술', '스포츠&운동', '푸드&맛집', '자기계발', '여행', '연애', '힐링'), 
    profile_image BLOB, 
    region ENUM('부산', '대구', '인천', '광주', '대전', '울산', '서울', '제주', '세종', '경기', '강원', '충북', '충남', '전북', '전남', '경북', '경남')
);

# 그룹 - 선택 - 준미물, 이미지
CREATE TABLE Meeting_Groups (
	group_id INT AUTO_INCREMENT PRIMARY KEY,
    creator_id VARCHAR(255) NOT NULL,
    group_title VARCHAR(255) NOT NULL,
    group_content TEXT NOT NULL,
    group_type ENUM('단기모임', '정기모임') NOT NULL,
    meeting_type ENUM('온라인', '오프라인') NOT NULL,
    group_address VARCHAR(255) NOT NULL,
    group_image BLOB,
    group_supplies VARCHAR(255),
    group_date DATE NOT NULL,
    group_question VARCHAR(255) NOT NULL,
    FOREIGN KEY (creator_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

# 추천
CREATE TABLE Recommendations (
	group_id INT,
    user_id VARCHAR(255),
    PRIMARY KEY(group_id, user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id) ON DELETE CASCADE
);

# 유저리스트에 답변 저장
# 질문 & 답변 테이블 만들지
CREATE TABLE User_Answers (
    answer_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    group_id INT NOT NULL,  -- 어느 모임에 대한 답변인지
    user_id VARCHAR(255) NOT NULL,  -- 답변한 사용자
    user_answer TEXT NOT NULL,  -- 사용자가 제출한 답변
    answer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,  -- 답변 제출 날짜
    is_approved BOOLEAN DEFAULT FALSE NOT NULL,  -- 관리자가 승인을 했는지 여부
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


# 그룹 내 유저리스트
CREATE TABLE User_List (
	group_id INT, 
    user_id VARCHAR(255),
    user_level ENUM("관리자", "우수회원", "일반 회원") NOT NULL,
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (group_id, user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id) ON DELETE CASCADE
);



# 후기 - 선택 -  이미지
CREATE TABLE Reviews (
	review_id INT AUTO_INCREMENT PRIMARY KEY,
	group_id INT NOT NULL, 
    user_id VARCHAR(255) NOT NULL,
    review_content TEXT(255) NOT NULL,
    review_image BLOB,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id) ON DELETE CASCADE
);

# 투표  개설
CREATE TABLE Votes (
	vote_id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL, 
    creator_id VARCHAR(255) NOT NULL, # 생성자
    vote_content TEXT(255) NOT NULL,
    vote_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    vote_close_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (creator_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id) ON DELETE CASCADE
);

# 투표 참여
CREATE TABLE Vote_Results (
	vote_result_id INT AUTO_INCREMENT PRIMARY KEY,
    vote_id INT NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    vote_answer ENUM("O", "X") NOT NULL,
    vote_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (vote_id) REFERENCES Votes(vote_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

# 신고
CREATE TABLE Reports (
	report_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    group_id INT NOT NULL,
    report_type ENUM('욕설', '사기', '성추행', '폭행', '기타') NOT NULL,
    report_detail TEXT(255) NOT NULL,
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    report_user VARCHAR(255) NOT NULL,
    report_image BLOB,
    report_result ENUM("처리중", "추방", "유지") DEFAULT "처리중" NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id),
    FOREIGN KEY (report_user) REFERENCES Users(user_id) # 가해자 정보
    
);

# 블랙리스트
CREATE TABLE Black_List (
	black_list_id INT AUTO_INCREMENT PRIMARY KEY,
	user_id VARCHAR(255) NOT NULL,
    group_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Group(group_id)
);

CREATE TABLE Notices (
	notice_id INT AUTO_INCREMENT PRIMARY KEY,
    notice_title VARCHAR(255) NOT NULL,
    notice_content TEXT NOT NULL,
    notice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

