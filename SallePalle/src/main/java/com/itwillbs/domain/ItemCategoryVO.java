package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ItemCategoryVO {
	
	private int item_ctg_id;
    private String item_ctg_name;
    private String is_active;
    private Timestamp regdate;

}
