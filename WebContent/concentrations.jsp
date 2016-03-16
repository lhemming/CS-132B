<%@ page import="java.sql.*" %>
<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    DriverManager.registerDriver
                        (new com.microsoft.sqlserver.jdbc.SQLServerDriver());
    
                    // Make a connection to the Oracle datasource "cse132b"
                    Connection conn = DriverManager.getConnection
                        ("jdbc:sqlserver://LENOVO-PC\\SQLEXPRESS:1433;databaseName=db2","sa","password1");

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Concentrations VALUES (?, ?, ?, ?)");
                        pstmt.setString(1, request.getParameter("CONCID"));
                        pstmt.setString(2, request.getParameter("CONCNAME"));
                        pstmt.setString(3, request.getParameter("COURSEID")); 
                        pstmt.setString(4, request.getParameter("DEPARTMENT"));
                        //add other items depending on undergrad/grad/phd
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE concentrations SET CONCNAME = ?, COURSEID = ?, DEPARTMENT = ?"
                            + " WHERE CONCID = ?");

                        
                        pstmt.setString(1, request.getParameter("CONCNAME"));
                        pstmt.setString(2, request.getParameter("COURSEID")); 
                        pstmt.setString(3, request.getParameter("DEPARTMENT"));
                        pstmt.setString(4, request.getParameter("CONCID"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM concentrations WHERE CONCID = ?");

                        pstmt.setString(1, request.getParameter("CONCID"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM concentrations");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Concentration ID</th>
                        <th>Concentration Name</th>
                        <th>Course ID</th>
                        <th>Department</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="concentrations.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="CONCID" size="19"></th>
                            <th><input value="" name="CONCNAME" size="22"></th>
                            <th><input value="" name="COURSEID" size="16"></th>
                            <th><input value="" name="DEPARTMENT" size="16"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="concentrations.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("CONCID") %>" 
                                    name="CONCID" size="19">
                            </td>
    
                            <%-- Get theSTUDENTID --%>
                            <td>
                                <input value="<%= rs.getString("CONCNAME") %>" 
                                    name="CONCNAME" size="22">
                            </td>
    
                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("COURSEID") %>"
                                    name="COURSEID" size="16">
                            </td>
                            <td>
                                <input value="<%= rs.getString("DEPARTMENT") %>"
                                    name="DEPARTMENT" size="16">
                            </td>
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="concentrations.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("CONCID") %>" name="CONCID">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>
