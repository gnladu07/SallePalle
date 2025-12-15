package com.itwillbs.domain;

import java.util.List;

import lombok.Data;

// 2.2.1. 사용자정보조회 API
// 응답 사용자 정보

//user_info (선택) AN(8) 생년월일
//user_gender (선택) A(1) 성별
//user_cell_no (선택) AN(11) 휴대폰번호
//user_email (선택) E(100) 이메일주소
//res_cnt N(5) 등록된 계좌 개수
//res_list 등록된 계좌 목록

@Data
public class UserInfoResponseVO {
	
	private String api_tran_id;		// 거래고유번호(API)
	private String api_tran_dtm;	// 거래일시(밀리세컨드)
	private String rsp_code;		// 응답코드(API)
	private String rsp_message;		// 응답메시지(API)
	
	private String user_seq_no;		// 사용자일련번호
	private String user_ci;			// CI(Connect Info)
	private String user_name;		// 고객명
	private String user_info;		// 생년월일
	private String user_gender; 	// 성별
	private String user_cell_no;    // 휴대폰번호
	private String user_email;		// 이메일주소
	
	private String res_cnt; 		// 등록된 계좌 개수
	private List res_list;    		// 등록된 계좌 목록
	

}
