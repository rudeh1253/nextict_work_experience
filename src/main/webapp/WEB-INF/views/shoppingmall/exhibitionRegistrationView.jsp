<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<meta charset="UTF-8">
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>


<html>
<head>
<meta charset="EUC-KR">
<title>기획전 등록</title>
</head>
<body>
<div class="form-container" >
    <h2>기획전 등록</h2>
    <form action="saveEvent" method="POST" enctype="multipart/form-data">
        <table>
            <tr>
                <th>기획전명</th>
                <td><input type="text" name="prdGrName" required></td>
            </tr>
            <tr>
                <th>기획전브랜드</th>
                <td>
                    <select name="prdGrBr" >
                        <option value="BEAKER">BEAKER</option>
                        <option value="BRAND_2">BRAND_2</option>
                        <option value="BRAND_3">BRAND_3</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>기획전테마</th>
                <td>
                    <select name="prdGrTm">
                        <option value="NEW_ARRIVAL">NEW ARRIVAL</option>
                        <option value="THEME_2">THEME_2</option>
                        <option value="THEME_3">THEME_3</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>기획전이미지</th>
                <td><input type="file" name="prdGrImg" required></td>
            </tr>
            <tr>
                <th>기획전시기간</th>
                <td><input type="date" name="prdGrPeriod" value="2024-01-20" required></td>
            </tr>
            <tr>
                <th>상품할인율</th>
                <td><input type="number" name="prdGrSale" value="30" min="0" max="100" step="1"> %</td>
            </tr>
            <tr>
                <th>기획전시여부</th>
                <td><input type="checkbox" name="prdGrView"></td>
            </tr>
        </table>
        <button type="submit">저장</button>
    </form>
</div>
</body>
</html>