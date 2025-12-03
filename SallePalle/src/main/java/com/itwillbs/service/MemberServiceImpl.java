package com.itwillbs.service;
import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.component.FileComponent;
import com.itwillbs.component.MailComponent;
import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberHistoryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.persistence.MemberDAO;

@Service
public class MemberServiceImpl implements MemberService {

	private static final Logger logger 
		= LoggerFactory.getLogger(MemberServiceImpl.class);
	
	@Inject private MemberDAO memberDAO;
	@Inject private PasswordEncoder pwEncoder;
	@Inject private MailComponent mailComponent;
	@Inject private FileComponent fileComponent;
	
	@Override
	public MemberVO selectOne(String userid) {
		logger.info(" MServiceImpl: selectOne() 실행! ");
		
		MemberVO resultInfo 
			= memberDAO.selectOne(userid);
		
		logger.info(" MServiceImpl: selectOne() 끝! ");
		return resultInfo;
	}

	@Override
	public void memberJoin(MemberVO vo) {
		logger.info(" MServiceImpl: memberJoin() 실행! ");
		
		// 비밀번호 암호화 
		vo.setUserpw(pwEncoder.encode(vo.getUserpw()));
		
		// 회원 DB 저장
		memberDAO.insertMember(vo);
		
		// 기본 권한 부여
		MemberAuthVO auth = new MemberAuthVO();
		auth.setUserid(vo.getUserid());
		auth.setAuth("ROLE_MEMBER");
		memberDAO.insertAuth(auth);
		
		logger.info(" MServiceImpl: memberJoin() 끝! ");
	}

	@Override
	public int emailSendCode(String email) {
		logger.info(" MServiceImpl: emailSendCode() 실행! ");
		
		int code = (int) ((Math.random()*900000) + 100000);
		mailComponent.sendMassage(email, "살래팔래 인증번호", "인증번호: "+code);
		
		logger.info(" MServiceImpl: emailSendCode() 끝! ");
		return code;
	}

	@Override
	public void changeProfileImage(String userid, MultipartFile file) {
		logger.info(" MServiceImpl: changeProfileImage() 실행! ");
		
		if (file.isEmpty()) return;
		
		// 1) 현재 회원 정보 조회(기존 이미지 확인용)
		MemberVO current = memberDAO.selectOne(userid);
		
		// 2) 새 이미지 업로드
		String newFileName = fileComponent.upload(file);
		
		// 3) 기존 프로필 이미지 삭제 (default_profile.png는 건드리지 않음)
		String oldFile = current.getProfile_img();
		if (oldFile != null && !oldFile.equals("default_profile.png")) {
			fileComponent.deleteFile(oldFile);
		}
		
		// 4) DB 업데이트
		MemberVO vo = new MemberVO();
		vo.setUserid(userid);
		vo.setProfile_img(newFileName);
		
		memberDAO.updateProfileImg(vo);
		logger.info(" MServiceImpl: changeProfileImage() 끝! ");		
	}

	@Override
	public void resetProfileImage(String userid) {
		logger.info(" MServiceImpl: resetProfileImage() 실행! ");
		
		// 기존 프로필 가져오기
        MemberVO current = memberDAO.selectOne(userid);
        String oldImg = current.getProfile_img();
        
        // DB 기본 이미지로 업데이트
        memberDAO.updateProfileToDefault(userid);

        // 기존 이미지 삭제 (기본 이미지면 삭제 X)
        if (oldImg != null && !oldImg.equals("default_profile.png")) {
            fileComponent.deleteFile(oldImg);
        }
		
		logger.info(" MServiceImpl: resetProfileImage() 끝! ");
	}

	@Override
	public void updateMemberWithHistory(MemberVO vo) {
		logger.info(" MServiceImpl: resetProfileImage() 실행! ");
		
		MemberVO old = memberDAO.selectOne(vo.getUserid());
		
		// nickname 변경 기록
		if (!old.getNickname().equals(vo.getNickname())) {
			memberDAO.insertMemberHistory(new MemberHistoryVO(
					vo.getUserid(), 
					"nickname", 
					old.getNickname(), 
					vo.getNickname(), 
					vo.getUserid()
			));
		}
		
        // 지역 변경 기록
        if (old.getToplct_id() != vo.getToplct_id()) {
            memberDAO.insertMemberHistory(new MemberHistoryVO(
                vo.getUserid(),
                "toplct_id",
                String.valueOf(old.getToplct_id()),
                String.valueOf(vo.getToplct_id()),
                vo.getUserid()
            ));
        }

        // 상세주소 변경 기록
        if (!old.getDetail_address().equals(vo.getDetail_address())) {
            memberDAO.insertMemberHistory(new MemberHistoryVO(
                vo.getUserid(),
                "detail_address",
                old.getDetail_address(),
                vo.getDetail_address(),
                vo.getUserid()
            ));
        }

        // 이메일 변경 기록
        if (!old.getEmail().equals(vo.getEmail())) {
            memberDAO.insertMemberHistory(new MemberHistoryVO(
                vo.getUserid(),
                "email",
                old.getEmail(),
                vo.getEmail(),
                vo.getUserid()
            ));
        }

        // 실제 DB 업데이트 호출
        memberDAO.updateMember(vo);
		
		logger.info(" MServiceImpl: resetProfileImage() 끝! ");
	}

	@Override
	public void rollbackMemberInfo(String userid) {
		logger.info(" MServiceImpl: rollbackMemberInfo() 실행! ");
		
		memberDAO.rollbackMemberInfo(userid);
		
		logger.info(" MServiceImpl: rollbackMemberInfo() 끝! ");
	}



}
