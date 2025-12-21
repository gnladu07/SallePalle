package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.ItemCategoryVO;

@Repository
public class ItemCategoryDAOImpl implements ItemCategoryDAO {
	
	private static final String NAMESPACE =
	        "com.itwillbs.mapper.ItemCategoryMapper.";
	
	@Inject private SqlSession sqlSession;

	@Override
	public List<ItemCategoryVO> selectItemCategoryList() {
		return sqlSession.selectList(NAMESPACE + "selectItemCategoryList");
	}

}
