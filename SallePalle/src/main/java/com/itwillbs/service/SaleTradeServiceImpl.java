package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.component.FileComponent;
import com.itwillbs.domain.SaleTradeVO;
import com.itwillbs.persistence.SaleTradeDAO;

@Service
public class SaleTradeServiceImpl implements SaleTradeService {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SaleTradeServiceImpl.class);

	@Inject private SaleTradeDAO saleTradeDAO;
	@Inject private FileComponent fileComponent;

	@Override
	public List<SaleTradeVO> getSaleTradeList(String type, String keyword, Integer itemCtgId) {
	    log.debug(" SaleTradeServiceImpl: getSaleTradeList() 실행!");
	    log.debug(" SaleTradeServiceImpl: getSaleTradeList() 끝!");
	    return saleTradeDAO.selectSaleTradeList(type, keyword, itemCtgId);
	}

	@Override
	public SaleTradeVO getSaleTradeDetail(Integer tradeId) {
		log.debug(" SaleTradeServiceImpl: getSaleTradeDetail() 실행!");
	    log.debug(" SaleTradeServiceImpl: getSaleTradeDetail() 끝!");
		return saleTradeDAO.selectSaleTradeDetail(tradeId);
	}

	@Override
	public List<SaleTradeVO> getOtherSaleTradeBySeller(Integer seller_id, int tradeId) {
		log.debug(" SaleTradeServiceImpl: getOtherSaleTradeBySeller() 실행!");
	    log.debug(" SaleTradeServiceImpl: getOtherSaleTradeBySeller() 끝!");
		return saleTradeDAO.selectOtherSaleTradeBySeller(seller_id, tradeId);
	}

	@Transactional
	@Override
	public int recommendTrade(int tradeId, String userid) {
		log.debug(" SaleTradeServiceImpl: recommendTrade() 실행!");
	    log.debug("tradeId={}, userid={}", tradeId, userid);

	    // 1. 중복 추천 체크
	    int exists = saleTradeDAO.existsRecommend(tradeId, userid);
	    if (exists > 0) {
	        return -2;
	    }

	    // 2. 추천 등록
	    saleTradeDAO.insertRecommend(tradeId, userid);

	    // 3. 추천 수 증가
	    saleTradeDAO.increaseRecommendCnt(tradeId);

	    log.debug(" SaleTradeServiceImpl: recommendTrade() 끝!");
	    // 4. 최신 추천 수 조회
	    return saleTradeDAO.selectRecommendCnt(tradeId);
	}

	@Transactional
	@Override
	public void buyTrade(int tradeId, String userid,
	                     boolean payPoint, boolean payMileage,
	                     String mileageType, Integer useMileage) {

	    log.debug(" SaleTradeServiceImpl: buyTrade() 실행!");

	    SaleTradeVO trade = saleTradeDAO.selectSaleTradeDetail(tradeId);

	    int buyerId  = saleTradeDAO.selectMemberIdByUserid(userid);
	    int sellerId = trade.getSeller_id();
	    int price    = trade.getPrice_point();
	    
	    int myPoint   = saleTradeDAO.selectPayBalance(buyerId);
	    int myMileage = saleTradeDAO.selectMileageBalance(buyerId);

	    int usedPoint = 0;
	    int usedMileage = 0;
	    
	    // 0. 구매 전 포인트 잔액 검증
	    if (payPoint) {
	        if (myPoint < price) {
	            throw new IllegalStateException("NOT_ENOUGH_POINT");
	        }
	        usedPoint = price;
	        saleTradeDAO.usePoint(buyerId, usedPoint);
	    }

	    if (payMileage) {

	        if ("FULL".equals(mileageType)) {

	            if (myMileage < price) {
	                throw new IllegalStateException("NOT_ENOUGH_MILEAGE");
	            }

	            usedMileage = price;
	            saleTradeDAO.useMileage(buyerId, usedMileage);

	        } else {

	            if (useMileage == null || useMileage <= 0) {
	                throw new IllegalStateException("INVALID_MILEAGE");
	            }

	            if (useMileage > myMileage) {
	                throw new IllegalStateException("NOT_ENOUGH_MILEAGE");
	            }

	            if (useMileage > trade.getMax_mileage_use()) {
	                throw new IllegalStateException("EXCEED_MAX_MILEAGE");
	            }

	            usedMileage = useMileage;
	            usedPoint = price - useMileage;

	            if (usedPoint > myPoint) {
	                throw new IllegalStateException("NOT_ENOUGH_POINT");
	            }

	            saleTradeDAO.useMileage(buyerId, usedMileage);
	            saleTradeDAO.usePoint(buyerId, usedPoint);
	        }
	    }
	    
	    // 2. 판매자 지갑 보장
	    if (saleTradeDAO.existsPayWallet(sellerId) == 0) {
	        saleTradeDAO.insertPayWallet(sellerId);
	    }

	    // 3. 판매자 수익 처리
	    saleTradeDAO.earnPoint(sellerId, price);

	    // 4. 거래 이력 저장
	    saleTradeDAO.insertTradeHistory(tradeId, buyerId, sellerId, usedPoint, price, usedMileage);
	    log.debug(" SaleTradeServiceImpl: buyTrade() 끝!");
	}

	@Override
	public void writeSaleTrade(SaleTradeVO vo) {
		log.debug(" SaleTradeServiceImpl: writeSaleTrade() 실행!");
		
		saleTradeDAO.insertSaleTrade(vo);
		
	    log.debug(" SaleTradeServiceImpl: writeSaleTrade() 끝!");
	}

	@Override
	public Integer getMemberIdByUserid(String userid) {
		log.debug("SaleTradeServiceImpl: getMemberIdByUserid() 실행");
		log.debug("SaleTradeServiceImpl: getMemberIdByUserid() 끝");
	    return saleTradeDAO.selectMemberIdByUserid(userid);
	}

	@Override
	public void updateSaleTrade(SaleTradeVO vo, 
			                    MultipartFile thumbFile,
			                    SaleTradeVO origin) {
		log.debug(" SaleTradeServiceImpl: getSaleTradeList() 실행!");
		
		if (thumbFile != null && !thumbFile.isEmpty()) {
	        if (origin.getThumb_img() != null && !origin.getThumb_img().isEmpty()) {
	            boolean deleted = fileComponent.deleteFile(origin.getThumb_img());
	            log.info("기존 썸네일 삭제 결과 : {}", deleted);
	        }

	        String newThumb = fileComponent.upload(thumbFile);
	        vo.setThumb_img(newThumb);
	    }

	    saleTradeDAO.updateSaleTrade(vo);
	    log.debug(" SaleTradeServiceImpl: getSaleTradeList() 끝!");
		
	}

	@Override
	public void deleteSaleTrade(SaleTradeVO origin) {
		log.debug(" SaleTradeServiceImpl: getSaleTradeList() 실행!");
		
	    if(origin.getThumb_img() != null){
	        boolean result = fileComponent.deleteFile(origin.getThumb_img());
	        log.info("기존 썸네일 삭제 결과 : {}", result);
	    }
		
		saleTradeDAO.deleteSaleTrade(origin);
		
	    log.debug(" SaleTradeServiceImpl: getSaleTradeList() 끝!");
	}

	@Override
	public List<SaleTradeVO> getSaleTradeBySeller(int sellerId) {
		log.debug(" SaleTradeServiceImpl: getSaleTradeBySeller() 실행!");
		log.debug(" SaleTradeServiceImpl: getSaleTradeBySeller() 끝!");
		return saleTradeDAO.selectBySeller(sellerId);
	}

	@Override
	public void deleteSaleTrade(int tradeId, int sellerId) {
		log.debug(" SaleTradeServiceImpl: deleteSaleTrade() 실행!");
		
		saleTradeDAO.softDeleteTrade(tradeId, sellerId);
		
		log.debug(" SaleTradeServiceImpl: deleteSaleTrade() 끝!");
	}

	@Override
	public SaleTradeVO getSaleTradeForRelist(int tradeId, int sellerId) {
		log.debug(" SaleTradeServiceImpl: getSaleTradeForRelist() 실행!");
	    log.debug(" SaleTradeServiceImpl: getSaleTradeForRelist() 끝!");
		return saleTradeDAO.selectSaleTradeForRelist(tradeId, sellerId);
	}

	@Override
	public void relistSaleTrade(SaleTradeVO vo) {
		log.debug(" SaleTradeServiceImpl: relistSaleTrade() 실행!");
		
		saleTradeDAO.updateRelistSaleTrade(vo);
		
	    log.debug(" SaleTradeServiceImpl: relistSaleTrade() 끝!");
	}

	@Override
	public Object getLatestSaleTradeList(int limit) {
		log.debug(" SaleTradeServiceImpl: getLatestSaleTradeList() 실행!");
	    log.debug(" SaleTradeServiceImpl: getLatestSaleTradeList() 끝!");
		return saleTradeDAO.selectLatestSaleTradeList(limit);
	}

	@Override
	public Object getRecommendSaleTradeList(int limit) {
		log.debug(" SaleTradeServiceImpl: getRecommendSaleTradeList() 실행!");
	    log.debug(" SaleTradeServiceImpl: getRecommendSaleTradeList() 끝!");
		return saleTradeDAO.selectRecommendSaleTradeList(limit);
	}

	@Override
	public void insertOrUpdateRecentView(int member_id, int trade_id) throws Exception {
		log.debug(" SaleTradeServiceImpl: insertOrUpdateRecentView() 실행!");
		
		saleTradeDAO.insertOrUpdateRecentView(member_id, trade_id);
		
	    log.debug(" SaleTradeServiceImpl: insertOrUpdateRecentView() 끝!");
		
	}

	@Override
	public List<Map<String, Object>> getRecentViewList(int member_id) throws Exception {
		log.debug(" SaleTradeServiceImpl: getRecentViewList() 실행!");
	    log.debug(" SaleTradeServiceImpl: getRecentViewList() 끝!");
	    return saleTradeDAO.getRecentViewList(member_id);
	}
	
	@Override
    public int updateTradeStatus(int trade_id, String status, int seller_id) {
		log.debug(" SaleTradeServiceImpl: updateTradeStatus() 실행!");
	    log.debug(" SaleTradeServiceImpl: updateTradeStatus() 끝!");
        return saleTradeDAO.updateTradeStatus(trade_id, status, seller_id);
    }

}
