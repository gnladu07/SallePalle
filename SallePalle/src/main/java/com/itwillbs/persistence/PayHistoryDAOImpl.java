package com.itwillbs.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.PayHistoryVO;

@Repository
public class PayHistoryDAOImpl implements PayHistoryDAO {
	
	private static final Logger log 
		= LoggerFactory.getLogger(PayHistoryDAOImpl.class);
	
	private static final String NAMESPACE 
		= "com.itwillbs.mapper.PayHistoryMapper.";
	
	@Inject private SqlSession sql;

	@Override
	public void insertHistory(PayHistoryVO vo) {
		log.info(" PayHistoryDAOImpl: PayWalletDAOImpl()실행! ");
		
		sql.insert(NAMESPACE + "insertHistory", vo);
		
		log.info(" PayHistoryDAOImpl: PayWalletDAOImpl()끝! ");
	}

}
