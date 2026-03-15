package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class ChatMessageVO {
    private int message_id;
    private int room_id;
    private int sender_id;
    private String message_text;
    private String is_read;
    private Timestamp sent_at;
    
    // 화면 출력용
    private String sender_nickname; // 보낸 사람 닉네임
    private String sender_profile;  // 보낸 사람 프로필 이미지
    
    // 메시지 타입 (일반 텍스트인지, 시스템 메시지인지, '결제요청' 버튼인지 구분하기 위해 추가)
    private String type = "TEXT";   // TEXT, SYSTEM, PAYMENT 등 확장 대비
}