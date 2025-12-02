package com.itwillbs.persistence;

import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberVO;

public interface MemberDAO {
	
	public MemberVO selectOne(String userid);

	// 회원 가입 처리
	public void insertMember(MemberVO vo);

	// 회원 권한 부여
	public void insertAuth(MemberAuthVO vo);

}
