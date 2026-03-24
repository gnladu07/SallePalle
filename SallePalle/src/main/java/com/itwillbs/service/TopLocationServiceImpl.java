package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.TopLocation;
import com.itwillbs.persistence.TopLocationDAO;

@Service
public class TopLocationServiceImpl implements TopLocationService {
		
	private static final Logger logger 
		= LoggerFactory.getLogger(TopLocationServiceImpl.class);

	@Inject private TopLocationDAO topLocationDAO;
	
	@Override
	public List<TopLocation> getTopLocationList() {
		logger.debug(" TopLocationServiceImpl: getTopLocationList() 실행 ");
		
		List<TopLocation> resultList = topLocationDAO.selectListLocation();
		
		logger.debug(" TopLocationServiceImpl: getTopLocationList() 끝 ");
		return resultList;
	}

}
