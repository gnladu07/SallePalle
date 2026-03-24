package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;

public interface AdminDAO {

	List<MemberVO> getMemberListPaged(Criteria cri);

	int getTotalCount();
	int getSellerCount();

	int getTotalCountFiltered(Criteria cri);

}
