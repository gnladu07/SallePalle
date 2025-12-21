package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

//-- 중고 판매 게시판
//CREATE TABLE saletrade_board (
//    trade_id        INT AUTO_INCREMENT PRIMARY KEY,   -- 게시글 PK
//    seller_id       INT NOT NULL,                     -- 판매자(member_id)
//    title           VARCHAR(200) NOT NULL,            -- 글 제목
//    content         TEXT NOT NULL,                    -- 글 내용
//    price_point     INT NOT NULL,                     -- 기본 결제: 살래 포인트
//    max_mileage_use INT DEFAULT 0,                    -- 사용 가능 마일리지 최대치
//    quantity        INT DEFAULT 1,                    -- 판매 수량
//    thumb_img       VARCHAR(255),                     -- 썸네일 이미지
//    detail_img      VARCHAR(255),                     -- 상세 이미지
//    item_ctg_id     INT NOT NULL,                      -- 중고 물품 종류
//    recommend_cnt   INT DEFAULT 0,                    -- 추천 횟수
//    status          CHAR(1) DEFAULT 'S' CHECK(status IN ('S','R','C')), -- S:판매중 R:예약 C:완료
//    regdate         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- 등록일
//    updatedate      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정일
//    toplct_id       INT NOT NULL,							-- 거래 지역 (시/도)
//    detail_address  VARCHAR(255) NOT NULL,					-- 거래 상세 주소
//    is_deleted      CHAR(1) DEFAULT 'N' CHECK (is_deleted IN ('Y','N')), -- 판매글 논리 삭제 여부(Y : 삭제(비노출), N : 정상 노출 상태)
//	deleted_at      TIMESTAMP NULL,                         -- is_deleted = 'Y' 로 변경된 시간 기록
//    allow_full_mileage CHAR(1) DEFAULT 'N' CHECK (allow_full_mileage IN ('Y','N')),
//    -- 전액을 팔래 마일리지로 결제할 수 있는지 여부(Y : 마일리지만으로 전액 결제 허용, N : 마일리지 할인만 허용 (포인트 결제 필수))
//    
//    FOREIGN KEY (item_ctg_id) REFERENCES saletrade_item_category(item_ctg_id),
//    FOREIGN KEY (toplct_id) REFERENCES top_location(toplct_id),
//    FOREIGN KEY (seller_id) REFERENCES member(member_id)
//);

@Data
public class SaleTradeVO {
	
    private Integer trade_id;
    private Integer seller_id;

    private String title;
    private String content;

    private Integer price_point;
    private Integer max_mileage_use;
    private Integer quantity = 1;

    private String thumb_img;
    private String detail_img;
    
    private Integer recommend_cnt;
    private String status;

    private Timestamp regdate;
    private Timestamp updatedate;

    private Integer item_ctg_id;
    private Integer toplct_id;
    private String detail_address;

    private String is_deleted;
    private Timestamp deleted_at;

    private String allow_full_mileage;

    // 리스트 화면 표시용 (JOIN 결과)
    private String seller_nickname;   // member.nickname
    private String toplct_name;        // top_location.toplct_name
    private String email;
  

}
