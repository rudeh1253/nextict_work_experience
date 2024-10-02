package com.spring.shoppingmall.dao;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.spring.shoppingmall.vo.ProductGroupInfoVo;

public interface ShoppingMallDao {

	public int saveProductGroup(ProductGroupInfoVo productGroupInfoVo, MultipartFile prdGrImg, Model model);

}
