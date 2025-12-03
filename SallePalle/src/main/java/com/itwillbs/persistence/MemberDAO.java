package com.itwillbs.persistence;

import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberHistoryVO;
import com.itwillbs.domain.MemberVO;

public interface MemberDAO {
	
	// 회원 정보 가져오기
	public MemberVO selectOne(String userid);

	// 회원 가입 처리
	public void insertMember(MemberVO vo);

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


}
