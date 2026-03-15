package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class ChatRoomVO {
    private int room_id;
    private int trade_id;
    private int buyer_id;
    private int seller_id;
    private Timestamp created_at;
    
    private String trade_title;       // 상품 이름
    private String trade_thumb_img;   // 상품 썸네일 이미지
    private int trade_price;          // 상품 가격
    private String trade_status;      // 상품 상태 (S, R, C)
    
    private String buyer_nickname;    // 구매자 닉네임
    private String seller_nickname;   // 판매자 닉네임
    
    private String last_message;      // 목록에 보여줄 마지막 메시지
    private Timestamp last_message_time; // 마지막 메시지 시간
    private int unread_count;         // 안 읽은 메시지 개수
}