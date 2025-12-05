package com.itwillbs.service;

import javax.servlet.http.HttpServletRequest;

import com.itwillbs.domain.MemberVO;

public interface SocialLoginService {
	
	// 프로필 JSON → MemberVO 변환
    public MemberVO parseProfile(String provider, String profileJson);

    // DB에서 provider_id 로 기존 회원 찾기
    public MemberVO findByProviderId(String providerId);

    // 소셜 신규 가입
    public void socialJoin(MemberVO vo);

    // 소셜 자동 로그인
    public void forceLogin(MemberVO vo, HttpServletRequest request);

}
