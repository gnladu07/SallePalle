package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.ItemCategoryVO;

@Repository
public class ItemCategoryDAOImpl implements ItemCategoryDAO {
	
	private final static Logger log 
		= LoggerFactory.getLogger(ItemCategoryDAOImpl.class);
	
	private static final String NAMESPACE =
	        "com.itwillbs.mapper.ItemCategoryMapper.";
	
	@Inject private SqlSession sqlSession;

	@Override
	public List<ItemCategoryVO> selectItemCategoryList() {
		log.debug(" ItemCategoryDAOImpl: selectItemCategoryList()실행! ");
		log.debug(" ItemCategoryDAOImpl: selectItemCategoryList()끝! ");
		return sqlSession.selectList(NAMESPACE + "selectItemCategoryList");
	}

}
