package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;

public interface AdminService {

	public List<MemberVO> getMemberListPaged(Criteria cri);

	public int getTotalCount();
	public int getSellerCount();

	public int getTotalCountFiltered(Criteria cri);

}
