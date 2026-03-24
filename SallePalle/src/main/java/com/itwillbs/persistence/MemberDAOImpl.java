package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberHistoryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.PageVO;
import com.itwillbs.domain.PasswordResetTokenVO;
import com.itwillbs.domain.PaymentHistoryVO;
import com.itwillbs.domain.TradeHistoryViewVO;

@Repository
public class MemberDAOImpl implements MemberDAO {
		
	private static final Logger logger 
		= LoggerFactory.getLogger(MemberDAOImpl.class);

	private static final String NAMESPACE
		= "com.itwillbs.mapper.MemberMapper.";
	
	@Inject private SqlSession sqlSession;

	@Override
	public MemberVO selectOne(String userid) {
		logger.info(" MemberDAOImpl: selectOne() 실행! ");
		
		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "selectOne", userid);
		
		logger.info(" MemberDAOImpl: selectOne() 끝! ");
		return resultVO;
	}

	@Override
	public void insertMember(MemberVO vo) {
		logger.info(" MemberDAOImpl: insertMember() 실행!");
		
		sqlSession.insert(NAMESPACE + "insertMember", vo);
		
		logger.info(" MemberDAOImpl: insertMember() 끝!");
	}
	
	@Override
	public int countUserid(String userid) {
	    logger.info(" MemberDAOImpl: countUserid() 실행!");

	    int result = sqlSession.selectOne(NAMESPACE + "countUserid", userid);

	    logger.info(" MemberDAOImpl: countUserid() 결과 = " + result);
	    return result;
	}

	@Override
	public void insertAuth(MemberAuthVO vo) {
		logger.info(" MemberDAOImpl: insertAuth() 실행!");
		
		sqlSession.insert(NAMESPACE + "insertAuth", vo);
		
		logger.info(" MemberDAOImpl: insertAuth() 실행!");
	}

	@Override
	public void updateProfileImg(MemberVO vo) {
		logger.info(" MemberDAOImpl: updateProfileImg() 실행! ");
		
		sqlSession.update(NAMESPACE + "updateProfileImg", vo);
		
		logger.info(" MemberDAOImpl: updateProfileImg() 끝! ");
	}

	@Override
	public void updateProfileToDefault(String userid) {
		logger.info(" MemberDAOImpl: updateProfileToDefault() 실행! ");
		
		sqlSession.update(NAMESPACE + "updateProfileToDefault", userid);
		
		logger.info(" MemberDAOImpl: updateProfileToDefault() 끝! ");
	}

	@Override
	public void updateMember(MemberVO vo) {
		logger.info(" MemberDAOImpl: updateMember() 실행! ");
		
		sqlSession.update(NAMESPACE + "updateMember", vo);
		
		logger.info(" MemberDAOImpl: updateMember() 끝! ");
	}

	@Override
	public void insertMemberHistory(MemberHistoryVO memberHistoryVO) {
		logger.info(" MemberDAOImpl: insertMemberHistory() 실행! ");
		
		sqlSession.insert(NAMESPACE + "insertMemberHistory", memberHistoryVO);
		
		logger.info(" MemberDAOImpl: insertMemberHistory() 끝! ");
	}

	@Override
	public void rollbackMemberInfo(String userid) {
		logger.info(" MemberDAOImpl: rollbackMemberInfo() 실행! ");
		
		sqlSession.update(NAMESPACE + "rollbackMemberInfo", userid);
		
		logger.info(" MemberDAOImpl: rollbackMemberInfo() 끝! ");
	}

	@Override
	public void deactivateMember(String userid) {
		logger.info(" MemberDAOImpl: deactivateMember() 실행! ");
		
		sqlSession.update(NAMESPACE +"deactivateMember", userid);
		
		logger.info(" MemberDAOImpl: deactivateMember() 끝! ");
		
	}

	@Override
	public List<MemberVO> findAllMembersForIdSearch() {
		logger.info(" MemberDAOImpl: findAllMembersForIdSearch() 실행! ");
		
		List<MemberVO> resultVO = sqlSession.selectList(NAMESPACE + "findAllMembersForIdSearch");
		
		logger.info(" MemberDAOImpl: findAllMembersForIdSearch() 끝! ");
		return resultVO;
	}

	@Override
	public MemberVO findMemberByIdAndEmail(MemberVO input) {
		logger.info(" MemberDAOImpl: findMemberByIdAndEmail() 실행! ");
		
		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "findMemberByIdAndEmail", input);
		
		logger.info(" MemberDAOImpl: findMemberByIdAndEmail() 끝! ");
		return resultVO;
	}

	@Override
	public void insertResetToken(PasswordResetTokenVO tokenVO) {
		logger.info(" MemberDAOImpl: insertResetToken() 실행! ");
		
		sqlSession.insert(NAMESPACE + "insertResetToken", tokenVO);
		
		logger.info(" MemberDAOImpl: insertResetToken() 끝! ");
	}

	@Override
	public PasswordResetTokenVO findByToken(String token) {
		logger.info(" MemberDAOImpl: PasswordResetTokenVO() 실행! ");
		
		PasswordResetTokenVO resultVO = sqlSession.selectOne(NAMESPACE + "findByToken", token);
		
		logger.info(" MemberDAOImpl: PasswordResetTokenVO() 끝! ");
		return resultVO;
	}

	@Override
	public void updatePassword(MemberVO member) {
		logger.info(" MemberDAOImpl: updatePassword() 실행! ");
		
		sqlSession.update(NAMESPACE + "updatePassword", member);
		
		logger.info(" MemberDAOImpl: updatePassword() 끝! ");
	}

	@Override
	public void deleteToken(String token) {
		logger.info(" MemberDAOImpl: deleteToken() 실행! ");
		
		sqlSession.delete(NAMESPACE + "deleteToken", token);
		
		logger.info(" MemberDAOImpl: deleteToken() 끝! ");
	}

	@Override
	public MemberVO selectNaverLogin(String provider_id) {
		logger.info(" MemberDAOImpl: selectNaverLogin() 실행! ");
		
		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "selectNaverLogin" , provider_id);
		
		logger.info(" MemberDAOImpl: selectNaverLogin() 끝! ");
		return resultVO;
	}

	@Override
	public void updateSellerStatus(int member_id, String status) {
		logger.info(" MemberDAOImpl: updateSellerStatus() 실행! ");
		
		Map<String, Object> map = new HashMap<>();
        map.put("member_id", member_id);
        map.put("status", status);

        sqlSession.update(NAMESPACE + "updateSellerStatus", map);		
		logger.info(" MemberDAOImpl: updateSellerStatus() 끝! ");
	}

	@Override
	public void setNotifyFlag(Map<String, Object> map) {
		logger.info(" MemberDAOImpl: setNotifyFlag() 실행! ");
		
		sqlSession.update(NAMESPACE + "setNotifyFlag", map);
		
		logger.info(" MemberDAOImpl: setNotifyFlag() 끝! ");
	}

	@Override
	public void updateNotifyFlag(Map<String, Object> map) {
		logger.info(" MemberDAOImpl: updateNotifyFlag() 실행! ");
		
		sqlSession.update(NAMESPACE + "updateNotifyFlag", map);
		
		logger.info(" MemberDAOImpl: updateNotifyFlag() 끝! ");
	}

	@Override
	public List<MemberVO> getMemberList() {
		logger.info(" MemberDAOImpl: getMemberList() 실행! ");
		
		List<MemberVO> resultVO = sqlSession.selectList(NAMESPACE + "getMemberList");
		
		logger.info(" MemberDAOImpl: getMemberList() 끝! ");
		return resultVO;
	}

	@Override
	public void disableMember(int member_id) {
		logger.info(" MemberDAOImpl: disableMember() 실행! ");
		
		sqlSession.update(NAMESPACE + "disableMember", member_id);
		
		logger.info(" MemberDAOImpl: disableMember() 끝! ");
	}

	@Override
	public void deleteMember(int member_id) {
		logger.info(" MemberDAOImpl: deleteMember() 실행! ");
		
		sqlSession.delete(NAMESPACE + "deleteMember", member_id);
		
		logger.info(" MemberDAOImpl: deleteMember() 끝! ");
	}

	@Override
	public void enableMember(int member_id) {
		logger.info(" MemberDAOImpl: enableMember() 실행! ");
		
		sqlSession.update(NAMESPACE + "enableMember", member_id);
		
		logger.info(" MemberDAOImpl: enableMember() 끝! ");		
	}

	@Override
	public MemberVO getMemberById(int member_id) {
		logger.info(" MemberDAOImpl: getMemberById() 실행! ");
		
		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "getMemberById", member_id); 
		
		logger.info(" MemberDAOImpl: getMemberById() 끝! ");
		return resultVO;
	}

	@Override
	public void updateOpenBankingToken(MemberVO vo) {
		logger.info(" MemberDAOImpl: updateOpenBankingToken() 실행! ");
		
		sqlSession.update(NAMESPACE + "updateOpenBankingToken", vo);
		
		logger.info(" MemberDAOImpl: updateOpenBankingToken() 끝! ");
		
	}

	@Override
	public List<PaymentHistoryVO> selectHistoryLimit50(int member_id) {
		logger.info(" MemberDAOImpl: selectHistoryLimit50() 실행! ");
	    logger.info(" MemberDAOImpl: selectHistoryLimit50() 끝! ");
	    return sqlSession.selectList(NAMESPACE + "selectHistoryLimit50", member_id);
	}

	@Override
	public List<TradeHistoryViewVO> selectSellHistory(int member_id) {
	    logger.info(" MemberDAOImpl: selectSellHistory() 실행! ");
	    logger.info(" MemberDAOImpl: selectSellHistory() 끝! ");
	    return sqlSession.selectList(NAMESPACE + "selectSellHistory", member_id);
	}

}
