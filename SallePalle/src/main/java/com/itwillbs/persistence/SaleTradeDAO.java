package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.SaleTradeVO;

public interface SaleTradeDAO {
	
	// 중고 판매글 리스트 조회
	public List<SaleTradeVO> selectSaleTradeList(String type, String keyword, Integer itemCtgId);

	// 판매글 상세 조회
	public SaleTradeVO selectSaleTradeDetail(int tradeId);

	// 판매자의 다른 상품
	public List<SaleTradeVO> selectOtherSaleTradeBySeller(Integer seller_id, int tradeId);

	// 1. 중복 추천 체크
	public int existsRecommend(int tradeId, String userid);

	// 2. 추천 등록
	public void insertRecommend(int tradeId, String userid);

	// 3. 추천 수 증가
	public void increaseRecommendCnt(int tradeId);

	// 4. 최신 추천 수 조회
	public int selectRecommendCnt(int tradeId);



}
