package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.TopLocation;

@Repository
public class TopLoactionDAOImpl implements TopLocationDAO {
	
	private static final Logger logger = LoggerFactory.getLogger(TopLoactionDAOImpl.class);

	private static final String NAMESPACE
		= "com.itwillbs.mapper.TopLocationMapper.";
	
	@Inject private SqlSession sqlSession;

	@Override
	public List<TopLocation> selectListLocation() {
		logger.info(" TopLoactionDAOImpl: selectListLocation() 실행! ");
		
		List<TopLocation> resultList = sqlSession.selectList(NAMESPACE + "selectListLocation");
		
		logger.info(" TopLoactionDAOImpl: selectListLocation() 끝! ");
		return resultList;
	}

}
