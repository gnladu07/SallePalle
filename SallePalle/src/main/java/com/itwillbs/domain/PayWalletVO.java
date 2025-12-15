package com.itwillbs.domain;

import lombok.Data;

@Data
public class PayWalletVO {
	
	 private int member_id;   // PK = member.member_id
	 private int balance;     // 보유 포인트

}
