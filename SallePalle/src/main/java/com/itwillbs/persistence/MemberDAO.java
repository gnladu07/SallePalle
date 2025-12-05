package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberHistoryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.PasswordResetTokenVO;

public interface MemberDAO {
	
	// 회원 정보 가져오기
	public MemberVO selectOne(String userid);

	// 회원 가입 처리
	public void insertMember(MemberVO vo);
	
	// 아이디 중복 체크 
	public int countUserid(String userid);

	// 회원 권한 부여
	public void insertAuth(MemberAuthVO vo);

	// 회원 프로필 사진 수정
	public void updateProfileImg(MemberVO vo);

	// 기본 이미지로 초기화
	public void updateProfileToDefault(String userid);

	// 회원 개인정보 수정
	public void updateMember(MemberVO vo);
	public void insertMemberHistory(MemberHistoryVO memberHistoryVO);
	public void rollbackMemberInfo(String userid);

	// 회원탈퇴
	public void deactivateMember(String userid);

	// 아이디 찾기
	public List<MemberVO> findAllMembersForIdSearch();

	// 비밀번호 찾기
	public MemberVO findMemberByIdAndEmail(MemberVO input);
	public void insertResetToken(PasswordResetTokenVO tokenVO);	
	public PasswordResetTokenVO findByToken(String token);
	public void updatePassword(MemberVO member);
	public void deleteToken(String token);

	// 소셜 회원 가입 - 네이버
	public MemberVO findByProviderId(String providerId);
	public void insertSocialMember(MemberVO vo);



}
