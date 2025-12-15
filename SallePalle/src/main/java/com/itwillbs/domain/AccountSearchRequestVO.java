package com.itwillbs.domain;

import lombok.Data;

/*
 *	2.2.3. 등록계좌조회 API(p53)
 *	
 *	<access_token>, user_seq_no, include_cancel_yn, sort_order 정보처리 
 */

@Data
public class AccountSearchRequestVO {
	
	private String access_token;
	private String user_seq_no;
	private String include_cancel_yn;
	private String sort_order;
	
	

}
