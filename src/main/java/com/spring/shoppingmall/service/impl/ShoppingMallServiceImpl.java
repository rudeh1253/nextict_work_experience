package com.spring.shoppingmall.service.impl;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.Base64.Decoder;
import java.util.List;

import javax.servlet.ServletContext;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.spring.shoppingmall.dao.ShoppingMallDao;
import com.spring.shoppingmall.dto.PatternDetailRequestDto;
import com.spring.shoppingmall.dto.PatternRegistrationRequestDto;
import com.spring.shoppingmall.service.ShoppingMallService;
import com.spring.shoppingmall.vo.ProductGroupProductVo;
import com.spring.shoppingmall.vo.ProductPatternDetail;
import com.spring.shoppingmall.vo.ProductPatternInfo;

@Service
public class ShoppingMallServiceImpl implements ShoppingMallService {
	
	@Autowired
	private ShoppingMallDao shoppingMallDao;
	
	@Autowired
	ServletContext servletContext;

	@Override
	public int insertPatterns(Integer productGroupIdx, List<PatternRegistrationRequestDto> patterns) throws Exception {
		int rowCount = 0;
		for (PatternRegistrationRequestDto pattern : patterns) {
			ProductPatternInfo productPatternInfo = new ProductPatternInfo();
			BeanUtils.copyProperties(productPatternInfo, pattern);
			productPatternInfo.setProductGroupIdx(productGroupIdx);
			
			System.out.println(productPatternInfo);
			
			rowCount += this.shoppingMallDao.insertPattern(productPatternInfo);
			
			for (PatternDetailRequestDto detail : pattern.getPatternDetails()) {
				ProductPatternDetail productPatternDetail = new ProductPatternDetail();
				BeanUtils.copyProperties(productPatternDetail, detail);
				productPatternDetail.setProductGroupIdx(productGroupIdx);
				productPatternDetail.setProductPatternIdx(productPatternInfo.getProductPatternIdx());
				productPatternDetail.setPtDetailImg(detail.getPtDetailImageName());
				
				System.out.println(productPatternDetail);
				
				if (StringUtils.hasText(detail.getPtDetailImageDataInBase64())) {
					saveFileToLocal(detail.getPtDetailImageName(), detail.getPtDetailImageDataInBase64());
				}
				
				rowCount += this.shoppingMallDao.insertPatternDetail(productPatternDetail);
			}
		}
		return rowCount;
	}
	
	private void saveFileToLocal(String filename, String dataInBase64) throws IOException {
		String imageDirRealPath = this.servletContext.getRealPath("/images");
		
		System.out.println("imageDirRealPath=" + imageDirRealPath);
		
		Decoder base64Decoder = Base64.getDecoder();
		byte[] binaryData = base64Decoder.decode(dataInBase64);
		
		try (BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(imageDirRealPath + "/" + filename))) {
			bos.write(binaryData);
		}
	}
	
	@Override
	public int insertProductRestrations(ProductGroupProductVo[] products) throws Exception {
		int row = 0;
		for (ProductGroupProductVo product : products) {
			row += this.shoppingMallDao.insertProductGroupProductVo(product);
		}
		return row;
	}
}
