package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.ItemCategoryVO;
import com.itwillbs.persistence.ItemCategoryDAO;

@Service
public class ItemCategoryServiceImpl implements ItemCategoryService {
	
	private static final Logger log 
		= LoggerFactory.getLogger(FintechServiceImpl.class);
	
	@Inject private ItemCategoryDAO itemCategoryDAO;

	@Override
	public List<ItemCategoryVO> getItemCategoryList() {
		log.debug(" ItemCategoryServiceImpl: getItemCategoryList()실행! ");
		log.debug(" ItemCategoryServiceImpl: getItemCategoryList()끝! ");
		return itemCategoryDAO.selectItemCategoryList();
	}

}
