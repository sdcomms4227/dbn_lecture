<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
%>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<a class="navbar-brand" href="index.jsp">강의평가 웹 사이트</a>
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
		<span class="navbar-toggler-icon"></span>
	</button>
	<div id="navbar" class="collapse navbar-collapse">
		<ul class="navbar-nav mr-auto">
			<li class="nav-item">
				<a href="index.jsp" class="nav-link">메인</a>
			</li>
			<li class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown"> 회원 관리 </a>
				<div class="dropdown-menu" aria-labelledby="dropdown">
					<%
						if (userID == null) {
					%>
					<a href="userLogin.jsp" class="dropdown-item">로그인</a>
					<a href="userJoin.jsp" class="dropdown-item">회원가입</a>
					<%
						} else {
					%>
					<a href="userLogout.jsp" class="dropdown-item">로그아웃</a>
					<%
						}
					%>
				</div>
			</li>
		</ul>
		<form action="./index.jsp" class="form-inline my-2 my-lg-0">
			<input type="text" name="search" class="form-control mr-sm-2" placeholder="내용을 입력하세요." aria-label="search" />
			<button type="submit" class="btn btn-outline-success my-2 my-sm-0">검색</button>
		</form>
	</div>
</nav>