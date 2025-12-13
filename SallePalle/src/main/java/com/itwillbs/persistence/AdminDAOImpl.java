package com.itwillbs.persistence;

import java.util.List;

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
	
//	@Override
//	public List<MemberVO> getSortedMembers(String sort) {
//		log.info(" AdminDAOImpl: getSortedMembers() 실행! ");
//		
//		List<MemberVO> resultVO = sqlSession.selectList(NAMESPACE + "getSortedMembers", sort);
//		
//		log.info(" AdminDAOImpl: getSortedMembers() 끝! ");
//		return resultVO;
//	}

	@Override
	public List<MemberVO> getMemberListPaged(Criteria cri) {
		log.info(" AdminDAOImpl: getMemberListPaged() 실행! ");
		
		List<MemberVO> resultVO = sqlSession.selectList(NAMESPACE + "getMemberListPaged", cri);
		
		log.info(" AdminDAOImpl: getMemberListPaged() 끝! ");
		return resultVO;
	}

//	@Override
//	public int getTotalCount() {
//		log.info(" AdminDAOImpl: getTotalCount() 실행! ");
//		
//		int resultVO = sqlSession.selectOne(NAMESPACE + "getTotalCount");
//		
//		log.info(" AdminDAOImpl: getTotalCount() 끝! ");
//		return resultVO;
//	}
	
	@Override
	public int getTotalCountFiltered(Criteria cri) {
		log.info(" AdminDAOImpl: getTotalCountFiltered() 실행! ");
		
		int resultVO = sqlSession.selectOne(NAMESPACE + "getTotalCountFiltered", cri);
		
		log.info(" AdminDAOImpl: getTotalCountFiltered() 끝! ");
		return resultVO;
	}




}
