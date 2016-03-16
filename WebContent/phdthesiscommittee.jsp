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

                    //resultset =statement.executeQuery("SELECT * FROM COURSE") ;
                    //if( )

                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO ThesisCommittee VALUES (?, ?, ?, ?, ?, ?)"); 

                        // Student can only have one thesis committee. Use STUDENTID as unique key.
                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setString(2, request.getParameter("DEPARTMENT"));
                        
                        // Must have 3 advisors from the student's department
                        // ** want to check this in the database. how?
                        pstmt.setString(3, request.getParameter("ADVISOR1"));
                        pstmt.setString(4, request.getParameter("ADVISOR2"));
                        pstmt.setString(5, request.getParameter("ADVISOR3"));

                        // MS students do not have to have advisor from diff department
                        pstmt.setString(6, request.getParameter("ADVISOR4"));

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
                            "UPDATE ThesisCommittee SET DEPARTMENT = ?, ADVISOR1 = ?, ADVISOR2 = ?, "
                            + "ADVISOR3 = ?, ADVISOR4 = ? WHERE STUDENTID = ?");

                        pstmt.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt.setString(2, request.getParameter("ADVISOR1"));
                        pstmt.setString(3, request.getParameter("ADVISOR2"));
                        pstmt.setString(4, request.getParameter("ADVISOR3"));
                        pstmt.setString(5, request.getParameter("ADVISOR4"));
                        pstmt.setString(6, request.getParameter("STUDENTID"));

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
                            "DELETE FROM ThesisCommittee WHERE STUDENTID = ? AND DEPARTMENT = ?");

                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setString(2, request.getParameter("DEPARTMENT"));

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
                        ("SELECT * FROM ThesisCommittee");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Student Id</th>
                        <th>Department</th>
                        <th>Advisor 1</th>
                        <td>Advisor 2</td>
                        <td>Advisor 3</td>
                        <td>Advisor 4 (from outside department)</td>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="phdthesiscommittee.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="DEPARTMENT" size="25"></th>
                            <th><input value="" name="ADVISOR1" size="15"></th>
                            <th><input value="" name="ADVISOR2" size="15"></th>
                            <th><input value="" name="ADVISOR3" size="15"></th> 
                            <th><input value="" name="ADVISOR4" size="15"></th> 
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="msthesiscommittee.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("STUDENTID") %>" 
                                    name="STUDENTID" size="10">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("DEPARTMENT") %>" 
                                    name="DEPARTMENT" size="25">
                            </td>
    
                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("ADVISOR1") %>"
                                    name="ADVISOR1" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("ADVISOR2") %>"
                                    name="ADVISOR2" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("ADVISOR3") %>"
                                    name="ADVISOR3" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("ADVISOR4") %>"
                                    name="ADVISOR4" size="15">
                            </td>

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="phdthesiscommittee.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("STUDENTID") %>" name="STUDENTID">
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
