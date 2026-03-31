package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

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
		log.debug(" SellerDAOIpml: insertSellerRequest() 실행! ");
		
		sqlSession.insert(NAMESPACE + "insertSellerRequest", member_id);
		
		log.debug(" SellerDAOIpml: insertSellerRequest() 끝! ");
	}

	@Override
	public SellerRequestVO selectSellerRequest(int request_id) {
		log.debug(" SellerDAOIpml: selectSellerRequest() 실행! ");
		
		SellerRequestVO resultVO = sqlSession.selectOne(NAMESPACE + "selectSellerRequest", request_id);
		
		log.debug(" SellerDAOIpml: selectSellerRequest() 끝! ");
		return resultVO;
	}

	@Override
	public void updateSellerRequestStatus(int request_id, String status) {
		log.debug(" SellerDAOIpml: updateSellerRequestStatus() 실행! ");
		
		SellerRequestVO vo = new SellerRequestVO();
		vo.setRequest_id(request_id);
		vo.setStatus(status);
		
		sqlSession.update(NAMESPACE + "updateSellerRequestStatus", vo);
		log.debug(" SellerDAOIpml: updateSellerRequestStatus() 끝! ");
	}

	@Override
    public List<SellerRequestVO> getSellerRequestListPaged(Map<String, Object> paramMap) throws Exception {
		log.debug(" SellerDAOIpml: getSellerRequestListPaged() 실행! ");
		log.debug(" SellerDAOIpml: getSellerRequestListPaged() 끝! ");
        return sqlSession.selectList(NAMESPACE + "getSellerRequestListPaged", paramMap);
    }

    @Override
    public int getTotalSellerRequestCount(Map<String, Object> paramMap) throws Exception {
    	log.debug(" SellerDAOIpml: getTotalSellerRequestCount() 실행! ");
		log.debug(" SellerDAOIpml: getTotalSellerRequestCount() 끝! ");
        return sqlSession.selectOne(NAMESPACE + "getTotalSellerRequestCount", paramMap);
    }

	@Override
    public void approveRequest(int request_id) {
        log.debug(" SellerDAOIpml: approveRequest() 실행!");
        
        sqlSession.update(NAMESPACE + "approveRequest", request_id);
        
        log.debug(" SellerDAOIpml: approveRequest() 끝!");
    }
	
	@Override
    public void rejectRequest(int request_id) {
        log.debug(" SellerDAOIpml: rejectRequest() 실행!");
        
        sqlSession.update(NAMESPACE + "rejectRequest", request_id);
        
        log.debug(" SellerDAOIpml: rejectRequest() 끝!");
    }

}
