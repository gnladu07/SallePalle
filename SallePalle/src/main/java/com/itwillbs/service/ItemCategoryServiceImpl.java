package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.ItemCategoryVO;
import com.itwillbs.persistence.ItemCategoryDAO;

@Service
public class ItemCategoryServiceImpl implements ItemCategoryService {
	
	@Inject private ItemCategoryDAO itemCategoryDAO;

	@Override
	public List<ItemCategoryVO> getItemCategoryList() {
		return itemCategoryDAO.selectItemCategoryList();
	}

}
