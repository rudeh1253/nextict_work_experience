<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>MBTI �˻� ���</title>
<script type="text/javascript">
	const isCompleted = ${isCompleted};
	if (!isCompleted) {
		alert("�˻簡 ������� �ʾҽ��ϴ�. �˻縦 ���� ������ �ּ���");
		window.location.href = "${pageContext.request.contextPath}/mbti/questionList.do";
	}
</script>
</head>
<body>
	<table align="center">
		<tr align="center">
			<td>����� ���� ������:</td>
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
					�ٽ��ϱ�
				</a>
			</td>
		</tr>
	</table>
</body>
</html>