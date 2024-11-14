use moa_db; 
 -- 모임유입율에 대한 차트 
 -- 모임 전체에 인원수가 몇명이고 1개월단위로 몇명이 유입 되었는지  
 -- 필요한 데이터가 user_id, join date 1개월씩 
SELECT 
    MONTH(join_date) AS month, 
    COUNT(user_id) AS user_count
FROM 
    User_List
WHERE 
    group_id = 1  -- 특정 그룹 ID 지정
GROUP BY 
    MONTH(join_date)
ORDER BY 
    MONTH(join_date);


 -- 투표 참여한사용자로 차트 
 SELECT 
    COUNT(vr.vote_answer) AS total, 
    count(CASE WHEN vr.vote_answer = 'O' THEN 1 ELSE 0 END) AS agree,
    count(CASE WHEN vr.vote_answer = 'X' THEN 1 ELSE 0 END) AS oppose
FROM vote_results vr
where  group_id = '1';

 -- 모임 개설 
insert into 
meeting_groups 
(group_title,mg.group_content, mg.group_type ,mg.meeting_type,mg.group_category
,mg.group_address, mg.group_image, mg.group_supplies, mg.group_date)
values();

-- 모임 삭제 및 수정
delete mg.group_id from meeting_group mg 
join user_list ul
on mg.create_id = ul.user_id
where ul.user_level('관리자') ;

--  모임 수정 
update meeting_groups mg  
set
mg.group_title  = '', mg.group_content = '', mg.group_type = '', mg.meeting_type = '', 
mg.group_category = '', mg.group_address =  '', mg.group_image = '',mg.group_supplies = ''
where creator_id = "관리자"; 

-- 남성 성비 비율  
 SELECT 
    count(CASE WHEN u.user_gender = '남성' THEN 1 ELSE 0 END) AS Male,
    count(CASE WHEN u.user_gender = '여성' THEN 1 ELSE 0 END) AS Female
FROM users u
where  group_id = '1';

--  참여 요청 조회 
select ul.group_id  from user_list ul;

-- 참여 거절
delete ul.user_id  from user_list ul;

-- 참여 승인 -유저아이디 -> user에대한 정보(개인정보 +이미지+ 닉네임)

-- 모임 등급 수정 
-- 관리자 페이지에서 유저리스트에서 user_id ->보여지는것 : nickName + user_level
--  참여 승인  트리거  사용 
-- 참여 요청을 받았을때 관리자가 승인 버튼을 클릭하면 유저 아이디가 삭제가되면서  유저 리스트에 등록  된다.
delimiter ##
create trigger  approve 
	after delete 
    on user_answers 
	for each row
    begin 
        insert into user_list(user_id)
        value(old.user_id); 
	end ##
delimiter ;

-- 신고 처리 = 방출  -> 블랙 리스트에 등록 
--  방출 버튼을 클릭하면 userlist에 user_id가 삭제되면서 그 user_id는 블랙 리스트에 등록 된다 
--  필요한 데이터 user_list-user_id 
delimiter ##
create trigger  black_list 
	after delete 
    on user_list 
	for each row
    begin 
        insert into black_list(user_id)
        value(old.user_id); 
	end ##
delimiter ;

-- 블랙 리스트 조회 + 총 인원수  조회  
-- 
select 
count(bl.black_list_id) as total,bl.black_list_id as blacklist
from black_list bl
group by blacklist ;

-- 블랙 리스트 삭제
-- 블랙 리스트 삭제되면 유저리스트 복구된다 
delimiter ##
create trigger  black_list 
	after delete 
    on black_list 
	for each row
    begin 
        insert into user_list(user_id)
        value(old.user_id); 
	end ##
delimiter ;


    
    

