<%@ page import="org.apache.commons.dbcp2.BasicDataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.mysql.cj.protocol.Resultset" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="lk.ijse.dep10.todo.model.Task" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%!
    private ArrayList<Task> getTaskList(ResultSet rst) throws SQLException {
        ArrayList<Task> taskList = new ArrayList<>();
        while (rst.next()) {
            var id = rst.getInt("id");
            var description = rst.getString("description");
            var status = rst.getString("status");
            taskList.add(new Task(id, description, Task.Status.valueOf(status)));
        }
        return taskList;
    }

%>

<%
    BasicDataSource dbcp = (BasicDataSource) application.getAttribute("dbcp");
    try (Connection connection = dbcp.getConnection()) {
        var statement = connection.createStatement();
        ResultSet rst1 = statement.executeQuery("SELECT  * from task where status='not_completed'");
        var taskList = getTaskList(rst1);
        ResultSet rst2 = statement.executeQuery("SELECT  * from task where status='completed'");
        var completedTaskList = getTaskList(rst2);
        request.setAttribute("taskList", taskList);
        request.setAttribute("completedTaskList",completedTaskList);
    }catch (SQLException e) {
        throw new RuntimeException(e);
    }

%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"
          name="viewport">
    <meta content="ie=edge" http-equiv="X-UA-Compatible">
    <title>To Do List App</title>
    <link href="css/reset.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link crossorigin href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800;900&display=swap"
          rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
          rel="stylesheet"/>
    <link href="css/styles.css" rel="stylesheet">
</head>
<body>
<header>
    <h1><span class="material-symbols-outlined">
task_alt
</span>
        To-do List App</h1>
    <form action="">
        <input placeholder="Enter a new task(Eg:Finalize the Design)" type="text">
        <button>Add New Task</button>
    </form>
</header>
<main>

    <section id="tasks">
        <c:if test="${empty taskList and empty completedTaskList}">
        <div id="hint">Please add a new task!</div>
        </c:if>
        <c:if test="${empty taskList and !empty completedTaskList}">
            <div id="hint">No more tasks to Complete!</div>
        </c:if>
        <c:forEach var="task" items="${taskList}">
        <div class="task">
            <a href="">
                <label>
                    <input type="checkbox">${task.description}
                </label>
            </a>
            <a href="" title="Delete Task">
            <span class="material-symbols-outlined">
                delete
            </span>
            </a>
        </div>
        </c:forEach>

    </section>
    <c:if test="${!empty completedTaskList}">
        <section id="completed-task">
            <h2>Completed Tasks</h2>

            <c:forEach var="task" items="${completedTaskList}">
                <div class="task completed">
                    <a href="">
                        <label>
                            <input type="checkbox">${task.description}
                        </label>
                    </a>
                    <a href="" title="Delete Task">
            <span class="material-symbols-outlined">
                delete
            </span>
                    </a>
                </div>
            </c:forEach>


        </section>
    </c:if>

</main>
<footer>
    Copyright &copy; 2023. All Rights Reserved
</footer>

</body>
</html>