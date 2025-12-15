package com.itwillbs.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.MileageHistoryVO;

@Repository
public class MileageHistoryDAOImpl implements MileageHistoryDAO {
	
	private static final Logger log 
		= LoggerFactory.getLogger(MileageHistoryDAOImpl.class);
	
	private static final String NAMESPACE 
		= "com.itwillbs.mapper.MileageHistoryMapper.";
	
	@Inject private SqlSession sql;

	@Override
	public void insertHistory(MileageHistoryVO vo) {
		log.info(" MileageHistoryDAOImpl: insertHistory()실행! ");
		
		sql.insert(NAMESPACE + "insertHistory", vo);
		
		log.info(" MileageHistoryDAOImpl: insertHistory()끝! ");
	}

}
