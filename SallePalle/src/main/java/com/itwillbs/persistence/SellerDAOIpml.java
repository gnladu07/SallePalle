package com.itwillbs.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.SellerRequestVO;

@Repository
public class SellerDAOIpml implements SellerDAO {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SellerDAOIpml.class);

	private static final String NAMESPACE = "com.itwillbs.mapper.SellerMapper.";

	@Inject private SqlSession sqlSession;
	
	@Override
	public void insertSellerRequest(int member_id) {
		log.info(" SellerDAOIpml: insertSellerRequest()실행! ");
		
		sqlSession.insert(NAMESPACE + "insertSellerRequest", member_id);
		
		log.info(" SellerDAOIpml: insertSellerRequest()끝! ");
	}

	@Override
	public SellerRequestVO selectSellerRequest(int request_id) {
		log.info(" SellerDAOIpml: selectSellerRequest()실행! ");
		
		SellerRequestVO resultVO = sqlSession.selectOne(NAMESPACE + "selectSellerRequest", request_id);
		
		log.info(" SellerDAOIpml: selectSellerRequest()끝! ");
		return resultVO;
	}

	@Override
	public void updateSellerRequestStatus(int request_id, String status) {
		log.info(" SellerDAOIpml: updateSellerRequestStatus()실행! ");
		
		SellerRequestVO vo = new SellerRequestVO();
		vo.setRequest_id(request_id);
		vo.setStatus(status);
		
		sqlSession.update(NAMESPACE + "updateSellerRequestStatus", vo);
		log.info(" SellerDAOIpml: updateSellerRequestStatus()끝! ");
	}

}
