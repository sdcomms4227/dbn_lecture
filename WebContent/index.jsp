<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
<jsp:include page="include/head.jsp" />
<body>
	<%
		request.setCharacterEncoding("UTF-8");
		String lectureDivide = "전체";
		String searchType = "최신순";
		String search = "";
		int pageNumber = 0;
		if(request.getParameter("lectureDivide")!=null){
			lectureDivide = request.getParameter("lectureDivide");
		}
		if(request.getParameter("searchType")!=null){
			searchType = request.getParameter("searchType");
		}
		if(request.getParameter("search")!=null){
			search = request.getParameter("search");
		}
		if(request.getParameter("pageNumber")!=null){
			try{
				pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
			}catch(Exception e){
				System.out.println("검색 페이지 번호 오류");
			}
		}
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 해주세요.');");
			script.println("location.href = 'userLogin.jsp';");
			script.println("</script>");
			script.close();
			return;
		}
		boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
		if (emailChecked == false) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'emailSendConfirm.jsp';");
			script.println("</script>");
			script.close();
			return;
		}
	%>
	<jsp:include page="./include/header.jsp" />
	<section class="container">
		<form method="get" action="./index.jsp" class="form-inline mt-3">
			<select name="lectureDivide" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="전공" <% if(lectureDivide.equals("전공")) out.println("selected"); %>>전공</option>
				<option value="교양" <% if(lectureDivide.equals("교양")) out.println("selected"); %>>교양</option>
				<option value="기타" <% if(lectureDivide.equals("기타")) out.println("selected"); %>>기타</option>
			</select>
			<select name="searchType" id="" class="form-control mx-1 mt-2">
				<option value="최신순">최신순</option>
				<option value="추천순" <% if(lectureDivide.equals("추천순")) out.println("selected"); %>>추천순</option>
			</select>
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요" />
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a href="#registerModal" class="btn btn-primary mx-1 mt-2" data-toggle="modal">등록하기</a>
			<a href="#reportModal" class="btn btn-danger mx-1 mt-2" data-toggle="modal">신고</a>
		</form>
<%
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
	evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
	if(evaluationList != null){
		for(int i=0;i<evaluationList.size();i++){
			if(i==5) break;
			EvaluationDTO evaluation = evaluationList.get(i);
%>
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">
						<%=evaluation.getLectureName()%> <small><%=evaluation.getProfessorName()%></small>
					</div>
					<div class="col-4 text-right">
						종합 <span style="color: red;"><%=evaluation.getTotalScore()%></span>
					</div>
				</div>
			</div>
			<div class="card-body">
				<h5 class="card-title">
					<%=evaluation.getEvaluationTitle()%> <small>(<%=evaluation.getLectureYear()%>)</small>
				</h5>
				<p class="card-text"><%=evaluation.getEvaluationContent()%></p>
				<div class="row">
					<div class="col-9 text-left">
						성적 <span style="color: red;"><%=evaluation.getCreditScore()%></span>
						널널 <span style="color: red;"><%=evaluation.getComfortableScore()%></span>
						강의 <span style="color: red;"><%=evaluation.getLectureScore()%></span>
						<span style="color: green">(추천:<%=evaluation.getLikeCount()%>)</span>
					</div>
					<div class="col-3 text-right">
						<%if(!userID.equals(evaluation.getUserID())){ %>
						<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>">추천</a>
						<%}else{%>
						<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>" style="color:red">삭제</a>
						<%}%>
					</div>
				</div>
			</div>
		</div>
<%
		}
	}
%>
	</section>
	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">
		<% if(pageNumber <= 0){ %>
			<a class="page-link disabled">이전</a>
		<% }else{ %>
			<a class="page-link" href="./index.jsp
				?lectureDivide=<%=URLEncoder.encode(lectureDivide,"UTF-8")%>
				&searchType=<%=URLEncoder.encode(searchType,"UTF-8")%>
				&search=<%=URLEncoder.encode(search,"UTF-8")%>
				&pageNumber=<%=pageNumber - 1%>">이전</a>
		<% } %>
		</li>
		<li class="page-item">
		<% if(pageNumber < 6){ %>
			<a class="page-link disabled">다음</a>
		<% }else{ %>
			<a class="page-link" href="./index.jsp
				?lectureDivide=<%=URLEncoder.encode(lectureDivide,"UTF-8")%>
				&searchType=<%=URLEncoder.encode(searchType,"UTF-8")%>
				&search=<%=URLEncoder.encode(search,"UTF-8")%>
				&pageNumber=<%=pageNumber + 1%>">다음</a>
		<% } %>
		</li>
	</ul>
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">평가 등록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./evaluationRegisterAction.jsp" method="post">
						<div class="form-row">
							<div class="form-group col-sm-6">
								<label for="lectureName">강의명</label>
								<input type="text" name="lectureName" id="lectureName" class="form-control" maxlength="20" />
							</div>
							<div class="form-group col-sm-6">
								<label for="professorName">교수명</label>
								<input type="text" name="professorName" id="professorName" class="form-control" maxlength="20" />
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-4">
								<label for="lectureYear">강의명</label>
								<select name="lectureYear" id="lectureYear" class="form-control">
									<option value="2011">2011</option>
									<option value="2012">2012</option>
									<option value="2013">2013</option>
									<option value="2014">2014</option>
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
									<option value="2019">2019</option>
									<option value="2020" selected>2020</option>
									<option value="2021">2021</option>
									<option value="2022">2021</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label for="semesterDivide">수강 학기</label>
								<select name="semesterDivide" id="semesterDivide" class="form-control">
									<option value="1학기">1학기</option>
									<option value="여름학기">여름학기</option>
									<option value="2학기">2학기</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label for="lectureDivide">강의 구분</label>
								<select name="lectureDivide" id="lectureDivide" class="form-control">
									<option value="전공">전공</option>
									<option value="교양">교양</option>
									<option value="기타">기타</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label for="evaluationTitle">제목</label>
							<input name="evaluationTitle" id="evaluationTitle" class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label for="evaluationContent">내용</label>
							<textarea name="evaluationContent" id="evaluationContent" class="form-control" maxlength="2048" style="height: 180px"></textarea>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-3">
								<label for="totalScore">종합</label>
								<select name="totalScore" id="totalScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label for="creditScore">성적</label>
								<select name="creditScore" id="creditScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label for="comfortableScore">널널</label>
								<select name="comfortableScore" id="comfortableScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label for="lectureScore">강의</label>
								<select name="lectureScore" id="lectureScore" class="form-control">
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
								</select>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./reportAction.jsp" method="post">
						<div class="form-group">
							<label for="reportTitle">신고 제목</label>
							<input name="reportTitle" id="reportTitle" class="form-control" maxlength="30">
						</div>
						<div class="form-group">
							<label for="reportContent">신고 내용</label>
							<textarea name="reportContent" id="reportContent" class="form-control" maxlength="2048" style="height: 180px"></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-danger">신고하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="./include/footer.jsp" />
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery-3.4.1.min.js"></script>
	<script src="./js/popper.min.js"></script>
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>