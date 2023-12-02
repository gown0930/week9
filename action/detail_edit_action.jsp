<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
request.setCharacterEncoding("UTF-8");

String scheduleId = request.getParameter("scheduleId");
String editedTime = request.getParameter("editTimeInput")+ ":00";
String editedEvent = request.getParameter("editEventInput");

String user_idx = request.getParameter("user_idx");
String year = request.getParameter("year");
String month = request.getParameter("month");
String day = request.getParameter("day");

Connection connection = null;
PreparedStatement updateStatement = null;
ResultSet resultSet = null;

try {
    connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/week10", "haeju", "0930");

    // 현재 일정의 시간과 내용을 가져오기 위한 SELECT 쿼리
    String selectQuery = "SELECT time, content FROM schedule WHERE idx = ?";
    PreparedStatement selectStatement = connection.prepareStatement(selectQuery);
    selectStatement.setInt(1, Integer.parseInt(scheduleId));
    resultSet = selectStatement.executeQuery();

    // 가져온 시간과 내용을 변수에 저장
    String currentTime = "";
    String currentContent = "";

    if (resultSet.next()) {
        currentTime = resultSet.getString("time");
        currentContent = resultSet.getString("content");
    }

    // UPDATE 쿼리 작성
    String updateQuery = "UPDATE schedule SET time = ?, content = ? WHERE idx = ?";
    updateStatement = connection.prepareStatement(updateQuery);
    updateStatement.setTime(1, java.sql.Time.valueOf(editedTime));
    updateStatement.setString(2, editedEvent);
    updateStatement.setInt(3, Integer.parseInt(scheduleId));

    // 쿼리 실행
    updateStatement.executeUpdate();

    response.sendRedirect("../jsp/detail.jsp?user_idx=" + user_idx + "&year=" + year + "&month=" + month + "&day=" + day);

} catch (SQLException e) {
    e.printStackTrace();
} finally {
    // 사용한 자원 해제
    if (resultSet != null) {
        try {
            resultSet.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if (updateStatement != null) {
        try {
            updateStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if (connection != null) {
        try {
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
%>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
</head>
<body>
   <div>
       Received Time: <%= editedTime %>
   </div>
   <div>
       Received Event: <%= editedEvent %>
   </div>
   <%=scheduleId %>
</body>