package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.ItemCategoryVO;

public interface ItemCategoryDAO {
	
	// 사용 가능한 상품 종류 목록
    public List<ItemCategoryVO> selectItemCategoryList();

}
