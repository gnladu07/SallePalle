package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class TradeHistoryViewVO {

    private String history_type; // BUY / SELL (뷰 구분용, DB 컬럼 아님)

    private int trade_id;
    private String title;        // saletrade_board.title

    private int used_point;
    private int used_mileage;
    private int earn_point;

    private Timestamp regdate;
}