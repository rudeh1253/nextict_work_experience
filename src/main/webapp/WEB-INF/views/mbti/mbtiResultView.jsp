<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>MBTI 검사 결과</title>
<script type="text/javascript">
	const isCompleted = ${isCompleted};
	if (!isCompleted) {
		alert("검사가 시행되지 않았습니다. 검사를 먼저 수행해 주세요");
		window.location.href = "${pageContext.request.contextPath}/mbti/questionList.do";
	}
</script>
</head>
<body>
	<table align="center">
		<tr align="center">
			<td>당신의 성격 유형은:</td>
		</tr>
		<tr align="center">
			<td>
				<c:if test="${mbtiResultVo != null}">
					${mbtiResultVo.mbti1.toUpperCase()}
					${mbtiResultVo.mbti2.toUpperCase()}
					${mbtiResultVo.mbti3.toUpperCase()}
					${mbtiResultVo.mbti4.toUpperCase()}
				</c:if>
			</td>
		</tr>
		<tr align="center">
			<td>
				<a href="${pageContext.request.contextPath}/mbti/questionList.do">
					다시하기
				</a>
			</td>
		</tr>
	</table>
</body>
</html>