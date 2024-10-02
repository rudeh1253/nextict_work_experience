package com.spring.board.vo.calendar;

import java.time.DayOfWeek;

import org.apache.poi.ss.usermodel.CellStyle;

public class CalendarCellDataVo<D> {
	private int rowIdx;
	private int colIdx;
	private D value;
	private CellStyle cellStyle;
	private DayOfWeek dayOfWeek;
	
	public CalendarCellDataVo(int rowIdx, int colIdx, CellStyle cellStyle, DayOfWeek dayOfWeek) {
		this.rowIdx = rowIdx;
		this.colIdx = colIdx;
		this.cellStyle = cellStyle;
		this.dayOfWeek = dayOfWeek;
	}

	public int getRowIdx() {
		return rowIdx;
	}

	public int getColIdx() {
		return colIdx;
	}

	public D getValue() {
		return value;
	}
	
	public void setValue(D value) {
		this.value = value;
	}

	public CellStyle getCellStyle() {
		return cellStyle;
	}

	public DayOfWeek getDayOfWeek() {
		return dayOfWeek;
	}

	@Override
	public String toString() {
		return "CalendarCellVo [rowIdx=" + rowIdx + ", colIdx=" + colIdx + ", value=" + value + ", cellStyle="
				+ cellStyle + "]";
	}
}
