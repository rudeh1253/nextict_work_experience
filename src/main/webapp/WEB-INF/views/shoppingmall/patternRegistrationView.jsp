<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>기획전 상단 패턴 등록</title>
</head>
<body>

<table border="1" align="center">
	<tr>
		<td>기획전명</td>
		<td><input type="text"></td>
	</tr>
	<tr>
		<td>패턴타입</td>
		<td>
			<select>
				<option value="img1">2단이미지</option>
				<option value="img2">4단이미지</option>
				<option value="text">텍스트</option>
				<option value="movie">동영상</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>패턴 순서</td>
		<td><input type="number"></td>
	</tr>
	<tr>
		<td>패턴 전시여부</td>
		<td><input type="checkbox"></td>
	</tr>
</table>

</body>
</html>