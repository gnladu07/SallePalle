package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;

public interface AdminService {

	public List<MemberVO> getMemberListPaged(Criteria cri);

	public int getTotalCount();
	public int getSellerCount();

	public int getTotalCountFiltered(Criteria cri);
	
	// 전체 중고 물품 수
    public int getTotalProductCount() throws Exception;
    
    // 거래 진행방(활성 채팅방) 수
    public int getActiveChatRoomCount() throws Exception;
    
    // 물품 관리 리스트
    public List<Map<String, Object>> getAdminGoodsList() throws Exception;
    
    // 물품 상태 변경 및 메일 발송용
    public void adminUpdateGoodsStatus(int trade_id, String actionType, String reason, String seller_email) throws Exception;

}
