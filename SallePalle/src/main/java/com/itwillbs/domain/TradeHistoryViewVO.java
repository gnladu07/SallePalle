package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class TradeHistoryViewVO {

    private String history_type;

    private int trade_id;
    private String title;

    private int used_point;
    private int used_mileage;
    private int earn_point;

    private Timestamp regdate;
}