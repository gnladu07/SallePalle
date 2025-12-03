package com.itwillbs.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberHistoryVO;
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
		logger.info(" DAOImpl: selectOne() 실행! ");
		
		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "selectOne", userid);
		
		logger.info(" DAOImpl: selectOne() 끝! ");
		return resultVO;
	}

	@Override
	public void insertMember(MemberVO vo) {
		logger.info(" DAOImpl: insertMember() 실행!");
		
		sqlSession.insert(NAMESPACE + "insertMember", vo);
		
		logger.info(" DAOImpl: insertMember() 끝!");
	}

	@Override
	public void insertAuth(MemberAuthVO vo) {
		logger.info(" DAOImpl: insertAuth() 실행!");
		
		sqlSession.insert(NAMESPACE + "insertAuth", vo);
		
		logger.info(" DAOImpl: insertAuth() 실행!");
	}

	@Override
	public void updateProfileImg(MemberVO vo) {
		logger.info(" DAOImpl: updateProfileImg() 실행! ");
		
		sqlSession.update(NAMESPACE + "updateProfileImg", vo);
		
		logger.info(" DAOImpl: updateProfileImg() 끝! ");
	}

	@Override
	public void updateProfileToDefault(String userid) {
		logger.info(" DAOImpl: updateProfileToDefault() 실행! ");
		
		sqlSession.update(NAMESPACE + "updateProfileToDefault", userid);
		
		logger.info(" DAOImpl: updateProfileToDefault() 끝! ");
	}

	@Override
	public void updateMember(MemberVO vo) {
		logger.info(" DAOImpl: updateMember() 실행! ");
		
		sqlSession.update(NAMESPACE + "updateMember", vo);
		
		logger.info(" DAOImpl: updateMember() 끝! ");
	}

	@Override
	public void insertMemberHistory(MemberHistoryVO memberHistoryVO) {
		logger.info(" DAOImpl: insertMemberHistory() 실행! ");
		
		sqlSession.insert(NAMESPACE + "insertMemberHistory", memberHistoryVO);
		
		logger.info(" DAOImpl: insertMemberHistory() 끝! ");
	}

	@Override
	public void rollbackMemberInfo(String userid) {
		logger.info(" DAOImpl: rollbackMemberInfo() 실행! ");
		
		sqlSession.update(NAMESPACE + "rollbackMemberInfo", userid);
		
		logger.info(" DAOImpl: rollbackMemberInfo() 끝! ");
	}



}
