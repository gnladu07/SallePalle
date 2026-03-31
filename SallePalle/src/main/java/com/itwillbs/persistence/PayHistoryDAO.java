package com.itwillbs.persistence;

import com.itwillbs.domain.PayHistoryVO;

public interface PayHistoryDAO {
	
	// 살래 포인트 충전, 결제, 환전 내역 저장
	public void insertHistory(PayHistoryVO vo);

}
