package com.itwillbs.security;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.persistence.MemberDAO;

/**
 * 스프링 시큐리티가 로그인할 때 호출하는 서비스.
 * 
 * 1) form-login에서 userid 전달
 * 2) loadUserByUsername() 실행됨
 * 3) DB에서 member + 권한 조회
 * 4) CustomUserDetails로 감싸서 반환
 * 5) 시큐리티가 authentication 객체 생성
 */
public class CustomUserDetailsService implements UserDetailsService {
		
	private static final Logger logger 
		= LoggerFactory.getLogger(CustomUserDetailsService.class);
	
	@Inject private MemberDAO memberDAO;

	@Override
	public UserDetails loadUserByUsername(String userid) throws UsernameNotFoundException {
		logger.info("CustomUserDetailsService - loadUserByUsername 실행됨");
		
		// DB에서 회원 정보 + 권한 JOIN 조회
		MemberVO vo = memberDAO.selectOne(userid);
		
		if(vo == null) {
			throw new UsernameNotFoundException("없는 유저입니다.: " + userid);
		}
		
		// MemberVO -> UserDetails(CustomUserDetails) 변환
		return new CustomUserDetails(vo);
	}


}
