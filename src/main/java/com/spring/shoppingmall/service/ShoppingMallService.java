package com.spring.shoppingmall.service;

import java.util.List;

import com.spring.shoppingmall.dto.PatternRegistrationRequestDto;
import com.spring.shoppingmall.vo.ProductGroupProductVo;

public interface ShoppingMallService {

	public int insertPatterns(Integer productGroupIdx, List<PatternRegistrationRequestDto> patterns) throws Exception;
	
	public int insertProductRestrations(ProductGroupProductVo[] products) throws Exception;
}
