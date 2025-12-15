package com.itwillbs.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.MileageWalletVO;

@Repository
public class MileageWalletDAOImpl implements MileageWalletDAO {
		
	private static final Logger log 
		= LoggerFactory.getLogger(MileageWalletDAOImpl.class);
	
	private static final String NAMESPACE 
		= "com.itwillbs.mapper.MileageWalletMapper.";
	
	@Inject private SqlSession sql;

	@Override
	public MileageWalletVO getWallet(int member_id) {
		log.info(" MileageWalletDAOImpl: getWallet()실행! ");
		log.info(" MileageWalletDAOImpl: getWallet()끝! ");
		return sql.selectOne(NAMESPACE + "getWallet", member_id);
	}

	@Override
	public void createWallet(int member_id) {
		log.info(" MileageWalletDAOImpl: createWallet()실행! ");
		
		sql.insert(NAMESPACE + "createWallet", member_id);
		
		log.info(" MileageWalletDAOImpl: createWallet()끝! ");
	}

	@Override
	public void updateMileage(MileageWalletVO vo) {
		log.info(" MileageWalletDAOImpl: updateMileage()실행! ");
		
		sql.update(NAMESPACE + "updateMileage", vo);
		
		log.info(" MileageWalletDAOImpl: updateMileage()끝! ");
	}
	

}
