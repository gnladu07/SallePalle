package com.itwillbs.domain;

import lombok.Data;

@Data
public class RequestTokenVO {
	
	private String code;			// 사용자가 인증 성공후에 획득한 인증코드
	private String scope;   		// Access Token  권한 범위 설정
	private String state;   		// CSRF 토큰값
	private String client_info;		// 이용하는 기관이 세팅한 설정값
	
	private String client_id;		// 오픈뱅킹에서 발급받은 값
	private String client_secret; 	// 오픈뱅킹에서 발급받은 값
	private String redirect_uri;	// 콜백 주소
	
	private String grant_type;		// 권한 부여방식 설정

}
