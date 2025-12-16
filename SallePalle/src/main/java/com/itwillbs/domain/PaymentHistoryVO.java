package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class PaymentHistoryVO {
	
	private String history_type;   // PAY / MILEAGE (구분용, DB 컬럼 아님)
    private String type;           // CHARGE / USE / WITHDRAW / EARN
    private int amount;
    private String memo;
    private Timestamp created_at;

}
