package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;

@Repository
public class AdminDAOImpl implements AdminDAO {
		
	private static final Logger log 
		= LoggerFactory.getLogger(AdminDAOImpl.class);

	private static final String NAMESPACE
		= "com.itwillbs.mapper.AdminMapper.";
	
	@Inject private SqlSession sqlSession;

	@Override
	public List<MemberVO> getMemberListPaged(Criteria cri) {
		log.debug(" AdminDAOImpl: getMemberListPaged() 실행! ");
		
		List<MemberVO> resultVO = sqlSession.selectList(NAMESPACE + "getMemberListPaged", cri);
		
		log.debug(" AdminDAOImpl: getMemberListPaged() 끝! ");
		return resultVO;
	}

	@Override
	public int getTotalCount() {
		log.debug(" AdminDAOImpl: getTotalCount() 실행! ");
		
		int resultVO = sqlSession.selectOne(NAMESPACE + "getTotalCount");
		
		log.debug(" AdminDAOImpl: getTotalCount() 끝! ");
		return resultVO;
	}
	
	@Override
	public int getSellerCount() {
		log.debug(" AdminDAOImpl: getSellerCount() 실행! ");
		
		int resultVO = sqlSession.selectOne(NAMESPACE + "getSellerCount");
		
		log.debug(" AdminDAOImpl: getSellerCount() 끝! ");
		return resultVO;
	}
	
	@Override
	public int getTotalCountFiltered(Criteria cri) {
		log.debug(" AdminDAOImpl: getTotalCountFiltered() 실행! ");
		
		int resultVO = sqlSession.selectOne(NAMESPACE + "getTotalCountFiltered", cri);
		
		log.debug(" AdminDAOImpl: getTotalCountFiltered() 끝! ");
		return resultVO;
	}

	@Override
	public int getTotalProductCount() throws Exception {
		log.debug(" AdminDAOImpl: getTotalProductCount() 실행! ");
		log.debug(" AdminDAOImpl: getTotalProductCount() 끝! ");
		return sqlSession.selectOne(NAMESPACE + "getTotalProductCount");
	}

	@Override
	public int getActiveChatRoomCount() throws Exception {
		log.debug(" AdminDAOImpl: getActiveChatRoomCount() 실행! ");
		log.debug(" AdminDAOImpl: getActiveChatRoomCount() 끝! ");
		return sqlSession.selectOne(NAMESPACE + "getActiveChatRoomCount");
	}

	@Override
    public List<Map<String, Object>> getAdminGoodsList(Map<String, Object> paramMap) throws Exception {
		log.debug(" AdminDAOImpl: getAdminGoodsList() 실행! ");
		log.debug(" AdminDAOImpl: getAdminGoodsList() 끝! ");
        return sqlSession.selectList(NAMESPACE + "getAdminGoodsList", paramMap);
    }

    @Override
    public void adminUpdateGoodsStatus(Map<String, Object> params) throws Exception {
    	log.debug(" AdminDAOImpl: adminUpdateGoodsStatus() 실행! ");
    	
        sqlSession.update(NAMESPACE + "adminUpdateGoodsStatus", params);
        
        log.debug(" AdminDAOImpl: adminUpdateGoodsStatus() 끝! ");
    }


}
