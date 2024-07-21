// controller/LoginController.java
package controller;

import connection.DatabaseConnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LoginController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String employeeID = request.getParameter("employeeID");
        String password = request.getParameter("password");

        try {
            Connection conn = DatabaseConnection.getConnection();

            // Check if employeeID exists
            String checkUserQuery = "SELECT * FROM employee WHERE employeeID = ?";
            PreparedStatement checkUserPs = conn.prepareStatement(checkUserQuery);
            checkUserPs.setString(1, employeeID);
            ResultSet userRs = checkUserPs.executeQuery();

            if (!userRs.next()) {
                response.sendRedirect("login.jsp?error=User not exist");
                return;
            }

            // Verify password
            String query = "SELECT * FROM employee WHERE employeeID = ? AND employeePassword = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, employeeID);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String position = rs.getString("employeePosition");
                String employeeName = rs.getString("employeeName"); // Assuming the column name is employeeName
                request.getSession().setAttribute("employeeID", employeeID);
                request.getSession().setAttribute("employeePosition", position);
                request.getSession().setAttribute("employeeName", employeeName);

                if ("manager".equalsIgnoreCase(position)) {
                    response.sendRedirect("manager.jsp");
                } else {
                    response.sendRedirect("employee.jsp");
                }
            } else {
                response.sendRedirect("login.jsp?error=Password incorrect");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=An error occurred. Please try again.");
        }
    }
}
