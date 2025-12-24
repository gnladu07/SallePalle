package com.itwillbs.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.domain.SaleTradeVO;

public interface SaleTradeService {
	
	// 중고 판매글 리스트 조회
	public List<SaleTradeVO> getSaleTradeList(String type, String keyword, Integer itemCtgId);

	// 판매글 상세 조회
	public SaleTradeVO getSaleTradeDetail(Integer tradeId);

	// 판매자의 다른 상품
	public List<SaleTradeVO> getOtherSaleTradeBySeller(Integer seller_id, int tradeId);

	// 중고 판매글 추천 처리 - ajax
	public int recommendTrade(int tradeId, String userid);

	// 중고 제품 구매 처리
	public void buyTrade(int trade_id, String name, boolean payPoint, boolean payMileage, String mileageType, Integer useMileage);

	// 중고 상품 등록(글작성)
	public void writeSaleTrade(SaleTradeVO vo);

	//  로그인 회원 정보 전달
	public Integer getMemberIdByUserid(String userid);

	// 중고 물품 거래글 수정
	public void updateSaleTrade(SaleTradeVO vo, MultipartFile thumbFile, SaleTradeVO origin);

	// 중고 물품 거래글 삭제
	public void deleteSaleTrade(SaleTradeVO origin);

	// 등록한 중고 물품 리스트
	public List<SaleTradeVO> getSaleTradeBySeller(int sellerId);

	// 판매완료된 중고 물품 삭제
	public void deleteSaleTrade(int tradeId, int sellerId);

	// 재등록용 게시글 조회(본인 판매 글만)
	public SaleTradeVO getSaleTradeForRelist(int tradeId, int sellerId);

	// 재등록 처리
	public void relistSaleTrade(SaleTradeVO vo);

	// 최신 중고 거래 5개
	public Object getLatestSaleTradeList(int limit);

	// 추천순 중고 거래 5개
	public Object getRecommendSaleTradeList(int limit);

}
