<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>
<%
   // JSP 영역
   request.setCharacterEncoding("utf-8");
   String nameValue = request.getParameter("name");
   String idValue = request.getParameter("id");
   String phonenumValue = request.getParameter("phone_num");
   String cleanPhoneNumber = phonenumValue.replaceAll("[^0-9]", "");

   // 커넥터 파링 찾는 부분
   Class.forName("com.mysql.jdbc.Driver");
   // 데이터베이스 연결
   Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week10", "haeju", "0930");
   // SQL 만들기
   String sql = "SELECT * FROM user WHERE name=? AND id=? AND phone_num=?";
   PreparedStatement query = connect.prepareStatement(sql);
   query.setString(1, nameValue);
   query.setString(2, idValue);
   query.setString(3, cleanPhoneNumber);

   // SQL 전송
   ResultSet result = query.executeQuery();

   // 데이터 정제
   String name = null;
   String id = null;
   String phone_num = null;
   String password = null;

   if (result.next()) {
       name = result.getString("name");
       id = result.getString("id");
       password = result.getString("password");
       phone_num = result.getString("phone_num");
   }

   // 리다이렉션 조건 확인
   if (name == null || id == null || phone_num==null) {
      session.setAttribute("errorMessage", "정보가 존재하지 않습니다.");
      response.sendRedirect("../jsp/find_password.jsp");
  } else {
      session.setAttribute("loginMessage", "비밀번호: " + password);
      response.sendRedirect("../index.jsp");
  }
%>


<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>아이디 찾기</title>
</head>
<body>

</body>