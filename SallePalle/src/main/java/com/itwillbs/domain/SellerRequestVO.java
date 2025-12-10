package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

//	CREATE TABLE seller_request (
//	    request_id      INT AUTO_INCREMENT PRIMARY KEY,     -- 신청 PK
//	    member_id       INT NOT NULL,                        -- 신청자 (회원)
//	    status          CHAR(1) DEFAULT 'W' CHECK(status IN ('W','A','R')), -- W:대기 / A:승인 / R:거절
//	    admin_memo      VARCHAR(255),                        -- 관리자 메모
//	    regdate         TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 신청 시간
//	    updatedate      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 갱신
//
//	    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
//	);

@Data
public class SellerRequestVO {
	
	private int request_id;
	private int member_id;
	private String status;
	private String admin_memo;
	private Timestamp regdate;
	private Timestamp updatedate;
}
