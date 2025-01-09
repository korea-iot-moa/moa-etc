 CREATE DATABASE moa_db;
USE moa_db;

# 유저
# 필수 : 유저 아이디(기본키), 비밀번호, 생년월일, 성별, 이름, 닉네임   
# 선택 : 취미, 이미지, 지역 //!!! 비밀번호 질문 삭제
CREATE TABLE Users (
	user_id VARCHAR(255) PRIMARY KEY NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    user_birth_date DATE NOT NULL,
    user_gender ENUM('MALE', 'FEMALE') NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    user_nickname VARCHAR(255) NOT NULL UNIQUE,
    profile_image VARCHAR(255), 
    region ENUM('부산', '대구', '인천', '광주', '대전', '울산', '서울', '제주', '세종', '경기', '강원', '충북', '충남', '전북', '전남', '경북', '경남'),
    user_phone_number VARCHAR(255) NOT NULL,
	user_mail VARCHAR(255)
);

# 유저 취미 테이블
# 취미 id 
# 취미 유형: 취미, 문화_예술, 스포츠_운동, 푸드_맛집, 자기계발, 여행, 연애, 힐링
CREATE TABLE Hobby (
	hobby_id BIGINT AUTO_INCREMENT PRIMARY KEY,
	hobby_name VARCHAR(255) NOT NULL
);   

# 취미 기본 값 주입 
INSERT INTO Hobby 
VALUES
	(DEFAULT, "취미"),
	(DEFAULT, "문화_예술"),
	(DEFAULT, "스포츠_운동"),
	(DEFAULT, "푸드_맛집"),
	(DEFAULT, "자기계발"),
	(DEFAULT, "여행"),
	(DEFAULT, "연애"),
	(DEFAULT, "힐링");

# 유저 취미 정규화 테이블 
CREATE TABLE User_Hobbies (
	user_hobbies_id BIGINT AUTO_INCREMENT PRIMARY KEY,
	hobby_id BIGINT NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    FOREIGN KEY (hobby_id) REFERENCES Hobby(hobby_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE # 유저 회원 탈퇴시 컬럼 삭제 
);


# 그룹
# 필수 : 그룹 아이디(기본키), 생성자(모임장), 모임 제목,모임 내용, 그룹 타입(group_type), 모임 타입(meeting_type), 모임 주소
# 선택 : 준미물, 이미지
# 참조 : 유저- 유저 아이디-생성자 
CREATE TABLE Meeting_Groups (
	group_id INT AUTO_INCREMENT PRIMARY KEY,
    creator_id VARCHAR(255) NOT NULL,
    group_title VARCHAR(255) NOT NULL,
    group_content TEXT NOT NULL,
    group_type ENUM('단기모임', '정기모임') NOT NULL,
    meeting_type ENUM('온라인', '오프라인') NOT NULL,
    group_category ENUM('취미', '문화_예술', '스포츠_운동', '푸드_맛집', '자기계발', '여행', '연애', '힐링'), 
    group_address VARCHAR(255) NOT NULL,
    group_image VARCHAR(255),
    group_supplies VARCHAR(255),
    group_date DATE NOT NULL,
    group_question VARCHAR(255) NOT NULL,
    FOREIGN KEY (creator_id) REFERENCES Users(user_id) ON DELETE CASCADE
);



# 추천 
# 참조 : (유저 - 유저 아이디 , 그룹 - 그룹 아이디): 기본키   
CREATE TABLE Recommendations (
	group_id INT,
    user_id VARCHAR(255),
    PRIMARY KEY(group_id, user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES Meeting_Groups(group_id) ON DELETE CASCADE
);

# 유저리스트에 답변 저장
# 질문 & 답변 테이블 만들지
# 필수 : 답변 아이디(기본키), 그룹 아이디, 유저 아이디, 유저 답변, 답변 제출한 날짜, 승인 여부    
# 참조 : 그룹(Meeting_Groups) - 그룹 아이디, 유저(Users) - 유저 아이디 
CREATE TABLE User_Answers (
    answer_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    group_id INT NOT NULL,  -- 어느 모임에 대한 답변인지
    user_id VARCHAR(255) NOT NULL,  -- 답변한 사용자
    user_answer TEXT NOT NULL,  -- 사용자가 제출한 답변
    answer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,  -- 답변 제출 날짜
    is_approved INT DEFAULT 2 NOT NULL,  -- 관리자가 승인을 했는지 여부 0: 거절 1: 승인 2: 대기중
	FOREIGN KEY (group_id) REFERENCES Meeting_Groups(group_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


# 그룹 내 유저리스트
# 필수 : 유저 레벨, 참여 날짜
# 참조 :기본키(그룹(Meeting_Groups) - 그룹 아이디, 유저(Users) - 유저 아이디 )
CREATE TABLE User_List (
	group_id INT, 
    user_id VARCHAR(255),
    user_level ENUM("관리자", "우수회원", "일반회원") NOT NULL,
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (group_id, user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES Meeting_Groups(group_id) ON DELETE CASCADE
);



# 후기 
# 필수 : 리뷰 아이디(기본키) 그룹 아이디, 유저 아이디, 리뷰 내용, 리뷰 날짜 
# 선택 : 이미지
# 참조 : 그룹(Meeting_Groups) - 그룹 아이디, 유저(Users) - 유저 아이디 
CREATE TABLE Reviews (
	review_id INT AUTO_INCREMENT PRIMARY KEY,
	group_id INT NOT NULL,
    group_name VARCHAR(255) NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    review_content TEXT NOT NULL,
    review_image VARCHAR(255),
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES Meeting_Groups(group_id) ON DELETE CASCADE
);

# 투표 개설
# 필수값: 투표아이디, 그룹아이디, 생성자아이디, 투표내용, 투표생성날짜, 투표종료날짜
# 선택값: X
# 참조값: 유저(Users)-유저 아이디, 그룹(Meeting_Groups)-그룹아이디
CREATE TABLE Votes (
	vote_id INT AUTO_INCREMENT PRIMARY KEY, -- 투표아이디
    group_id INT NOT NULL, -- 그룹아이디
    creator_id VARCHAR(255) NOT NULL, -- 생성자아이디
    vote_content TEXT NOT NULL, -- 투표내용
    vote_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 투표생성날짜
    vote_close_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 투표종료날짜
    FOREIGN KEY (creator_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES Meeting_Groups(group_id) ON DELETE CASCADE
);

# 투표 참여
# 필수값: 투표결과아이디, 투표아이디, 유저아이디, 투표답변, 투표한날짜
# 선택값: X
# 참조값: 투표아이디(Votes) - 투표아이디, 유저(Users) - 유저아이디
CREATE TABLE Vote_Results (
	vote_result_id INT AUTO_INCREMENT PRIMARY KEY, -- 투표결과아이디
    vote_id INT NOT NULL, -- 투표아이디
    user_id VARCHAR(255) NOT NULL, -- 사용자아이디
    vote_answer ENUM("O", "X") NOT NULL, -- 투표답변
    vote_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 투표한날짜
    FOREIGN KEY (vote_id) REFERENCES Votes(vote_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

# 신고
# 필수값: 신고아이디, 유저 아이디, 그룹아이디, 신고유형, 신고내용, 신고자, 신고결과
# 선택값: 신고이미지
# 참조값: 유저(Users)-유저 아이디, 그룹(Meeting_Groups)-그룸아이디, 유저 유저(Users)-신고아이디
CREATE TABLE Reports (
	report_id INT AUTO_INCREMENT PRIMARY KEY, -- 신고아이디
    user_id VARCHAR(255) NOT NULL, -- 사용자 아이디
    group_id INT NOT NULL, -- 그룹아이디
    report_type ENUM('욕설', '사기', '성추행', '폭행', '기타') NOT NULL, -- 신고유형
    report_detail TEXT NOT NULL, -- 신고유형
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 신고내용
    report_user VARCHAR(255) NOT NULL, -- 신고자
    report_image VARCHAR(255), -- 신고이미지
    report_result ENUM("처리중", "추방", "유지") DEFAULT "처리중" NOT NULL, -- 신고결과
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Groups(group_id),
    FOREIGN KEY (report_user) REFERENCES Users(user_id) # 가해자 정보
);

# 블랙리스트
# 기본키: 블랙리스트아이디
# 필수값: 유저 아이디, 그룸아이디  
# 선택값: X
# 참조값: 유저(Users)-유저 아이디, 그룹(Meeting_Groups)-그룸아이디
CREATE TABLE Black_List (
	black_list_id INT AUTO_INCREMENT PRIMARY KEY, -- 블랙리스트아이디
	user_id VARCHAR(255) NOT NULL, -- 사용자아이디
    group_id INT NOT NULL, -- 그룸아이디
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Meeting_Groups(group_id)
);

# 공지사항: 사이트 관련 공지사항, 자주하는 질문
# 기본키: 공지사항아이디
# 필수값: 공지사항제목, 공지사항 내용, 공지사항업로드날짜
# 선택값: X
CREATE TABLE Notices (
	notice_id INT AUTO_INCREMENT PRIMARY KEY,-- 공지사항아이디
    notice_title VARCHAR(255) NOT NULL,-- 공지사항제목
    notice_content TEXT NOT NULL, -- 공지사항 내용
    notice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL -- 공지사항업로드날짜
);