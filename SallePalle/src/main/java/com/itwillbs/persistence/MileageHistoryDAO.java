package com.itwillbs.persistence;

import com.itwillbs.domain.MileageHistoryVO;

public interface MileageHistoryDAO {
	
	// 팔래 마일리지 적립 및 사용 내역 저장
	public void insertHistory(MileageHistoryVO vo);

}
