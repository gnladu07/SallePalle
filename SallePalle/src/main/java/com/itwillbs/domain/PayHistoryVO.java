package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class PayHistoryVO {
	
	private int pay_id;           // PK
    private int member_id;        // 대상 회원
    private int amount;           // +충전 / -사용 / -환전
    private String type;          // CHARGE / USE / WITHDRAW
    private String memo;          // 메모
    private Timestamp created_at; // 생성시간

}
