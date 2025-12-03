package com.itwillbs.service;

import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.domain.MemberVO;

public interface MemberService {
	
	// 회원 정보 가져오기
	public MemberVO selectOne(String userid);

	// 회원 가입 처리
	public void memberJoin(MemberVO vo);
	
	// 이메일 인증 처리
	public int emailSendCode(String email);

	// 회원 프로필 사진 수정
	public void changeProfileImage(String userid, MultipartFile file);

	// 프로필 사진 기본 이미지로 초기화
	public void resetProfileImage(String userid);

	// 회원 개인정보 수정
	public void updateMemberWithHistory(MemberVO vo);
	
	// 개인정보 초기화
	public void rollbackMemberInfo(String userid);

}
