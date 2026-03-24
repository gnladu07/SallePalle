package com.itwillbs.domain;

import lombok.Data;

//	CREATE TABLE pay_wallet (
//	    member_id   INT PRIMARY KEY,                  -- 회원 PK
//	    balance     INT DEFAULT 0,                    -- 보유 포인트
//	    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
//	);

@Data
public class PayWalletVO {
	
	 private int member_id;   // PK = member.member_id
	 private int balance;     // 보유 포인트

}
