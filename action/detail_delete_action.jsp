<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
request.setCharacterEncoding("UTF-8");

String scheduleId = request.getParameter("scheduleId");
String user_idx = request.getParameter("user_idx");
String year = request.getParameter("year");
String month = request.getParameter("month");
String day = request.getParameter("day");

Connection connection = null;
PreparedStatement deleteStatement = null;

try {
    connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/week10", "haeju", "0930");

    // DELETE 쿼리 작성
    String deleteQuery = "DELETE FROM schedule WHERE idx = ?";
    deleteStatement = connection.prepareStatement(deleteQuery);
    deleteStatement.setInt(1, Integer.parseInt(scheduleId));

    // 쿼리 실행
    deleteStatement.executeUpdate();

    response.sendRedirect("../jsp/detail.jsp?user_idx=" + user_idx + "&year=" + year + "&month=" + month + "&day=" + day);

} catch (SQLException e) {
    e.printStackTrace();
} finally {
    // 사용한 자원 해제
    if (deleteStatement != null) {
        try {
            deleteStatement.close();
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

</body>