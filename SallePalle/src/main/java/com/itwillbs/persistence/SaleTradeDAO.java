package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.SaleTradeVO;

public interface SaleTradeDAO {
	
	// 중고 판매글 리스트 조회
	public List<SaleTradeVO> selectSaleTradeList();

}
