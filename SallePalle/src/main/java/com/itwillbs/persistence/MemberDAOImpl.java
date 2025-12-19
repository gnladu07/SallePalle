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
	public int countUserid(String userid) {
	    logger.info(" DAOImpl: countUserid() 실행!");

	    int result = sqlSession.selectOne(NAMESPACE + "countUserid", userid);

	    logger.info(" DAOImpl: countUserid() 결과 = " + result);
	    return result;
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

	@Override
	public void deactivateMember(String userid) {
		logger.info(" DAOImpl: deactivateMember() 실행! ");
		
		sqlSession.update(NAMESPACE +"deactivateMember", userid);
		
		logger.info(" DAOImpl: deactivateMember() 끝! ");
		
	}

	@Override
	public List<MemberVO> findAllMembersForIdSearch() {
		logger.info(" DAOImpl: findAllMembersForIdSearch() 실행! ");
		
		List<MemberVO> resultVO = sqlSession.selectList(NAMESPACE + "findAllMembersForIdSearch");
		
		logger.info(" DAOImpl: findAllMembersForIdSearch() 끝! ");
		return resultVO;
	}

	@Override
	public MemberVO findMemberByIdAndEmail(MemberVO input) {
		logger.info(" DAOImpl: findMemberByIdAndEmail() 실행! ");
		
		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "findMemberByIdAndEmail", input);
		
		logger.info(" DAOImpl: findMemberByIdAndEmail() 끝! ");
		return resultVO;
	}

	@Override
	public void insertResetToken(PasswordResetTokenVO tokenVO) {
		logger.info(" DAOImpl: insertResetToken() 실행! ");
		
		sqlSession.insert(NAMESPACE + "insertResetToken", tokenVO);
		
		logger.info(" DAOImpl: insertResetToken() 끝! ");
	}

	@Override
	public PasswordResetTokenVO findByToken(String token) {
		logger.info(" DAOImpl: PasswordResetTokenVO() 실행! ");
		
		PasswordResetTokenVO resultVO = sqlSession.selectOne(NAMESPACE + "findByToken", token);
		
		logger.info(" DAOImpl: PasswordResetTokenVO() 끝! ");
		return resultVO;
	}

	@Override
	public void updatePassword(MemberVO member) {
		logger.info(" DAOImpl: updatePassword() 실행! ");
		
		sqlSession.update(NAMESPACE + "updatePassword", member);
		
		logger.info(" DAOImpl: updatePassword() 끝! ");
	}

	@Override
	public void deleteToken(String token) {
		logger.info(" DAOImpl: deleteToken() 실행! ");
		
		sqlSession.delete(NAMESPACE + "deleteToken", token);
		
		logger.info(" DAOImpl: deleteToken() 끝! ");
	}

	@Override
	public MemberVO selectNaverLogin(String provider_id) {
		logger.info(" DAOImpl: selectNaverLogin() 실행! ");
		
		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "selectNaverLogin" , provider_id);
		
		logger.info(" DAOImpl: selectNaverLogin() 끝! ");
		return resultVO;
	}

	@Override
	public void updateSellerStatus(int member_id, String status) {
		logger.info(" DAOImpl: updateSellerStatus() 실행! ");
		
		Map<String, Object> map = new HashMap<>();
        map.put("member_id", member_id);
        map.put("status", status);

        sqlSession.update(NAMESPACE + "updateSellerStatus", map);		
		logger.info(" DAOImpl: updateSellerStatus() 끝! ");
	}

//	@Override
//    public MemberVO readByMemberId(int member_id) {
//		logger.info(" DAOImpl: readByMemberId() 실행! ");
//		logger.info(" DAOImpl: readByMemberId() 끝! ");
//        return sqlSession.selectOne(NAMESPACE + "readByMemberId", member_id);
//    }

	@Override
	public void setNotifyFlag(Map<String, Object> map) {
		logger.info(" DAOImpl: setNotifyFlag() 실행! ");
		sqlSession.update(NAMESPACE + "setNotifyFlag", map);
		logger.info(" DAOImpl: setNotifyFlag() 끝! ");
	}

	@Override
	public void updateNotifyFlag(Map<String, Object> map) {
		logger.info(" DAOImpl: updateNotifyFlag() 실행! ");
		sqlSession.update(NAMESPACE + "updateNotifyFlag", map);
		logger.info(" DAOImpl: updateNotifyFlag() 끝! ");
	}

	@Override
	public List<MemberVO> getMemberList() {
		logger.info(" DAOImpl: getMemberList() 실행! ");
		
		List<MemberVO> resultVO = sqlSession.selectList(NAMESPACE + "getMemberList");
		
		logger.info(" DAOImpl: getMemberList() 끝! ");
		return resultVO;
	}

	@Override
	public void disableMember(int member_id) {
		logger.info(" DAOImpl: disableMember() 실행! ");
		
		sqlSession.update(NAMESPACE + "disableMember", member_id);
		
		logger.info(" DAOImpl: disableMember() 끝! ");
	}

	@Override
	public void deleteMember(int member_id) {
		logger.info(" DAOImpl: deleteMember() 실행! ");
		
		sqlSession.delete(NAMESPACE + "deleteMember", member_id);
		
		logger.info(" DAOImpl: deleteMember() 끝! ");
	}

	@Override
	public void enableMember(int member_id) {
		logger.info(" DAOImpl: enableMember() 실행! ");
		
		sqlSession.update(NAMESPACE + "enableMember", member_id);
		
		logger.info(" DAOImpl: enableMember() 끝! ");		
	}

	@Override
	public MemberVO getMemberById(int member_id) {
		logger.info(" DAOImpl: getMemberById() 실행! ");
		
		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "getMemberById", member_id); 
		
		logger.info(" DAOImpl: getMemberById() 끝! ");
		return resultVO;
	}

	@Override
	public void updateOpenBankingToken(MemberVO vo) {
		logger.info(" DAOImpl: updateOpenBankingToken() 실행! ");
		
		sqlSession.update(NAMESPACE + "updateOpenBankingToken", vo);
		
		logger.info(" DAOImpl: updateOpenBankingToken() 끝! ");
		
	}

	@Override
	public List<PaymentHistoryVO> selectHistoryLimit50(int member_id) {
		logger.info(" DAOImpl: selectHistoryLimit50() 실행! ");
	    logger.info(" DAOImpl: selectHistoryLimit50() 끝! ");
	    return sqlSession.selectList(NAMESPACE + "selectHistoryLimit50", member_id);
	}
	
//	@Override
//	public int countHistory(int member_id) {
//		logger.info(" DAOImpl: countHistory() 실행! ");
//		logger.info(" DAOImpl: countHistory() 끝! ");
//	    return sqlSession.selectOne(NAMESPACE + "countHistory", member_id);
//	}

//	@Override
//	public List<TradeHistoryViewVO> selectBuyHistory(int member_id) {
//	    logger.info(" DAOImpl: selectBuyHistory() 실행! ");
//	    logger.info(" DAOImpl: selectBuyHistory() 끝! ");
//	    return sqlSession.selectList(
//	        NAMESPACE + "selectBuyHistory", member_id
//	    );
//	}

	@Override
	public List<TradeHistoryViewVO> selectSellHistory(int member_id) {
	    logger.info(" DAOImpl: selectSellHistory() 실행! ");
	    logger.info(" DAOImpl: selectSellHistory() 끝! ");
	    return sqlSession.selectList(
	        NAMESPACE + "selectSellHistory", member_id
	    );
	}

}
