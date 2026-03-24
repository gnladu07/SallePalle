package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.ItemCategoryVO;

public interface ItemCategoryService {
	
	// 시스템에 등록된 전체 중고 물품 카테고리 목록 조회
	public List<ItemCategoryVO> getItemCategoryList();

}
