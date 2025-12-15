package com.itwillbs.domain;

import java.util.List;

import lombok.Data;

/*
 * 2.2.3. 등록계좌조회 API - 응답정보객체
 */

@Data
public class AccountSearchResponseVO {
	
	private String api_tran_id; 		// 거래고유번호(API)
	private String api_tran_dtm; 		// 거래일시(밀리세컨드)
	private String rsp_code; 			// 응답코드(API)
	private String rsp_message; 		// 응답메시지(API)
	private String user_name; 			// 사용자명
	private String res_cnt;				// 사용자 등록계좌 개수
	private List res_list;				// 사용자 등록계좌 목록

}
