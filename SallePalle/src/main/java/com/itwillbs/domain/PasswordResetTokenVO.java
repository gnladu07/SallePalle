package com.itwillbs.domain;

import java.time.LocalDateTime;

import lombok.Data;

//	CREATE TABLE password_reset_token (
//	    userid VARCHAR(100) NOT NULL,
//	    token VARCHAR(200) NOT NULL,
//	    expire_time DATETIME NOT NULL,
//	    PRIMARY KEY (token)
//	);

@Data
public class PasswordResetTokenVO {
	
	private String userid;
	private String token;
	private LocalDateTime expire_time;

}
