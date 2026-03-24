package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.SellerRequestVO;

public interface SellerDAO {

	// 판매 권한 신청 생성
	public void insertSellerRequest(int member_id);

	// 요청 상세 조회
	public SellerRequestVO selectSellerRequest(int request_id);

	// 요청 상태 변경(W, A, R)
	public void updateSellerRequestStatus(int request_id, String status);

	// 요청 리스트
	public List<SellerRequestVO> getWaitingRequests();

	// 요청 승인 처리
	public void approveRequest(int request_id);
	
	// 요청 거절 처리
	public void rejectRequest(int seller_req_id);

}
