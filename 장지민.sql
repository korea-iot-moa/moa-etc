# 검색
SELECT group_id, group_title, group_address, group_category, group_address, group_image, group_date
FROM Meeting_Groups
WHERE group_title LIKE '%keyword%'
ORDER BY group_id; 

#카테고리 필터링
SELECT group_id, group_title, group_address, group_category, group_address, group_image, group_date
FROM Meeting_Groups
WHERE group_category IN ('취미', '문화_예술', '스포츠_운동', '푸드_맛집', '자기계발', '여행', '연애', '힐링')
	AND group_address IN ('부산', '대구', '인천', '광주', '대전', '울산', '서울', '제주', '세종', '경기', '강원', '충북', '충남', '전북', '전남', '경북', '경남')
ORDER BY group_id; 

/*
2. 홈화면 필터링 - 회원가입하면서 체크한 카테고리 항목에 맞춰서 홈화면에 모임을 추천해준다.
출력된 카테고리 3개가 화면에 (모임이름, 모이주소, 모임사진, 모임날짜)데이터를 가지고온다. 이 3개의 카테고리에는 각각 3개의 모임이 랜덤으로 출력된다.
Users에 있는 hobby와 Meeting_Groups의 group_category 일치하는 카테고리만 출력한다.
*/

SELECT group_id, group_title, group_address, group_category, group_image, group_date
FROM (
    SELECT mg.group_id, u.user_id, mg.group_title, mg.group_address, mg.group_category, 
           mg.group_image, mg.group_date,
           ROW_NUMBER() OVER (PARTITION BY mg.group_category ORDER BY group_category) AS rn
    FROM Meeting_Groups mg
    LEFT JOIN Users u ON mg.group_category = u.hobby
    WHERE u.user_id = 'userId'
      AND mg.group_category IN ('취미', '문화_예술', '스포츠_운동', '푸드_맛집', '자기계발', '여행', '연애', '힐링')
) AS ranked
WHERE ranked.rn <= 3
ORDER BY group_category, RAND();


#2-2. 단기/정기 모임 필터링
SELECT DISTINCT group_id, group_type, group_title, group_address, group_image, group_date
FROM Meeting_Groups 
WHERE  group_type IN ('단기모임', '정기모임')
ORDER BY group_id;


#3. 추천 버튼을 클릭하면 그 모임에 클릭한 유저의 수 만큼 카운트(추천순으로 모임을 나열할 때 쓰인다.)
#3-1.추천 / 추천순
SELECT DISTINCT mg.group_id, count(reco.user_id) As Recommendation_count
FROM Meeting_Groups mg 
LEFT JOIN Recommendations reco ON mg.group_id = reco.group_id
LEFT JOIN Users u ON reco.user_id = u.user_id
ORDER BY Recommendation_count DESC;


# 4. 내정보 관리
#4-1. 내정보관리 조회
SELECT user_id,  user_password,  user_gender,  user_name,  user_nickname, hobby, profile_image, region
FROM Users
WHERE user_id = 'userId' AND user_password = 'password';
#4-2. 내정보관리 수정
UPDATE Users 
set user_name = 'userId', user_nickname = 'userNickname', hobby = 'hobby', 
profile_image = 'profileImage', region = 'region';

#4-3. 내정보관리 삭제(탈퇴)
DELETE FROM Users 
WHERE user_id = 'userId' AND user_password = 'userPassword';
 
#5. 모임 참여 신청 페이지*****
INSERT INTO  User_Answers (group_id, user_id, user_answer)
VALUE ('group_id', 'user_id', 'user_answer');

#6. 아이디 찾기
SELECT DISTINCT user_id FROM Users
WHERE user_name ='userName' AND user_birth_date = 'userBirthdate';



