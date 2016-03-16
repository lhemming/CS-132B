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


                    //Result query
                    //CASE WHEN t.STARTTIME > '12:00:00.0000' THEN CAST(t.STARTTIME AS - CAST ('12:00:00.0000' AS time(7)) ELSE t.STARTTIME END
                    //PreparedStatement pstmtReview = conn.prepareStatement("select c1.MONTHNAME AS MONTH, c1.DAY AS DAY, c1.WEEKDAYNAME AS WEEKDAY, CONVERT(varchar(7), t.STARTTIME, 100) AS STARTTIME, CONVERT(varchar(7), t.ENDTIME, 100) AS ENDTIME from Student s1, Times t, Section sec, Enrolled e1, Calendar c1 where sec.SECTIONID = ? AND e1.SECTIONID = sec.SECTIONID AND s1.STUDENTID = e1.STUDENTID AND t.STARTTIME NOT IN (select wk.TIME from Student s, Enrolled e, Enrolled e2, WeeklyMeeting wk, Calendar c where e.STUDENTID = s.STUDENTID AND e2.STUDENTID = s.STUDENTID AND e.SECTIONID = sec.SECTIONID AND wk.SECTIONID = e2.SECTIONID AND wk.DAY = c.WEEKDAYNAME) AND c1.DATE BETWEEN ? AND ? ORDER BY c1.DATE, c1.WEEKDAY, t.STARTTIME");
                    PreparedStatement pstmtReview = conn.prepareStatement("select c1.MONTHNAME AS MONTH, c1.DAY AS DAY, c1.WEEKDAYNAME AS WEEKDAY, CONVERT(varchar(7), t.STARTTIME, 100) AS STARTTIME, CONVERT(varchar(7), t.ENDTIME, 100) AS ENDTIME from Times t, Calendar c1 where not exists(select * from Enrolled e1, Enrolled e2, Section sec, WeeklyMeeting wk where e1.SECTIONID = ? AND e1.STUDENTID = e2.STUDENTID AND e2.SECTIONID = wk.SECTIONID AND wk.DAY = c1.WEEKDAYNAME AND wk.TIME = t.STARTTIME) AND c1.DATE BETWEEN ? AND ? ORDER BY c1.DATE, c1.WEEKDAY, t.STARTTIME ");
                    pstmtReview.setString(1, request.getParameter("SEC_returned"));
                    pstmtReview.setString(2, request.getParameter("startdate"));
                    pstmtReview.setString(3, request.getParameter("enddate"));
                    ResultSet rsReview = null;
                    rsReview = pstmtReview.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    
                    %>

                    <table border="1">
                    <tr>
                        <th>Available Review Times For Section <%=request.getParameter("SEC_returned")%></th>
                    </tr>
                    <br/>
                    <tr>
                    <th>Month / Date </th>
                    <th>Day Of Week </th>
                    <th>Time </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rsReview.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rsReview.getString("MONTH")%> <%=rsReview.getString("DAY")%> 
                        </td>
                        <td>
                            <%=rsReview.getString("WEEKDAY")%>
                        </td>
                        <td>
                            <%=rsReview.getString("STARTTIME")%> - <%=rsReview.getString("ENDTIME")%>
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
                PreparedStatement ps = conn.prepareStatement("select s.SECTIONID, s.CLASSID from Section s, Class c "
                                                            + "where s.CLASSID = c.CLASSID AND c.QUARTER = ? AND c.YEAR = ? AND s.SECTIONID NOT IN (select SECTIONID from PastClasses pc) ORDER BY s.CLASSID, s.SECTIONID ");
                ps.setString(1, currentquarter);
                ps.setInt(2, currentyear);

                resset = ps.executeQuery();

            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="reviewSession.jsp" method="POST">
        
        <div>
            Select Section:
            <select name="SEC_returned">
                <%
                    while(resset.next()){
                        %>
                        <option value='<%=resset.getString("SECTIONID")%>'>
                            <%=resset.getString("CLASSID")%>, Section <%=resset.getString("SECTIONID")%>
                        </option>
                        <%
                    }
                %>
            </select>
        </div>
        <br/>
            Start Date: <br/><input type="date" value="" name="startdate" size="10"/><br/><br/>
            End Date: <br/><input type="date" value="" name="enddate" size="10"/>
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

  

