<html>
<body>
    <table border="1">
        <tr>
            <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="RequestForms.html" />
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
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

            <%
                int currentyear = 2016;
                String currentquarter = "WINTER";
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("submit")) {

                    ResultSet resset1 = null;
                    Statement stmt = null;

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement 

                    //Result query
                    PreparedStatement pstmtConflict = conn.prepareStatement("select c.COURSEID AS CURRCOURSE, cl.NAME AS CURRTITLE, c2.COURSEID AS CONFLICTCOURSE, cl2.NAME AS CONFLICTTITLE from Course c, Course c2, Class cl, Class cl2, WeeklyMeeting wk, WeeklyMeeting wk2, Section s, Section s2, Enrolled e, Student s ");
                    //(s.STUDENTID = e.STUDENTID OR s.STUDENTID = pc.STUDENTID) AND cd.DEGREEID = d.DEGREEID AND (e.COURSEID = cd.COURSEID OR pc.COURSEID = cd.COURSEID) ");
                    pstmtConfict.setString(1, request.getParameter("DEG_returned"));
                    pstmtConflict.setString(2, request.getParameter("SSN_returned"));
                    ResultSet rsConflict = null;
                    rsConflict = pstmtTotal.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    
                    %>

                    <table border="1">
                    <tr>
                    <th>Current Course </th>
                    <th>Current Class Title </th>
                    <th>Conflict Course </th>
                    <th>Conflict Title </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rsConflict.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rsConflict.getString("CURRCOURSE")%>
                        </td>
                        <td>
                            <%=rsConflict.getInt("CURRTITLE")%>
                        </td>
                        <td>
                            <%=rsConflict.getInt("CONFLICTCOURSE")%>
                        </td>
                        <td>
                            <%=rsConflict.getInt("CONFLICTTITLE")%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </table>
                    <%
                }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();
                ResultSet resset = null;

                 // Select all undergraduate students to populate our dropdown menu
                PreparedStatement ps = conn.prepareStatement("select s.SSN, s.STUDENTID, s.FIRSTNAME, s.MIDDLENAME, s.LASTNAME " +
                                                "from Student s"+
                                                "where EXISTS (select * from Enrolled e where s.STUDENTID = e.STUDENTID AND e.QUARTER = ? AND e.YEAR = ?)");
                ps.setString(1, currentquarter);
                ps.setInt(2, currentyear);

                resset = ps.executeQuery();

            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="classSchedule.jsp" method="POST">
        
        <div>
            Select Student:
            <select name="SSN_returned">
                <%
                    while(resset.next()){
                        %>
                        <option value='<%=resset.getInt("SSN")%>'>
                            <%=resset.getInt("SSN")%>, <%=resset.getString("STUDENTID")%>, <%=resset.getString("FIRSTNAME")%> <%=resset.getString("MIDDLENAME")%> <%=resset.getString("LASTNAME")%>
                        </option>
                        <%
                    }
                %>
            </select>
        </div>
        <p>
            <%
                 // Select all possible undergrad degrees to go witho our student X
                resset = statement.executeQuery("select d.DEGREEID, d.NAME, d.TYPE " +
                                                "from Degree d "+
                                                "where d.LEVEL = 'Undergrad' ");
                
            %>
            <hr>

            <br />
        <div>
            Select Degree:
            <select name="DEG_returned">
                <%
                    while(resset.next()){
                        %>
                        <option value='<%=resset.getString("DEGREEID")%>'>
                            <%=resset.getString("NAME")%>, <%=resset.getString("TYPE")%>
                        </option>
                        <%
                    }
                %>
            </select>
        </div>
        <p>
        
        <button type="submit" name="action" value="submit">Submit</button>
        
    </form>
            

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                    resset.close();
    
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
        </td>
    </tr>
</table>
</body>

</html>

  

