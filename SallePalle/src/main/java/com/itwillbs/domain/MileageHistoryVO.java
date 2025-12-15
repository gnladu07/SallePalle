package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class MileageHistoryVO {
	
	private int history_id;      // PK
    private int member_id;       // 대상 회원
    private int amount;          // +적립 / -사용
    private String type;         // EARN / USE
    private String memo;         // 설명
    private Timestamp created_at;// 발생시각

}
