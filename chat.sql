CREATE TABLE Chat_Rooms (
    chat_room_id INT AUTO_INCREMENT PRIMARY KEY, -- 채팅방 ID
    group_id INT NOT NULL UNIQUE,               -- 모임 그룹 ID
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 채팅방 생성일
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 마지막 업데이트일
    FOREIGN KEY (group_id) REFERENCES Meeting_Groups(group_id) ON DELETE CASCADE -- 외래키 제약조건
);

CREATE TABLE Chat_Messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,  -- 메시지 ID
    chat_room_id INT NOT NULL,                  -- 채팅방 ID
    user_id VARCHAR(255) NOT NULL,              -- 메시지를 보낸 사용자 ID
    message_type ENUM('ENTER', 'TALK', 'EXIT', 'JOIN', 'NOTIFY') NOT NULL, -- 메시지 유형
    content TEXT,                               -- 메시지 내용 (TALK 유형일 때만 사용)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 메시지 전송 시간
    FOREIGN KEY (chat_room_id) REFERENCES Chat_Rooms(chat_room_id) ON DELETE CASCADE, -- 외래키 제약조건
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE -- 외래키 제약조건
);

CREATE TABLE Chat_Users (
    chat_user_id INT AUTO_INCREMENT PRIMARY KEY, -- 접속 상태 ID
    chat_room_id INT NOT NULL,                   -- 채팅방 ID
    user_id VARCHAR(255) NOT NULL,               -- 사용자 ID
    entered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 채팅방 접속 시간
    exited_at TIMESTAMP NULL,                    -- 채팅방 나간 시간 (NULL이면 현재 접속 중)
    FOREIGN KEY (chat_room_id) REFERENCES Chat_Rooms(chat_room_id) ON DELETE CASCADE, -- 외래키 제약조건
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE -- 외래키 제약조건
);
