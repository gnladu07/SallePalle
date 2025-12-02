package com.itwillbs.domain;

import lombok.Data;

//	CREATE TABLE email_auth (
//	    email           VARCHAR(200) PRIMARY KEY,       -- 인증 이메일
//	    auth_code       VARCHAR(20) NOT NULL,           -- 인증번호
//	    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 생성시간
//	    expire_at       TIMESTAMP                        -- 만료시간
//	);

@Data
public class EmailAuthVO {
	
	private String email;			// 인증 이메일
	private String auth_code;		// 인증번호
	private String created_at;		// 생성시간
	private String expire_at;		// 만료시간

}
