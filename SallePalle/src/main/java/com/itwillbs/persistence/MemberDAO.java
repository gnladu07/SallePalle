package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberHistoryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.PageVO;
import com.itwillbs.domain.PasswordResetTokenVO;
import com.itwillbs.domain.PaymentHistoryVO;

public interface MemberDAO {
	
	// 회원 정보 가져오기
	public MemberVO selectOne(String userid);

	// 회원 가입 처리
	public void insertMember(MemberVO vo);
	
	// 아이디 중복 체크 
	public int countUserid(String userid);

	// 회원 권한 부여
	public void insertAuth(MemberAuthVO vo);

	// 회원 프로필 사진 수정
	public void updateProfileImg(MemberVO vo);

	// 기본 이미지로 초기화
	public void updateProfileToDefault(String userid);

	// 회원 개인정보 수정
	public void updateMember(MemberVO vo);
	public void insertMemberHistory(MemberHistoryVO memberHistoryVO);
	public void rollbackMemberInfo(String userid);

	// 회원탈퇴
	public void deactivateMember(String userid);

	// 아이디 찾기
	public List<MemberVO> findAllMembersForIdSearch();

	// 비밀번호 찾기
	public MemberVO findMemberByIdAndEmail(MemberVO input);
	public void insertResetToken(PasswordResetTokenVO tokenVO);	
	public PasswordResetTokenVO findByToken(String token);
	public void updatePassword(MemberVO member);
	public void deleteToken(String token);

	// 네이버 로그인
	public MemberVO selectNaverLogin(String provider_id);

	// 판매 상태 업데이트
	public void updateSellerStatus(int member_id, String status);

	// (어드민)멤버 정보 조회
//	public MemberVO readByMemberId(int member_id);

	// 메일 발송 정보 조회
	public void setNotifyFlag(Map<String, Object> map);

	// 알림 메일 발송 여부를 저장
	public void updateNotifyFlag(Map<String, Object> map);

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
	
	public void updateOpenBankingToken(MemberVO vo);

	public List<PaymentHistoryVO> selectHistoryPaging(int member_id, Criteria cri);
	
	public int countHistory(int member_id);
}
