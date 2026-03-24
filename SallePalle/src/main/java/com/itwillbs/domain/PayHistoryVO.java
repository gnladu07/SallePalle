package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

//	CREATE TABLE pay_history (
//	    pay_id      INT AUTO_INCREMENT PRIMARY KEY,   -- 거래 PK
//	    member_id   INT NOT NULL,                     -- 대상 회원
//	    amount      INT NOT NULL,                     -- +충전 / -사용 / -환전
//	    type        VARCHAR(20) NOT NULL,             -- CHARGE / USE / WITHDRAW
//	    memo        VARCHAR(255),                     -- 메모
//	    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 발생 시각
//
//	    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
//	);

@Data
public class PayHistoryVO {
	
	private int pay_id;           // PK
    private int member_id;        // 대상 회원
    private int amount;           // +충전 / -사용 / -환전
    private String type;          // CHARGE / USE / WITHDRAW
    private String memo;          // 메모
    private Timestamp created_at; // 생성시간

}
