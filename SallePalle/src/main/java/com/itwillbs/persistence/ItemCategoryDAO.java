package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.ItemCategoryVO;

public interface ItemCategoryDAO {
	
	// 전체 중고 물품 카테고리 목록 조회
    public List<ItemCategoryVO> selectItemCategoryList();

}
