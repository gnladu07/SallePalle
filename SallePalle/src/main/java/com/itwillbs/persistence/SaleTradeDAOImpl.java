package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

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
        log.info("existsRecommend 실행 tradeId={}, userid={}", tradeId, userid);

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
        log.info("insertRecommend 실행 tradeId={}, userid={}", tradeId, userid);

        sqlSession.insert(
                NAMESPACE + "insertRecommend",
                new java.util.HashMap<String, Object>() {{
                    put("tradeId", tradeId);
                    put("userid", userid);
                }}
        );
    }

    // 3. 추천 수 증가
    @Override
    public void increaseRecommendCnt(int tradeId) {
        log.info("increaseRecommendCnt 실행 tradeId={}", tradeId);

        sqlSession.update(
                NAMESPACE + "increaseRecommendCnt",
                tradeId
        );
    }

    // 4. 추천 수 조회
    @Override
    public int selectRecommendCnt(int tradeId) {
        log.info("selectRecommendCnt 실행 tradeId={}", tradeId);

        return sqlSession.selectOne(
                NAMESPACE + "selectRecommendCnt",
                tradeId
        );
    }



}
