package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.SaleTradeVO;

public interface SaleTradeService {
	
	// 중고 판매글 리스트 조회
	public List<SaleTradeVO> getSaleTradeList(String type, String keyword);

}
