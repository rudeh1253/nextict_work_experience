package com.spring.shoppingmall.dao;

import com.spring.shoppingmall.vo.ProductPatternDetail;
import com.spring.shoppingmall.vo.ProductPatternInfo;

public interface ShoppingMallDao {
	
	public int insertPattern(ProductPatternInfo productPatternInfo);
	
	public int insertPatternDetail(ProductPatternDetail productPatternDetail);
}
