<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>��ȹ�� ��� ���� ���</title>
</head>
<body>

<table border="1" align="center">
	<tr>
		<td>��ȹ����</td>
		<td><input type="text"></td>
	</tr>
	<tr>
		<td>����Ÿ��</td>
		<td>
			<select>
				<option value="img1">2���̹���</option>
				<option value="img2">4���̹���</option>
				<option value="text">�ؽ�Ʈ</option>
				<option value="movie">������</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>���� ����</td>
		<td><input type="number"></td>
	</tr>
	<tr>
		<td>���� ���ÿ���</td>
		<td><input type="checkbox"></td>
	</tr>
</table>

</body>
</html>