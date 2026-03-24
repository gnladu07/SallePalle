package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

//	CREATE TABLE saletrade_item_category (
//	    item_ctg_id   INT AUTO_INCREMENT PRIMARY KEY,  -- 물품 종류 PK
//	    item_ctg_name VARCHAR(100) NOT NULL,            -- 물품 종류명
//	    is_active     CHAR(1) DEFAULT 'Y'               -- 사용 여부
//	        CHECK (is_active IN ('Y','N')),
//	    regdate       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
//	);

@Data
public class ItemCategoryVO {
	
	private int item_ctg_id;
    private String item_ctg_name;
    private String is_active;
    private Timestamp regdate;

}
