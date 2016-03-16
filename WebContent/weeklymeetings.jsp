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
                            "INSERT INTO WeeklyMeeting VALUES (?, ?, ?, ?, ?, ?)"); //" ?, ?, ?)");

                       /* PreparedStatement pstmt2 = conn.prepareStatement(
                        "SELECT * FROM Courses WHERE COURSEID = "+var_courseid);
*/
                        pstmt.setString(1, request.getParameter("SECTIONID"));
                        // if course has multiple sections, prompt for section
                        pstmt.setString(2, request.getParameter("TYPE"));

                        pstmt.setString(3, request.getParameter("DAY"));
                        // if course can have variable units, prompt for # of units
                        pstmt.setString(4, request.getParameter("TIME"));
                        pstmt.setString(5, request.getParameter("BUILDING"));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("ROOMNO")));

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
                            "UPDATE WeeklyMeeting SET DAY = ?, TIME = ?, BUILDING = ?," +
                            " ROOMNO = ? WHERE SECTIONID = ? AND TYPE = ?");

                        pstmt.setString(1, request.getParameter("DAY"));
                        pstmt.setString(2, request.getParameter("TIME"));
                        pstmt.setString(3, request.getParameter("BUILDING"));
                        pstmt.setString(4, request.getParameter("ROOMNO"));
                        pstmt.setString(6, request.getParameter("SECTIONID"));
                        pstmt.setString(7, request.getParameter("TYPE"));
                        /** add whether mandatory or not */

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
                            "DELETE FROM WeeklyMeeting WHERE SECTIONID = ? AND TYPE = ?");

                        pstmt.setString(1, request.getParameter("SECTIONID"));
                        pstmt.setString(2, request.getParameter("TYPE"));

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
                        ("SELECT wk.SECTIONID, wk.TYPE, wk.DAY, CONVERT(varchar(7), wk.TIME, 100) AS TIME, wk.BUILDING, wk.ROOMNO "+
                         " FROM WeeklyMeeting wk");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Section Id</th>
                        <th>Meeting Type</th>
                        <th>Day</th>
                        <th>Time</th>
                        <th>Building</th>
                        <th>Room No</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="weeklymeetings.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SECTIONID" size="10"></th>
                            <th><select name="TYPE">
                                <option value="LECTURE">LECTURE</option>
                                <option value="DISCUSSION">DISCUSSION</option>
                                <option value="LAB">LAB</option>
                                </select></th>   
                            <th><input value="" name="DAY" size="10"></th>
                            <th><input value="" name="TIME" size="10"></th>
                            <th><input value="" name="BUILDING" size="15"></th>
                            <th><input value="" name="ROOMNO" size="5"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="weeklymeetings.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <td>
                                <input value="<%= rs.getString("SECTIONID") %>" 
                                    name="SECTIONID" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("TYPE") %>" 
                                    name="TYPE" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("DAY") %>"
                                    name="DAY" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("TIME") %>"
                                    name="TIME" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("BUILDING") %>"
                                    name="BUILDING" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getInt("ROOMNO") %>"
                                    name="ROOMNO" size="5">
                            </td>

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="weeklymeetings.jsp" method="get">
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
                    if(sqle.getErrorCode() == 55000) {
                    %>
                    Click <a href="review.jsp">here<a> to view / edit review sessions.
                    <%
                    }
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
