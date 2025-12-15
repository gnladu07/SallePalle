package com.itwillbs.domain;

import lombok.Data;

// p48 참고 - 사용자정보조회 API
// 요청정보 저장객체
// 2.2.1. 사용자정보조회 API

@Data
public class UserInfoRequestVO {
	
	// 오픈뱅킹으로부터 전송받은 Access Token 을 HTTP 
	// Header 에 추가 [ scope = login, sa ] - 입력값: Bearer <access_token>
	private String access_token;
	
	// 사용자일련번호
	private String user_seq_no;

}
