package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

//	CREATE TABLE mileage_history (
//	    history_id  INT AUTO_INCREMENT PRIMARY KEY,   -- PK
//	    member_id   INT NOT NULL,                     -- 대상 회원
//	    amount      INT NOT NULL,                     -- +적립 / -사용
//	    type        VARCHAR(20) NOT NULL,             -- EARN / USE
//	    memo        VARCHAR(255),                     -- 설명
//	    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 발생 시각
//
//	    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
//	);

@Data
public class MileageHistoryVO {
	
	private int history_id;      // PK
    private int member_id;       // 대상 회원
    private int amount;          // +적립 / -사용
    private String type;         // EARN / USE
    private String memo;         // 설명
    private Timestamp created_at;// 발생시각

}
