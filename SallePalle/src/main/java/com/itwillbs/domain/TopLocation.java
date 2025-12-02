package com.itwillbs.domain;

import lombok.Data;

//	CREATE TABLE top_location (
//	    toplct_id   INT AUTO_INCREMENT PRIMARY KEY,    -- PK
//	    toplct_name VARCHAR(100) NOT NULL              -- 시/군/구 이름
//	);

@Data
public class TopLocation {
	
	private int    toplct_id;		// PK
	private String toplct_name;		// 시/군/구 이름

}
