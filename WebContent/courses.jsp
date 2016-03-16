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
                            "INSERT INTO Course VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("COURSEID"));
                        pstmt.setString(2, request.getParameter("DEPARTMENT"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("UNITMIN")));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("UNITMAX")));
                        pstmt.setString(5, request.getParameter("GRADETYPE"));
                        pstmt.setString(6, request.getParameter("PREREQS"));
                        pstmt.setString(7, request.getParameter("LABREQ"));
                        pstmt.setString(8, request.getParameter("CONSENTREQ"));
                        pstmt.setString(9, request.getParameter("CATEGORY"));
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
                            "UPDATE Course SET DEPARTMENT = ?, UNITMIN = ?, UNITMAX = ?, " +
                            "LABREQ = ?, GRADETYPE = ?, PREREQS = ?, CONSENTREQ = ?, CATEGORY = ? WHERE COURSEID = ?");

                        pstmt.setString(1, request.getParameter("DEPARTMENT"));    
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("UNITMIN")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("UNITMAX")));
                        pstmt.setString(4, request.getParameter("GRADETYPE"));
                        pstmt.setString(5, request.getParameter("PREREQS"));
                        pstmt.setString(6, request.getParameter("LABREQ"));
                        pstmt.setString(7, request.getParameter("CONSENTREQ"));
                        pstmt.setString(8, request.getParameter("CATEGORY"));
                        pstmt.setString(9, request.getParameter("COURSEID"));

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
                            "DELETE FROM Course WHERE COURSEID = ?");

                        pstmt.setString(1, request.getParameter("COURSEID"));
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
                        ("SELECT * FROM Course");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Course Id</th>
                        <th>Department</th>
                        <th>Category</th>
                        <th>Unit Min</th>
                        <th>Unit Max</th>
                        <th>Grade Type</th>
                        <th>Prereqs?</th>
                        <th>Lab Required?</th>
                        <th>Consent Required?</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="COURSEID" size="10"></th>
                            <th><input value="" name="DEPARTMENT" size="10"></th>
                            <th><input value="" name="CATEGORY" size="10"></th> 
                            <th><input value="" name="UNITMIN" size="10"></th>
                            <th><input value="" name="UNITMAX" size="15"></th>
                            <th><select name="GRADETYPE">
                                <option value="LETTER">Letter</option>
                                <option value="PNP">P/NP</option>
                                <option value="BOTH">Letter or P/NP</option>
                              </select></th> 
                            <th><input type="radio" name="PREREQS" value="True" checked>Yes<br>
                                <input type="radio" name="PREREQS" value="False" checked>No<br>
                            </th>
                            <th><input type="radio" name="LABREQ" value="True" checked>Yes<br>
                                <input type="radio" name="LABREQ" value="False" checked>No<br>
                            </th>
                            <th><input type="radio" name="CONSENTREQ" value="True" checked>Yes<br>
                                <input type="radio" name="CONSENTREQ" value="False" checked>No<br>
                            </th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("COURSEID") %>" 
                                    name="COURSEID" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("DEPARTMENT") %>" 
                                    name="DEPARTMENT" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("CATEGORY") %>" 
                                    name="CATEGORY" size="10">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getInt("UNITMIN") %>" 
                                    name="UNITMIN" size="10">
                            </td>
    
                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getInt("UNITMAX") %>"
                                    name="UNITMAX" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("GRADETYPE") %>" 
                                    name="GRADETYPE" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("PREREQS") %>" 
                                    name="PREREQS" size="10">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("LABREQ") %>" 
                                    name="LABREQ" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("CONSENTREQ") %>" 
                                    name="CONSENTREQ" size="10">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("COURSEID") %>" name="COURSEID">
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

