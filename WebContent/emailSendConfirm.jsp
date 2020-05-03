<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<jsp:include page="./include/head.jsp" />
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 해주세요.');");
			script.println("location.href = 'userLogin.jsp");
			script.println("</script>");
			script.close();
			return;
		}
	%>
	<jsp:include page="./include/header.jsp" />
	<section class="container mt-3" style="max-width: 560px">
		<div class="alert alert-warning mt-4" role="alert">
			이메일 주소 인증을 하셔야 이용가능합니다. 인증 메일을 받지 못하셨나요?
		</div>
		<a href="emailSendAction.jsp" class="btn btn-primary">인증 메일 다시 받기</a>
	</section>
	<jsp:include page="./include/footer.jsp" />
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery-3.4.1.min.js"></script>
	<script src="./js/popper.min.js"></script>
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>