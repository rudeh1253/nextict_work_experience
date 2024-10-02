package com.spring.shoppingmall.service;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.spring.shoppingmall.vo.ProductGroupInfoVo;

public interface ShoppingMallService {

	public int saveProductGroup(ProductGroupInfoVo productGroupInfoVo, MultipartFile prdGrImg, Model model);

}
