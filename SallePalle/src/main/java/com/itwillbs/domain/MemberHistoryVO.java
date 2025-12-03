package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

//	CREATE TABLE update_member_history (
//	    history_id      INT AUTO_INCREMENT PRIMARY KEY,
//	    userid          VARCHAR(100) NOT NULL,  -- 어떤 회원인지
//	    changed_field   VARCHAR(50) NOT NULL,   -- 변경된 컬럼명
//	    old_value       VARCHAR(255),           -- 이전 값
//	    new_value       VARCHAR(255),           -- 바뀐 값
//	    changed_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
//	    changed_by      VARCHAR(100) NOT NULL,  -- 누가 변경했는지 (본인 or ADMIN)
//	    
//	    FOREIGN KEY (userid) REFERENCES member(userid)
//	);

@Data
public class MemberHistoryVO {
	
	private int    history_id;
	private String userid;
	private String changed_field;
	private String old_value;
	private String new_value;
	
	private Timestamp changed_at;
	private String    changed_by;
	
	// 파라메터 생성자 추가
	public MemberHistoryVO(String userid, String changed_field, 
			               String old_value, String new_value,
			               String changed_by) {
		
		this.userid = userid;
		this.changed_field = changed_field;
		this.old_value = old_value;
		this.new_value = new_value;
		this.changed_by = changed_by;
	}

}
