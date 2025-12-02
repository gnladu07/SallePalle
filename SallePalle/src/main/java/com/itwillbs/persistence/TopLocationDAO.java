package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.TopLocation;

public interface TopLocationDAO {
	
	public List<TopLocation> selectListLocation();

}
