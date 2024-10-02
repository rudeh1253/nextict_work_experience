<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>MBTI �˻�</title>
<script type="text/javascript">
	const questionTypes = [];
	<c:forEach var="elem" items="${questionTypes}">
		questionTypes.push("${elem}");
	</c:forEach>
	
	const questionNum = ${questions.size()};
	
	$j(document).ready(function() {
		$j("#submitButton").on("click", function(e) {
			const requestData = [];
			$j(".questionInput:checked")
				.each(function(idx, e) {
					const jElem = $j(e);
					const [type, num] = jElem.attr("name").split("_");
					const value = jElem.val();
					
					requestData.push({
						boardType: type,
						boardNum: parseInt(num),
						score: parseInt(value)
					});
				});
			
			const isFinal = $j(e.target).data("is-final") === true;
			$j.ajax({
				url: "${pageContext.request.contextPath}/mbti/submitAnswerList.do",
				type: "POST",
				dataType: "json",
				contentType: "application/json; charset=euc-kr",
				data: JSON.stringify(requestData),
				success: function(data, textStatus, jqXHR) {
					if (isFinal) {
						window.location.href = "${pageContext.request.contextPath}/mbti/mbtiResultView.do";
					} else {
						if (questionTypes.length === 0) {
							window.location.href = "${pageContext.request.contextPath}/mbti/questionList.do";
							return;
						}
						window.location.href = "${pageContext.request.contextPath}/mbti/questionList.do?currentQuestionType=" + questionTypes[0];
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					alert("��� �ҷ�");
				}
			});
		});
		
		enableSubmitButtonWhenAllQuestionsAnswered();
		
		$j(".questionInput").on("change", function() {
			enableSubmitButtonWhenAllQuestionsAnswered();
		});
	});
	
	function enableSubmitButtonWhenAllQuestionsAnswered() {
		console.log($j(".questionInput:checked").length);
		$j("#submitButton").attr("disabled", $j(".questionInput:checked").length < questionNum);
	}
</script>
</head>
<body>
	<table align="center">
		<c:forEach var="questionUnit" items="${questions}">
			<tr align="center">
				<td colspan="3">
					${questionUnit.boardComment}
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="left">����</td>
				<td align="center">
					<c:forEach var="sVar" begin="0" end="6" step="1">
						<input type="radio"
							class="questionInput"
							name="${questionUnit.boardType}_${questionUnit.boardNum}"
							value="${7 - sVar}">
					</c:forEach>
				</td>
				<td align="left">����</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		</c:forEach>
		<tr align="center">
			<td colspan="3">
				<button id="submitButton" type="button" data-is-final="${isFinal}">
					<c:if test="${isFinal}">
						��� ����
					</c:if>
					<c:if test="${!isFinal}">
						����
					</c:if>
				</button>
			</td>
		</tr>
	</table>
</body>
</html>