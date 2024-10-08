package com.spring.shoppingmall.service;

import java.util.List;

import com.spring.shoppingmall.dto.PatternRegistrationRequestDto;

public interface ShoppingMallService {

	public int insertPatterns(Integer productGroupIdx, List<PatternRegistrationRequestDto> patterns) throws Exception;
}
