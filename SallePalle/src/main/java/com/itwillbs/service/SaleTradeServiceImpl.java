package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.SaleTradeVO;
import com.itwillbs.persistence.SaleTradeDAO;

@Service
public class SaleTradeServiceImpl implements SaleTradeService {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SaleTradeServiceImpl.class);

	@Inject private SaleTradeDAO saleTradeDAO;

	@Override
	public List<SaleTradeVO> getSaleTradeList(String type, String keyword) {
	    log.info(" SaleTradeServiceImpl: getSaleTradeList() 실행!");
	    log.info(" SaleTradeServiceImpl: getSaleTradeList() 끝!");
	    return saleTradeDAO.selectSaleTradeList(type, keyword);
	}

}
