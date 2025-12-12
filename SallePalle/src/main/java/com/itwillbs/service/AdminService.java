package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.MemberVO;

public interface AdminService {

	// 정렬 기준에 따라 회원 리스트 출력
	List<MemberVO> getSortedMembers(String sort);

}
