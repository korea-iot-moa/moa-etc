# 사용자 조회
SELECT *
FROM Users u 
WHERE u.user_id = 'USER_ID';

# 모임 내 유저 조회 - 아이디, 닉네임
SELECT u.user_id, u.user_nickname
FROM Users u
JOIN user_list ul ON u.user_id = ul.user_id
WHERE ul.group_id = 'GROUP_ID';

# 내 모임 조회 (사이드바) - 그룹id, 모임 이미지, 제목
SELECT g.group_id, g.group_image, g.group_title
FROM meeting_groups g
JOIN user_list ul ON g.group_id = ul.group_id
WHERE ul.user_id = 'USER_ID';

# 모임 나가기 유저 id , 그룹 id 가 user_list 테이블에 일치할 시
DELETE 
FROM user_list 
WHERE user_id = "userId" 
AND group_id = "groupId";

# 후기 전체 조회
SELECT *
FROM reviews;

# 후기 단건 조회
SELECT *
FROM reviews
WHERE review_id = "REIVEW_ID";

# 내 후기 조회
SELECT r.*
FROM reviews r
WHERE r.user_id = "USER_ID";

# 투표 조회
SELECT v.*
FROM votes v
JOIN meeting_groups mg ON v.group_id = mg.group_id
WHERE v.group_id = mg.group_id;

# 남녀 성비 퍼센트 차트
SELECT 
    SUM(CASE WHEN u.user_gender = 'male' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS male_percentage,
    SUM(CASE WHEN u.user_gender = 'female' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS female_percentage,
    COUNT(*) AS totalPerson
FROM 
    User_List ul
JOIN 
    Users u ON ul.user_id = u.user_id
WHERE 
    ul.group_id = "GROUP_ID"; 
    

# 신고 추방 쿼리
UPDATE Reports r
SET r.report_result = "추방"
WHERE r.report_id = "reportId";

DELIMITER $$

CREATE TRIGGER ban_user
AFTER UPDATE ON Reports
FOR EACH ROW
BEGIN
	# '추방' 상태 변경 시 블랙리스트 테이블에 추가
    IF NEW.report_result = '추방' THEN
	INSERT INTO Blacklist (user_id, group_id)
	VALUES (NEW.user_id, NEW.group_id);
        
	# user_list 테이블에서 유저 삭제
	DELETE FROM user_list
	WHERE user_id = NEW.user_id AND group_id = NEW.group_id;
    END IF;
END $$

DELIMITER ;

# 신고 유지
UPDATE Reports r
SET r.report_result = "유지"
WHERE r.report_id = "reportId";







