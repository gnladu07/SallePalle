package com.itwillbs.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberVO;

@Repository
public class MemberDAOImpl implements MemberDAO {
		
	private static final Logger logger 
		= LoggerFactory.getLogger(MemberDAOImpl.class);

	private static final String NAMESPACE
		= "com.itwillbs.mapper.MemberMapper.";
	
	@Inject private SqlSession sqlSession;

	@Override
	public MemberVO selectOne(String userid) {
		logger.info(" selectOne()실행! ");
		
		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "selectOne", userid);
		
		logger.info(" selectOne()끝! ");
		return resultVO;
	}

	@Override
	public void insertMember(MemberVO vo) {
		sqlSession.insert(NAMESPACE + "insertMember", vo);
	}

	@Override
	public void insertAuth(MemberAuthVO vo) {
		sqlSession.insert(NAMESPACE + "insertAuth", vo);
	}



}
