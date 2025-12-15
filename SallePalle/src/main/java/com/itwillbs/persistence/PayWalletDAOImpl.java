package com.itwillbs.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.PayWalletVO;

@Repository
public class PayWalletDAOImpl implements PayWalletDAO {
	
	private static final Logger log 
		= LoggerFactory.getLogger(PayWalletDAOImpl.class);
	
	private static final String NAMESPACE 
		= "com.itwillbs.mapper.PayWalletMapper.";
	
	@Inject private SqlSession sql;

	@Override
	public PayWalletVO getWallet(int member_id) {
		log.info(" PayWalletDAOImpl: PayWalletDAOImpl()실행! ");
		log.info(" PayWalletDAOImpl: PayWalletDAOImpl()끝! ");
		return sql.selectOne(NAMESPACE + "getWallet", member_id);
	}

	@Override
	public void createWallet(int member_id) {
		log.info(" PayWalletDAOImpl: createWallet()실행! ");
		
		sql.insert(NAMESPACE + "createWallet", member_id);
		
		log.info(" PayWalletDAOImpl: createWallet()끝! ");
		
	}

	@Override
	public void updateBalance(PayWalletVO vo) {
		log.info(" PayWalletDAOImpl: updateBalance()실행! ");
		
		sql.update(NAMESPACE + "updateBalance", vo);
		
		log.info(" PayWalletDAOImpl: updateBalance()끝! ");
		
	}

}
