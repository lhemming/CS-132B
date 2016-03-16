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
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO prevDegrees VALUES (?, ?, ?, ?, ?)"); //" ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setString(2, request.getParameter("TYPE"));
                        pstmt.setString(3, request.getParameter("TITLE"));
                        pstmt.setString(4, request.getParameter("COLLEGE"));
                        pstmt.setInt(
                            5, Integer.parseInt(request.getParameter("DEGREEID")));
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
                            "UPDATE prevDegrees SET  TYPE = ?, " +
                            "TITLE = ?, COLLEGE = ? WHERE DEGREEID = ?");

                        pstmt.setString(1, request.getParameter("TYPE"));
                        pstmt.setString(2, request.getParameter("TITLE"));
                        pstmt.setString(3, request.getParameter("COLLEGE"));
                        pstmt.setInt(
                            4, Integer.parseInt(request.getParameter("DEGREEID")));
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
                            "DELETE FROM prevDegrees WHERE DEGREEID = ?");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("DEGREEID")));
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
                        ("SELECT * FROM prevDegrees");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>DID</th>
                        <th>SID</th>
                        <th>Degree Type</th>
                        <th>Degree Title</th>
			            <th>College Name</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="prevDegrees.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="DEGREEID" size="10"></th>
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="TYPE" size="15"></th>
                            <th><input value="" name="TITLE" size="15"></th>
                            <th><input value="" name="COLLEGE" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="prevDegrees.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <td>
                                <input value="<%= rs.getInt("DEGREEID") %>"
                                    name="DEGREEID" size="10">
                            </td>
                            <%-- Get the STUDENTID, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("STUDENTID") %>" 
                                    name="STUDENTID" size="10">
                            </td>
    
                            <%-- Get the TYPE --%>
                            <td>
                                <input value="<%= rs.getString("TYPE") %>"
                                    name="TYPE" size="15">
                            </td>
                            
    
                            <%-- Get the TITLE --%>
                            <td>
                                <input value="<%= rs.getString("TITLE") %>" 
                                    name="TITLE" size="15">
                            </td>
    
			                 <%-- Get the COLLEGE --%>
                            <td>
                                <input value="<%= rs.getString("COLLEGE") %>" 
                                    name="COLLEGE" size="15">
                            </td>
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="prevDegrees.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("DEGREEID") %>" name="DEGREEID">
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
           