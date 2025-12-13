package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;

public interface AdminDAO {

	// 정렬 기준에 따라 회원 리스트 출력
//	List<MemberVO> getSortedMembers(String sort);
	List<MemberVO> getMemberListPaged(Criteria cri);

//	int getTotalCount();

	int getTotalCountFiltered(Criteria cri);

}
