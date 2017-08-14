<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="support/lib/jquery-3.2.0.js"></script>
        <script src="support/lib/bootstrap.min.js"></script>
        <link href="support/lib/bootstrap.min.css" rel="stylesheet">
        <link href="support/css/app.css" rel="stylesheet">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico" type="image/x-icon"/>
        <title>Self Assessment Tool</title>
    </head>
    <body>
        <div class="login">
            <h1>Login</h1>
            <form action="/login" method="post">
                <input type="text" name="username" placeholder="Username" required="required" />
                <input type="password" name="password" placeholder="Password" required="required" />
                <c:if test="${param.error ne null}">
                    <div class="sos-alert-danger">Invalid username and password.</div>
                </c:if>
                <c:if test="${param.logout ne null}">
                    <div class="sos-alert-normal">You have been logged out.</div>
                </c:if>
                <button type="submit" class="btn btn-primary btn-block btn-large">Let me in</button>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </form>
        </div>
    </body>
</html>
