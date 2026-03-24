package com.itwillbs.domain;

import lombok.Data;

//	CREATE TABLE mileage_wallet (
//	    member_id   INT PRIMARY KEY,               -- 회원 PK
//	    mileage     INT DEFAULT 0,                 -- 보유 마일리지
//
//	    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
//	);

@Data
public class MileageWalletVO {
	
	private int member_id;   // PK
    private int mileage;     // 보유 마일리지

}
