package com.itwillbs.domain;

import lombok.Data;

@Data
public class Criteria {
	
	private int page;      // 현재 페이지 번호
    private int amount;    // 한 페이지당 출력 수

    private String sort;
    
    private String filter;
    
    public Criteria() {
        this.page = 1;  
        this.amount = 10; 
    }

    public Criteria(int page, int amount) {
        this.page = page;
        this.amount = amount;
    }

    public int getPageStart() {
        return (this.page - 1) * this.amount;
    }
    
    private String type;     // 검색 타입
    private String keyword;  // 검색어

}
