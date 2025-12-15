package com.itwillbs.domain;

import lombok.Data;

/*
 * 	2.1.2. 토큰발급 API 정보를 저장하는 객체(응답 데이터)
 * 	p28 페이지 참조
 */

@Data
public class ResponseTokenVO {
	
	private String access_token; 	// 오픈뱅킹에서 발행된 Access Token
	private String token_type;		// Access Token 유형
	private int    expires_in;      // Access Token 만료 기간(초)
	private String refresh_token;	// Access Token 갱신 토큰
	private String scope;			// Access Token 권한 범위(사용자인증 시 요청했던 권한 범위와 동일)
	private String user_seq_no;		// 사용자일련번호
	
	private int member_id;          // 포인트/마일리지 충전을 위해 추가

}
