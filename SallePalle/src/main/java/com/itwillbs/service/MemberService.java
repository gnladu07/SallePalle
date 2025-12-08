package com.itwillbs.service;

import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.domain.MemberVO;

public interface MemberService {
	
	// 회원 정보 가져오기
	public MemberVO selectOne(String userid);

	// 회원 가입 처리
	public void memberJoin(MemberVO vo);
	
	// 아이디 중복 체크 
	public boolean isUseridExists(String userid);
	
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

	// 회원탈퇴 - 비밀번호 검증
	public boolean checkPassword(String userid, String userpw);

	// 회원탈퇴
	public void deactivateMember(String userid);

	// 아이디 찾기
	public String findUseridByPassword(String inputPw);

	// 비밀번호 찾기 - 링크 발송 요청
	public boolean sendResetLink(String userid, String email);

	// 비밀번호 찾기 - 링크 클릭 시 비밀번호 재설정 페이지로 이동
	public boolean validateToken(String token);

	// 비밀번호 찾기 - 비밀번호 실제 변경
	public boolean resetPassword(String token, String newPw);

	// 네이버 로그인
	public MemberVO selectNaverLogin(String naver_id);


}
