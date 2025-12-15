package com.itwillbs.security;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.MileageWalletVO;
import com.itwillbs.domain.PayWalletVO;
import com.itwillbs.persistence.MemberDAO;
import com.itwillbs.persistence.MileageWalletDAO;
import com.itwillbs.persistence.PayWalletDAO;

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
	@Inject private PayWalletDAO payWalletDAO;
	@Inject private MileageWalletDAO mileageWalletDAO;

	@Override
	public UserDetails loadUserByUsername(String userid) throws UsernameNotFoundException {
		logger.info("CustomUserDetailsService - loadUserByUsername 실행됨");
		
		// DB에서 회원 정보 + 권한 JOIN 조회
		MemberVO vo = memberDAO.selectOne(userid);
		
		if(vo == null) {
			throw new UsernameNotFoundException("없는 유저입니다.: " + userid);
		}
		
		// 1) 탈퇴 회원 차단
	    if (vo.getDeleted_at() != null) {
	        throw new DisabledException("탈퇴한 계정입니다.");
	    }

	    // 2) 정지 회원 차단
	    if ("0".equals(vo.getEnable_flag())) {
	        throw new LockedException("정지된 계정입니다.");
	    }
	    
	    PayWalletVO payWallet = payWalletDAO.getWallet(vo.getMember_id());
	    MileageWalletVO mileageWallet = mileageWalletDAO.getWallet(vo.getMember_id());
		
	    if (payWallet != null) {
	    	vo.setWallet_balance(payWallet.getBalance());
	    } else {
	    	vo.setWallet_balance(0);
	    }

	    if (mileageWallet != null) {
	    	vo.setWallet_mileage(mileageWallet.getMileage());
	    } else {
	    	vo.setWallet_mileage(0);
	    }
	    
		return new CustomUserDetails(vo);
	}


}
