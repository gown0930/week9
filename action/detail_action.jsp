<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%
String timeInput = request.getParameter("timeInput");
String eventInput = request.getParameter("eventInput");

// 콘솔에 출력
out.println("Received Time: " + timeInput);
out.println("Received Event: " + eventInput);
%>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
</head>
<body>
</body>