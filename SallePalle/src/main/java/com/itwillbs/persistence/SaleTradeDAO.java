package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.SaleTradeVO;

public interface SaleTradeDAO {
	
	// 중고 판매글 리스트 조회
	public List<SaleTradeVO> selectSaleTradeList(String type, String keyword, Integer itemCtgId);

	// 판매글 상세 조회
	public SaleTradeVO selectSaleTradeDetail(Integer tradeId);

	// 판매자의 다른 상품
	public List<SaleTradeVO> selectOtherSaleTradeBySeller(Integer seller_id, int tradeId);

	// 1. 중복 추천 체크
	public int existsRecommend(int tradeId, String userid);

	// 2. 추천 등록
	public void insertRecommend(int tradeId, String userid);

	// 3. 추천 수 증가
	public void increaseRecommendCnt(int tradeId);

	// 4. 최신 추천 수 조회
	public int selectRecommendCnt(int tradeId);

	// userid -> member_id 변환
	public int selectMemberIdByUserid(String userid);
	
	// 구매 전 포인트 잔액 검증
	public int selectPayBalance(int buyerId);

	// 구매자 포인트 차감
	public void usePoint(int buyerId, int usedPoint);

	// 판매자 포인트 적립
	public void earnPoint(int sellerId, int earnPoint);

	// 구매자 마일리지 차감
	public void useMileage(int buyerId, int usedMileage);

	// 판매자 마일리지 적립
	public void earnMileage(int sellerId, int usedMileage);

	// 거래 내역 저장
	public void insertTradeHistory(int tradeId, int buyerId, int sellerId, int usedPoint, int earnPoint, int usedMileage);

	// 판매 상태 완료 처리
	public void updateTradeStatusComplete(int tradeId);

	// 지갑 존재 여부
	public int existsPayWallet(int sellerId);
	
	// 지갑 생성
	public void insertPayWallet(int sellerId);

	// 중고 상품 등록(글작성)
	public void insertSaleTrade(SaleTradeVO vo);

	// 중고 물품 거래글 수정
	public void updateSaleTrade(SaleTradeVO vo);

	// 중고 물품 거래글 삭제
	public void deleteSaleTrade(SaleTradeVO origin);

	// 등록한 중고 물품 리스트
	public List<SaleTradeVO> selectBySeller(int sellerId);

	// 판매완료된 중고 물품 삭제
	public void softDeleteTrade(int tradeId, int sellerId);

	// 재등록용 게시글 조회(본인 판매 글만)
	public SaleTradeVO selectSaleTradeForRelist(int tradeId, int sellerId);

	// 재등록 처리
	public int updateRelistSaleTrade(SaleTradeVO vo);

	// 최신 중고 거래 5개
	public Object selectLatestSaleTradeList(int limit);

	// 추천순 중고 거래 5개
	public Object selectRecommendSaleTradeList(int limit);

	// 마일리지 잔액 조회
	public int selectMileageBalance(int memberId);
	
	// 최근 본 글 기록 추가/갱신
    public void insertOrUpdateRecentView(int member_id, int trade_id) throws Exception;
    
    public List<Map<String, Object>> getRecentViewList(int member_id) throws Exception;

	public int updateTradeStatus(int trade_id, String status, int seller_id);

}
