package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.domain.SaleTradeVO;
import com.itwillbs.persistence.SaleTradeDAO;

@Service
public class SaleTradeServiceImpl implements SaleTradeService {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SaleTradeServiceImpl.class);

	@Inject private SaleTradeDAO saleTradeDAO;

	@Override
	public List<SaleTradeVO> getSaleTradeList(String type, String keyword, Integer itemCtgId) {
	    log.info(" SaleTradeServiceImpl: getSaleTradeList() 실행!");
	    log.info(" SaleTradeServiceImpl: getSaleTradeList() 끝!");
	    return saleTradeDAO.selectSaleTradeList(type, keyword, itemCtgId);
	}

	@Override
	public SaleTradeVO getSaleTradeDetail(int tradeId) {
		log.info(" SaleTradeServiceImpl: getSaleTradeDetail() 실행!");
	    log.info(" SaleTradeServiceImpl: getSaleTradeDetail() 끝!");
		return saleTradeDAO.selectSaleTradeDetail(tradeId);
	}

	@Override
	public List<SaleTradeVO> getOtherSaleTradeBySeller(Integer seller_id, int tradeId) {
		log.info(" SaleTradeServiceImpl: getOtherSaleTradeBySeller() 실행!");
	    log.info(" SaleTradeServiceImpl: getOtherSaleTradeBySeller() 끝!");
		return saleTradeDAO.selectOtherSaleTradeBySeller(seller_id, tradeId);
	}

	@Transactional
	@Override
	public int recommendTrade(int tradeId, String userid) {
		log.info(" SaleTradeServiceImpl: recommendTrade() 실행!");
	    log.info("tradeId={}, userid={}", tradeId, userid);

	    // 1. 중복 추천 체크
	    int exists = saleTradeDAO.existsRecommend(tradeId, userid);
	    if (exists > 0) {
	        return -2;
	    }

	    // 2. 추천 등록
	    saleTradeDAO.insertRecommend(tradeId, userid);

	    // 3. 추천 수 증가
	    saleTradeDAO.increaseRecommendCnt(tradeId);

	    log.info(" SaleTradeServiceImpl: recommendTrade() 끝!");
	    // 4. 최신 추천 수 조회
	    return saleTradeDAO.selectRecommendCnt(tradeId);
	}

	@Transactional
	@Override
	public void buyTrade(int tradeId, String userid,
	                     boolean payPoint, boolean payMileage,
	                     String mileageType, Integer useMileage) {
		log.info(" SaleTradeServiceImpl: buyTrade() 실행!");
	    SaleTradeVO trade = saleTradeDAO.selectSaleTradeDetail(tradeId);

	    int buyerId  = saleTradeDAO.selectMemberIdByUserid(userid);
	    int sellerId = trade.getSeller_id();
	    int price    = trade.getPrice_point();

	    int usedPoint = 0;
	    int usedMileage = 0;
	    int earnPoint = 0;

	    if(payPoint){
	        usedPoint = price;
	        earnPoint = price;
	        saleTradeDAO.usePoint(buyerId, usedPoint);
	        saleTradeDAO.earnPoint(sellerId, earnPoint);
	    }

	    if(payMileage){
	        if("FULL".equals(mileageType)){
	            usedMileage = price;
	            saleTradeDAO.useMileage(buyerId, usedMileage);
	            saleTradeDAO.earnMileage(sellerId, usedMileage);
	        } else {
	            usedMileage = useMileage;
	            usedPoint = price - useMileage;
	            earnPoint = usedPoint;

	            saleTradeDAO.useMileage(buyerId, usedMileage);
	            saleTradeDAO.usePoint(buyerId, usedPoint);
	            saleTradeDAO.earnPoint(sellerId, earnPoint);
	        }
	    }

	    saleTradeDAO.insertTradeHistory(
	        tradeId, buyerId, sellerId,
	        usedPoint, earnPoint, usedMileage
	    );

	    saleTradeDAO.updateTradeStatusComplete(tradeId);
	    log.info(" SaleTradeServiceImpl: buyTrade() 끝!");
	}

}
