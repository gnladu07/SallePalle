package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.TopLocation;

public interface TopLocationDAO {
	
	// 상품 등록 및 검색 필터에 사용될 메인 거래 지역 리스트 조회
	public List<TopLocation> selectListLocation();

}
