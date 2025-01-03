CREATE TABLE chat_message (
	
	id BIGINT AUTO_INCREMENT PRIMARY KEY,					-- 메시지 고유 식별자
    room_id BIGINT NOT NULL,							-- 메시지가 속한 채팅방의 ID
    sender VARCHAR(255) NOT NULL,							-- 메시지를 보낸 사용자의 ID
    message TEXT NOT NULL,									-- 메시지 내용
    timestampe DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP	-- 메시지 전송 시간 (기본값: 현재시간)
);

-- 채팅방 별 메시지를 시간순으로 정렬
CREATE INDEX idx_room_id_timestamp ON chat_message (room_id, timestampe);