package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.SaleTradeVO;

public interface SaleTradeService {
	
	// 중고 판매글 리스트 조회
	public List<SaleTradeVO> getSaleTradeList(String type, String keyword, Integer itemCtgId);

	// 판매글 상세 조회
	public SaleTradeVO getSaleTradeDetail(int tradeId);

	// 판매자의 다른 상품
	public List<SaleTradeVO> getOtherSaleTradeBySeller(Integer seller_id, int tradeId);

	// 중고 판매글 추천 처리 - ajax
	public int recommendTrade(int tradeId, String userid);

	// 중고 제품 구매 처리
	public void buyTrade(int trade_id, String name, boolean payPoint, boolean payMileage, String mileageType, Integer useMileage);

	// 중고 상품 등록(글작성)
	public void writeSaleTrade(SaleTradeVO vo);


}
