package com.itwillbs.persistence;

import com.itwillbs.domain.SellerRequestVO;

public interface SellerDAO {

	// 판매 권한 신청 생성
	public void insertSellerRequest(int member_id);

	// 요청 상세 조회
	public SellerRequestVO selectSellerRequest(int request_id);

	// 요청 상태 변경(W, A, R)
	public void updateSellerRequestStatus(int request_id, String status);

}
