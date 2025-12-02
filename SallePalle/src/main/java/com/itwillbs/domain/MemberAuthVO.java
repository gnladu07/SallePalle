package com.itwillbs.domain;

import lombok.Data;

//	CREATE TABLE member_auth (
//	    auth_id     INT AUTO_INCREMENT PRIMARY KEY,    -- 권한 PK
//	    userid      VARCHAR(100) NOT NULL,             -- member.userid 참조
//	    auth        VARCHAR(50) NOT NULL,              -- ROLE_USER / ROLE_ADMIN 등
//	    FOREIGN KEY (userid) REFERENCES member(userid) ON DELETE CASCADE
//	);

@Data
public class MemberAuthVO {
	
	private int    auth_id;		// 권한 PK
	private String userid;		// member.userid 참조
	private String auth;		// ROLE_USER / ROLE_ADMIN 등

}
