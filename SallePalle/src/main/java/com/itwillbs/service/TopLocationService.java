package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.TopLocation;

public interface TopLocationService {

	// 지역 목록 조회
	public List<TopLocation> getTopLocationList();

}
