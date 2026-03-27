package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;

public interface AdminDAO {

	List<MemberVO> getMemberListPaged(Criteria cri);

	public int getTotalCount();
	public int getSellerCount();

	public int getTotalCountFiltered(Criteria cri);
	
	// 전체 중고 물품 수
    public int getTotalProductCount() throws Exception;
    
    // 거래 진행방(활성 채팅방) 수
    public int getActiveChatRoomCount() throws Exception;
    
    // 전체 물품 리스트 조회
    public List<Map<String, Object>> getAdminGoodsList(Map<String, Object> paramMap) throws Exception;
    
    // 물품 상태 강제 변경
    public void adminUpdateGoodsStatus(Map<String, Object> params) throws Exception;

}
