package com.itwillbs.service;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.SellerRequestVO;
import com.itwillbs.persistence.SellerDAO;

@Service
public class SellerServiceImpl implements SellerService {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SellerServiceImpl.class);

	@Inject SellerDAO sellerDAO;
	
	
	@Override
	public void createRequest(int member_id) {
		log.info(" SellerServiceImpl: createRequest()실행! ");
		
		sellerDAO.insertSellerRequest(member_id);
		
		log.info(" SellerServiceImpl: createRequest()끝! ");
	}

	@Override
	public SellerRequestVO getRequest(int request_id) {
		log.info(" SellerServiceImpl: getRequest()실행! ");
		
		SellerRequestVO resultVO = sellerDAO.selectSellerRequest(request_id);
		
		log.info(" SellerServiceImpl: getRequest()끝! ");
		return resultVO;
	}

	@Override
	public void updateRequestStatus(int request_id, String status) {
		log.info(" SellerServiceImpl: updateRequestStatus()실행! ");
		
		sellerDAO.updateSellerRequestStatus(request_id, status);
		
		log.info(" SellerServiceImpl: updateRequestStatus()끝! ");
	}

}
