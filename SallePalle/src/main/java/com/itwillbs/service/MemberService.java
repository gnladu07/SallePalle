package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.PaymentHistoryVO;

public interface MemberService {
	
	// 회원 정보 가져오기
	public MemberVO selectOne(String userid);

	// 회원 가입 처리
	public void memberJoin(MemberVO vo);
	
	// 아이디 중복 체크 
	public boolean isUseridExists(String userid);
	
	// 이메일 인증 처리
	public int emailSendCode(String email);

	// 회원 프로필 사진 수정
	public void changeProfileImage(String userid, MultipartFile file);

	// 프로필 사진 기본 이미지로 초기화
	public void resetProfileImage(String userid);

	// 회원 개인정보 수정
	public void updateMemberWithHistory(MemberVO vo);
	
	// 개인정보 초기화
	public void rollbackMemberInfo(String userid);

	// 회원탈퇴 - 비밀번호 검증
	public boolean checkPassword(String userid, String userpw);

	// 회원탈퇴
	public void deactivateMember(String userid);

	// 아이디 찾기
	public String findUseridByPassword(String inputPw);

	// 비밀번호 찾기 - 링크 발송 요청
	public boolean sendResetLink(String userid, String email);

	// 비밀번호 찾기 - 링크 클릭 시 비밀번호 재설정 페이지로 이동
	public boolean validateToken(String token);

	// 비밀번호 찾기 - 비밀번호 실제 변경
	public boolean resetPassword(String token, String newPw);

	// 네이버 로그인
	public MemberVO selectNaverLogin(String provider_id);

	// 판매 상태 업데이트
	public void updateSellerStatus(int member_id, String status);
	
	// 권한 추가
    public void insertAuth(MemberAuthVO vo);

	// 메일 발송 정보 조회
	public void setNotifyFlag(int member_id, String flag);

	// 알림 메일 발송 여부를 저장
	public void updateNotifyFlag(String userid, String flag);

	// 회원 리스트
	public List<MemberVO> getMemberList();

	// 회원 정지
	public void disableMember(int member_id);

	// 회원 정지 해제
	public void enableMember(int member_id);

	// 회원 삭제
	public void deleteMember(int member_id);

	// 포인트 충전 후 최신 정보
	public MemberVO getMemberById(int member_id);

	// 토큰 및 사용자 일련번호 업데이트
	public void updateOpenBankingToken(MemberVO vo);
	
	// 통합 결제/적립 내역 조회
	public Map<String, Object> getPaymentHistory(int member_id, boolean isSeller);

}
