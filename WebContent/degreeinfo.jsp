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
                        ("jdbc:sqlserver://LENOVO-PC\\SQLEXPRESS:1433;databaseName=db1","sa","password1");

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
                            "INSERT INTO Enrolled VALUES (?, ?, ?, ?, ?)"); //" ?, ?, ?)");

                       /* PreparedStatement pstmt2 = conn.prepareStatement(
                        "SELECT * FROM Courses WHERE COURSEID = "+var_courseid);
*/
                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        // if course has multiple sections, prompt for section
                        pstmt.setString(2, request.getParameter("COURSEID"));

                        pstmt.setString(3, request.getParameter("SECTIONID"));
                        // if course can have variable units, prompt for # of units
                        pstmt.setString(4, request.getParameter("UNITS"));
                        pstmt.setString(5, request.getParameter("GRADETYPE"));

                        //pstmt.setString(4, request.getParameter("PREVCLASSES"));
                        //pstmt.setString(4, request.getParameter("CURRCLASSES"));
                        //pstmt.setString(6, request.getParameter("FUTURECLASSES"));
                        //previous course #'s / date changed?
/*
                        rset = stmt.executeQuery("SELECT * FROM Course WHERE COURSEID = '"+request.getParameter("COURSEID")+"';");
                        if (!rset.first() ) {
                            pstmt.setString(3, request.getParameter("SECTIONID"));
                            // if course can have variable units, prompt for # of units
                            pstmt.setString(4, request.getParameter("UNITS"));
                            pstmt.setString(5, request.getParameter("GRADETYPE"));
                        }
*/
                        System.out.println(request.getParameter("STUDENTID"));
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
                            "UPDATE Enrolled SET SECTIONID = ?, UNITS = ?, GRADETYPE = ? WHERE STUDENTID = ? AND COURSEID = ?");
                            //"SECTIONID = ?, ENROLL_LIMIT = ?, QUARTER = ? WHERE COURSEID = ?");

                        pstmt.setString(1, request.getParameter("SECTIONID"));
                        pstmt.setString(2, request.getParameter("UNITS"));
                        pstmt.setString(3, request.getParameter("GRADETYPE"));
                        pstmt.setString(5, request.getParameter("STUDENTID"));
                        pstmt.setString(6, request.getParameter("COURSEID"));

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
                            "DELETE FROM Enrolled WHERE STUDENTID = ? AND COURSEID = ?");

                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setString(2, request.getParameter("COURSEID"));

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
                        ("SELECT * FROM Enrolled");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Student Id</th>
                        <th>Course Id</th>
                        <th>Section Id</th>
                        <td>Units</td>
                        <td>Grade Type</td>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="enrolled.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="COURSEID" size="50"></th>
                            <th><input value="" name="SECTIONID" size="25"></th>
                            <th><input value="" name="UNITS" size="10"></th>
                            <th><select name="GRADETYPE">
                                <option value="LETTER">LETTER</option>
                                <option value="PNP">P/NP</option>
                              </select></th>   
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="enrolled.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("STUDENTID") %>" 
                                    name="STUDENTID" size="10">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("COURSEID") %>" 
                                    name="COURSEID" size="50">
                            </td>
    
                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("SECTIONID") %>"
                                    name="SECTIONID" size="25">
                            </td>

                            < %-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("UNITS") %>"
                                    name="UNITS" size="25">
                            </td>
                            <%-- Get the FIRSTNAME --%>
                           /* <td><select name="GRADETYPE" style="float : right">
                                    <option value="LETTER"> Letter </option>
                                    <option value="PNP"> P/NP </option>
                                </select></td>
*/
                            <td>
                                <input value="<%= rs.getString("GRADETYPE") %>"
                                    name="GRADETYPE" size="25">
                            </td>

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="enrolled.jsp" method="get">
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
