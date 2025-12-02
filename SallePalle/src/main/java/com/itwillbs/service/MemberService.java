package com.itwillbs.service;

import com.itwillbs.domain.MemberVO;

public interface MemberService {

	// 회원 가입 처리
	public void memberJoin(MemberVO vo);
	
	// 이메일 인증 처리
	public int emailSendCode(String email);

}
