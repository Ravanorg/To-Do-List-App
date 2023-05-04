package lk.ijse.dep10.todo.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(urlPatterns = "/tasks")
public class taskServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        var description = req.getParameter("description");
        if (description == null || description.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        var dbcp = (BasicDataSource) getServletContext().getAttribute("dbcp");
        try (var connection = dbcp.getConnection()) {
            var stm = connection.prepareStatement("insert into task values(?,default)");
            stm.setString(1, description);
            stm.executeUpdate();

            getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


    }
}
