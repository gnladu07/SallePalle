package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.SellerRequestVO;

public interface SellerService {

	// 판매 권한 신청 생성
	public void createRequest(int member_id);
	
	// 요청 상세 조회
	public SellerRequestVO getRequest(int request_id);
	
	// 요청 상태 변경(W, A, R)
	public void updateRequestStatus(int request_id, String status);

	// 판매 권한 신청 리스트 조회 (검색/정렬/페이징)
    public List<SellerRequestVO> getSellerRequestListPaged(Map<String, Object> paramMap) throws Exception;
    
    // 판매 권한 총 신청 개수 (페이징용)
    public int getTotalSellerRequestCount(Map<String, Object> paramMap) throws Exception;

	// 요청 승인 처리
	public void approveRequest(int request_id, int member_id);
	
	// 요청 거절 처리
	public void rejectRequest(int request_id, int member_id);
	
}
