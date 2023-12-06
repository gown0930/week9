<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>

<%
    // 현재 세션 가져오기
    HttpSession currentSession = request.getSession(false);

    if (currentSession != null) {
        // 세션 무효화
        currentSession.invalidate();
        out.println("로그아웃되었습니다.");
    } else {
        out.println("이미 로그아웃되었거나 세션이 만료되었습니다.");
    }

    // 로그인 페이지로 리다이렉트
    response.sendRedirect("../index.jsp");
%>