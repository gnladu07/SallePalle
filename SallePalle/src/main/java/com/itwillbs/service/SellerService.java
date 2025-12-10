package com.itwillbs.service;

import com.itwillbs.domain.SellerRequestVO;

public interface SellerService {

	// 판매 권한 신청 생성
	public void createRequest(int member_id);
	
	// 요청 상세 조회
	public SellerRequestVO getRequest(int request_id);
	
	// 요청 상태 변경(W, A, R)
	public void updateRequestStatus(int request_id, String status);
	
}
