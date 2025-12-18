package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.MileageWalletVO;
import com.itwillbs.domain.PayWalletVO;
import com.itwillbs.domain.SaleTradeVO;

@Repository
public class SaleTradeDAOImpl implements SaleTradeDAO {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SaleTradeDAOImpl.class);

	private static final String NAMESPACE 
		= "com.itwillbs.mapper.SaleTradeMapper.";

	@Inject private SqlSession sqlSession;

	@Override
	public List<SaleTradeVO> selectSaleTradeList(String type, String keyword, Integer itemCtgId) {

	    log.info(" SaleTradeDAOImpl: selectSaleTradeList() 실행!");

	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("type", type);
	    paramMap.put("keyword", keyword);
	    paramMap.put("itemCtgId", itemCtgId);

	    log.info(" SaleTradeDAOImpl: selectSaleTradeList() 끝!");
	    return sqlSession.selectList(NAMESPACE + "selectSaleTradeList", paramMap);
	}

	@Override
	public SaleTradeVO selectSaleTradeDetail(int tradeId) {
		log.info(" SaleTradeDAOImpl: selectSaleTradeDetail() 실행!");
		log.info(" SaleTradeDAOImpl: selectSaleTradeDetail() 끝!");
		return sqlSession.selectOne(NAMESPACE + "selectSaleTradeDetail", tradeId);
	}

	@Override
	public List<SaleTradeVO> selectOtherSaleTradeBySeller(Integer seller_id, int tradeId) {
		log.info(" SaleTradeDAOImpl: selectOtherSaleTradeBySeller() 실행!");
		
		Map<String, Object> map = new HashMap<>();
	    map.put("sellerId", seller_id);
	    map.put("tradeId", tradeId);
		
		log.info(" SaleTradeDAOImpl: selectOtherSaleTradeBySeller() 끝!");
		return sqlSession.selectList(NAMESPACE + "selectOtherSaleTradeBySeller", map);
	}

	// 1. 추천 중복 여부 확인
    @Override
    public int existsRecommend(int tradeId, String userid) {
    	log.info(" SaleTradeDAOImpl: existsRecommend() 실행!");
        log.info(" tradeId={}, userid={}", tradeId, userid);

        log.info(" SaleTradeDAOImpl: existsRecommend() 끝!");
        return sqlSession.selectOne(
                NAMESPACE + "existsRecommend",
                new java.util.HashMap<String, Object>() {{
                    put("tradeId", tradeId);
                    put("userid", userid);
                }}
        );
    }

    // 2. 추천 등록
    @Override
    public void insertRecommend(int tradeId, String userid) {
    	log.info(" SaleTradeDAOImpl: insertRecommend() 실행!");
        log.info("tradeId={}, userid={}", tradeId, userid);

        sqlSession.insert(
                NAMESPACE + "insertRecommend",
                new java.util.HashMap<String, Object>() {{
                    put("tradeId", tradeId);
                    put("userid", userid);
                }}
        );
        log.info(" SaleTradeDAOImpl: insertRecommend() 끝!");
    }

    // 3. 추천 수 증가
    @Override
    public void increaseRecommendCnt(int tradeId) {
    	log.info(" SaleTradeDAOImpl: increaseRecommendCnt() 실행!");
        log.info("tradeId={}", tradeId);

        sqlSession.update(
                NAMESPACE + "increaseRecommendCnt",
                tradeId
        );
        log.info(" SaleTradeDAOImpl: increaseRecommendCnt() 끝!");
    }

    // 4. 추천 수 조회
    @Override
    public int selectRecommendCnt(int tradeId) {
    	log.info(" SaleTradeDAOImpl: selectRecommendCnt() 실행!");
        log.info("tradeId={}", tradeId);

        log.info(" SaleTradeDAOImpl: selectRecommendCnt() 끝!");
        return sqlSession.selectOne(
                NAMESPACE + "selectRecommendCnt",
                tradeId
        );
    }

    @Override
    public int selectMemberIdByUserid(String userid) {
    	log.info(" SaleTradeDAOImpl: selectMemberIdByUserid() 실행!");
    	log.info(" SaleTradeDAOImpl: selectMemberIdByUserid() 끝!");
        return sqlSession.selectOne(NAMESPACE + "selectMemberIdByUserid", userid);
    }

    @Override
    public void usePoint(int buyerId, int usedPoint) {
    	log.info(" SaleTradeDAOImpl: usePoint() 실행!");
        PayWalletVO vo = new PayWalletVO();
        vo.setMember_id(buyerId);
        vo.setBalance(-usedPoint); // 차감

        sqlSession.update(NAMESPACE + "usePoint", vo);
        log.info(" SaleTradeDAOImpl: usePoint() 끝!");
    }

    @Override
    public void earnPoint(int sellerId, int earnPoint) {
    	log.info(" SaleTradeDAOImpl: earnPoint() 실행!");
        PayWalletVO vo = new PayWalletVO();
        vo.setMember_id(sellerId);
        vo.setBalance(earnPoint); // 적립

        sqlSession.update(NAMESPACE + "earnPoint", vo);
        log.info(" SaleTradeDAOImpl: earnPoint() 끝!");
    }

    @Override
    public void useMileage(int buyerId, int usedMileage) {
    	log.info(" SaleTradeDAOImpl: useMileage() 실행!");
        MileageWalletVO vo = new MileageWalletVO();
        vo.setMember_id(buyerId);
        vo.setMileage(-usedMileage);

        sqlSession.update(NAMESPACE + "useMileage", vo);
        log.info(" SaleTradeDAOImpl: useMileage() 끝!");    	
    }

    @Override
    public void earnMileage(int sellerId, int usedMileage) {
    	log.info(" SaleTradeDAOImpl: earnMileage() 실행!");
        MileageWalletVO vo = new MileageWalletVO();
        vo.setMember_id(sellerId);
        vo.setMileage(usedMileage);

        sqlSession.update(NAMESPACE + "earnMileage", vo);
        log.info(" SaleTradeDAOImpl: earnMileage() 끝!");    	
    }

    @Override
    public void insertTradeHistory(
            int tradeId,
            int buyerId,
            int sellerId,
            int usedPoint,
            int earnPoint,
            int usedMileage) {
    	 log.info(" SaleTradeDAOImpl: insertTradeHistory() 실행!");    	
    	 Map<String, Object> param = new HashMap<>();
         param.put("trade_id", tradeId);
         param.put("buyer_id", buyerId);
         param.put("seller_id", sellerId);
         param.put("used_point", usedPoint);
         param.put("earn_point", earnPoint);
         param.put("used_mileage", usedMileage);

        sqlSession.insert(NAMESPACE + "insertTradeHistory", param);
        log.info(" SaleTradeDAOImpl: insertTradeHistory() 끝!");    	
    }

    @Override
    public void updateTradeStatusComplete(int tradeId) {
    	log.info(" SaleTradeDAOImpl: updateTradeStatusComplete() 실행!");    	
        sqlSession.update(NAMESPACE + "updateTradeStatusComplete", tradeId);
        log.info(" SaleTradeDAOImpl: updateTradeStatusComplete() 끝!");    	
    }

 

}
