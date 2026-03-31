package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;

public interface AdminService {

	// 전체 회원 목록 조회
	public List<MemberVO> getMemberListPaged(Criteria cri);

	// 전체 회원 수 카운트
	public int getTotalCount();
	
	// 판매 권한 대기중 회원 수 카운트
	public int getSellerCount();

	// 필터링된 회원 수 카운트
	public int getTotalCountFiltered(Criteria cri);
	
	// 전체 중고 물품 수
    public int getTotalProductCount() throws Exception;
    
    // 거래 진행방(활성 채팅방) 수
    public int getActiveChatRoomCount() throws Exception;
    
    // 물품 관리 리스트
    public List<Map<String, Object>> getAdminGoodsList(Map<String, Object> paramMap) throws Exception;
    
    // 물품 총 개수 (페이징용)
    public int getTotalGoodsCount(Map<String, Object> paramMap) throws Exception;
    
    // 물품 상태 변경 및 메일 발송용
    public void adminUpdateGoodsStatus(int trade_id, String actionType, String reason, String seller_email) throws Exception;

}
