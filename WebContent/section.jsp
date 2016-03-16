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
                    // Load Oracle Driver class file
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
                        String instructorVal;
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Section VALUES (?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("CLASSID"));
                        pstmt.setString(2, request.getParameter("SECTIONID"));
                        pstmt.setString(3, request.getParameter("INSTRUCTOR"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("ENROLL_LIMIT")));
                        //previous course #'s / date changed?
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
                            "UPDATE Section SET INSTRUCTOR = ?, " +
                            "CLASSID = ?, ENROLL_LIMIT = ? WHERE SECTIONID = ?");

                        pstmt.setString(1, request.getParameter("INSTRUCTOR"));
                        pstmt.setString(2, request.getParameter("CLASSID"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("ENROLL_LIMIT")));
                        pstmt.setString(4, request.getParameter("SECTIONID"));

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
                            "DELETE FROM Section WHERE SECTIONID = ?");

                        pstmt.setString(1, request.getParameter("SECTIONID"));
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
                        ("SELECT * FROM Section");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Class Id</th>
                        <th>Instructor</th>
                        <th>Section Id</th>
                        <th>Enrollment Limit</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="section.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="CLASSID" size="10"></th>
                            <th><input value="" name="INSTRUCTOR" size="25"></th>
                            <th><input value="" name="SECTIONID" size="15"></th>
                            <th><input value="" name="ENROLL_LIMIT" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="section.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("CLASSID") %>" 
                                    name="CLASSID" size="10">
                            </td>

                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("INSTRUCTOR") %>"
                                    name="INSTRUCTOR" size="25">
                            </td>

                            <%-- Get the COLLEGE --%>
                            <td>
                                <input value="<%= rs.getString("SECTIONID") %>" 
                                    name="SECTIONID" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getInt("ENROLL_LIMIT") %>" 
                                    name="ENROLL_LIMIT" size="15">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="section.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("SECTIONID") %>" name="SECTIONID">
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
