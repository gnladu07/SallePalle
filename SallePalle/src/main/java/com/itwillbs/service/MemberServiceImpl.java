package com.itwillbs.service;
import javax.inject.Inject;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.itwillbs.component.MailComponent;
import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.persistence.MemberDAO;

@Service
public class MemberServiceImpl implements MemberService {

	@Inject private MemberDAO memberDAO;
	@Inject private PasswordEncoder pwEncoder;
	@Inject private MailComponent mailComponent;

	@Override
	public void memberJoin(MemberVO vo) {
		// 비밀번호 암호화 
		vo.setUserpw(pwEncoder.encode(vo.getUserpw()));
		
		// 회원 DB 저장
		memberDAO.insertMember(vo);
		
		// 기본 권한 부여
		MemberAuthVO auth = new MemberAuthVO();
		auth.setUserid(vo.getUserid());
		auth.setAuth("ROLE_USER");
		memberDAO.insertAuth(auth);
	}

	@Override
	public int emailSendCode(String email) {
		int code = (int) ((Math.random()*900000) + 100000);
		mailComponent.sendMassage(email, "살래팔래 인증번호", "인증번호: "+code);
		return code;
	}

}
