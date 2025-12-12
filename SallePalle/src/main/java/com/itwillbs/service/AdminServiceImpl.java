package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.persistence.AdminDAO;

@Service
public class AdminServiceImpl implements AdminService {
		
	private static final Logger log 
		= LoggerFactory.getLogger(AdminServiceImpl.class);
	
	@Inject private AdminDAO aDAO;

	@Override
	public List<MemberVO> getSortedMembers(String sort) {
		log.info(" AdminServiceImpl: getSortedMembers() 실행! ");
		
		List<MemberVO> resultVO = aDAO.getSortedMembers(sort);
		
		log.info(" AdminServiceImpl: getSortedMembers() 끝! ");
		return resultVO;
	}

}
