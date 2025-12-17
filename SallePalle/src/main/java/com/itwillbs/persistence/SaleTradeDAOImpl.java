package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.SaleTradeVO;

@Repository
public class SaleTradeDAOImpl implements SaleTradeDAO {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SaleTradeDAOImpl.class);

	private static final String NAMESPACE 
		= "com.itwillbs.mapper.SaleTradeMapper.";

	@Inject private SqlSession sqlSession;

	@Override
	public List<SaleTradeVO> selectSaleTradeList(
	        String type, String keyword) {

	    log.info(" SaleTradeDAOImpl: selectSaleTradeList() 실행!");

	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("type", type);
	    paramMap.put("keyword", keyword);

	    log.info(" SaleTradeDAOImpl: selectSaleTradeList() 끝!");
	    return sqlSession.selectList(
	            NAMESPACE + "selectSaleTradeList", paramMap);
	}

}
