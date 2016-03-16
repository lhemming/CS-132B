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
                    ResultSet rset = null;
                    Statement stmt = null;

                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO PastClasses (studentid, courseid, sectionid, quarter, year, grade, gradetype) VALUES (?, ?, ?, ?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setString(2, request.getParameter("COURSEID"));
                        pstmt.setString(3, request.getParameter("SECTIONID"));
                        pstmt.setString(4, request.getParameter("QUARTER"));
                        pstmt.setString(5, request.getParameter("YEAR"));
                        pstmt.setString(6, request.getParameter("GRADE"));
                        pstmt.setString(7, request.getParameter("GRADETYPE"));

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
                            "UPDATE PastClasses SET QUARTER = ?, YEAR = ?, GRADE = ?, GRADETYPE = ?, STUDENTID = ?, COURSEID = ?, SECTIONID = ? "+
                            "WHERE pcid = ?");

                        pstmt.setString(1, request.getParameter("QUARTER"));
                        pstmt.setString(2, request.getParameter("YEAR"));
                        pstmt.setString(3, request.getParameter("GRADE"));
                        pstmt.setString(4, request.getParameter("GRADETYPE"));
                        pstmt.setString(5, request.getParameter("STUDENTID"));
                        pstmt.setString(6, request.getParameter("COURSEID"));
                        pstmt.setString(7, request.getParameter("SECTIONID"));
                        pstmt.setInt(8, Integer.parseInt(request.getParameter("pcid")));

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
                            "DELETE FROM PastClasses WHERE pcid = ?");

                        pstmt.setString(1, request.getParameter("pcid"));

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
                        ("SELECT * FROM PastClasses order by pcid");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Student Id</th>
                        <th>Course Id</th>
                        <th>Section Id</th>
                        <td>Quarter</td>
                        <td>Year</td>
                        <td>Grade</td>
                        <td>Grade Type</td>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="pastclasses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="15"></th>
                            <th><input value="" name="COURSEID" size="15"></th>
                            <th><input value="" name="SECTIONID" size="15"></th>
                            <th><input value="" name="QUARTER" size="10"></th>
                            <th><input value="" name="YEAR" size="10"></th>
                            <th><input value="" name="GRADE" size="5"></th> 
                            <th><input value="" name="GRADETYPE" size="5"></th>  
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="pastclasses.jsp" method="POST">
                            <input type="hidden" value="update" name="action">
                            <input type="hidden" name="pcid" value="<%=rs.getInt("pcid")%>"/>

                            <td>
                                <input value="<%= rs.getString("STUDENTID") %>" 
                                    name="STUDENTID" size="15">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("COURSEID") %>" 
                                    name="COURSEID" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("SECTIONID") %>"
                                    name="SECTIONID" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("QUARTER") %>"
                                    name="QUARTER" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getInt("YEAR") %>"
                                    name="YEAR" size="5">
                            </td>

                            <td>
                                <input value="<%= rs.getString("GRADE") %>"
                                    name="GRADE" size="5">
                            </td>

                            <td>
                                <input value="<%= rs.getString("GRADETYPE") %>"
                                    name="GRADETYPE" size="5">
                            </td>

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="pastclasses.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("pcid") %>" name="pcid">
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
