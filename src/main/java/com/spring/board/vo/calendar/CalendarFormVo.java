package com.spring.board.vo.calendar;

import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.Font;

public class CalendarFormVo {
	private List<CalendarCellDataVo<Integer>> cellDatum;
	private CalendarCellDataVo<Integer> dayOfMonthCellData;
	private int width;
	private int height;
	
	public static CalendarFormVo createEmpty(int startRow, int startColumn, CalendarFormFrameVo calendarFormFrame, DayOfWeek dayOfWeek) {
		List<CalendarCellDataVo<Integer>> cellDatum = new ArrayList<>();
		CalendarCellDataVo<Integer> dayOfMonthCell = null;
		int width = calendarFormFrame.getFormWidth();
		int height = calendarFormFrame.getFormHeight();
		for (int i = 0; i < height; i++) {
			int rowIdx = startRow + i;
			for (int j = 0; j < width; j++) {
				int columnIdx = startColumn + j;
				CalendarCellDataVo<Integer> calendarCellDataVo = new CalendarCellDataVo<>(rowIdx, columnIdx, calendarFormFrame.getCellStyleAt(i, j), dayOfWeek);
				if (i == 0 && j == width - 1) {
					dayOfMonthCell = calendarCellDataVo;
				}
				cellDatum.add(calendarCellDataVo);
			}
		}
		
		CalendarFormVo calendarFormVo = new CalendarFormVo();
		calendarFormVo.cellDatum = cellDatum;
		calendarFormVo.width = width;
		calendarFormVo.height = height;
		calendarFormVo.dayOfMonthCellData = dayOfMonthCell;
		return calendarFormVo;
	}

	public List<CalendarCellDataVo<Integer>> getCalendarCellDatum() {
		return cellDatum;
	}

	public void setCalendarCellDatum(List<CalendarCellDataVo<Integer>> cellDatum) {
		this.cellDatum = cellDatum;
	}
	
	public void setDayOfMonth(Integer dayOfMonth) {
		if (this.dayOfMonthCellData != null) {
			this.dayOfMonthCellData.setValue(dayOfMonth);
		}
	}
	
	public Integer getDayOfMonth() {
		return this.dayOfMonthCellData != null ? this.dayOfMonthCellData.getValue() : 0;
	}

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}

	public int getHeight() {
		return height;
	}

	public void setHeight(int height) {
		this.height = height;
	}
}
