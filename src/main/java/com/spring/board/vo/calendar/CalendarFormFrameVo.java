package com.spring.board.vo.calendar;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;

public class CalendarFormFrameVo {
	private static final int DEFAULT_FORM_ROW_IDX = 1;
	private static final int DEFAULT_FORM_COL_IDX = 1;
	private static final int DEFAULT_FORM_WIDTH = 3;
	private static final int DEFAULT_FORM_HEIGHT = 4;
	
	private CellStyle[][] formStyle;
	private int formWidth = DEFAULT_FORM_WIDTH;
	private int formHeight = DEFAULT_FORM_HEIGHT;
	
	public void setFormStyle(CellStyle[][] cellStyle) {
		this.formStyle = cellStyle;
	}
	
	public CellStyle[][] getFormStyle() {
		return this.formStyle;
	}
	
	public CellStyle getCellStyleAt(int rowIdx, int colIdx) {
		return this.formStyle[rowIdx][colIdx];
	}
	
	public void readFormStyle(HSSFWorkbook workbook) {
		Sheet sheet = workbook.getSheetAt(0);
		this.formStyle = new CellStyle[DEFAULT_FORM_HEIGHT][DEFAULT_FORM_WIDTH];
		for (int i = 0; i < DEFAULT_FORM_HEIGHT; i++) {
			Row row = sheet.getRow(i + DEFAULT_FORM_ROW_IDX);
			for (int j = 0; j < DEFAULT_FORM_WIDTH; j++) {
				Cell cell = row.getCell(j + DEFAULT_FORM_COL_IDX);
				if (cell != null) {
					this.formStyle[i][j] = cell.getCellStyle();
				} else {
					this.formStyle[i][j] = workbook.createCellStyle();
				}
			}
		}
	}
	
	public int getFormWidth() {
		return this.formWidth;
	}
	
	public void setFormWidth(int formWidth) {
		this.formWidth = formWidth;
	}
	
	public int getFormHeight() {
		return this.formHeight;
	}
	
	public void setFormHeight(int formHeight) {
		this.formHeight = formHeight;
	}
}
