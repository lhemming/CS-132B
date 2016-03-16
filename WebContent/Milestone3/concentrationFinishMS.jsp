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

                    //Result query: want names of concentrations in degree Y that X has finished
                    PreparedStatement pstmtFinished = conn.prepareStatement("select conc.NAME AS FINISHEDNAME from Degree d, Concentrations conc, Student s where s.SSN = ? AND d.DEGREEID = ? AND conc.DEGREEID = d.DEGREEID AND conc.MINUNITS <= (select SUM(pc2.UNITS) from PastClasses pc2, ConcCourseReq cc2 where pc2.STUDENTID = s.STUDENTID AND pc2.COURSEID = cc2.COURSEID AND cc2.CONCNAME = conc.NAME) AND conc.MINGPA <= (select SUM(pc2.UNITS * gc.NUMBER_GRADE) / SUM(pc2.UNITS) from PastClasses pc2, ConcCourseReq cc2, GRADE_CONVERSION gc where pc2.STUDENTID = s.STUDENTID AND pc2.COURSEID = cc2.COURSEID AND cc2.CONCNAME = conc.NAME AND gc.LETTER_GRADE = pc2.GRADE) ");
                    pstmtFinished.setString(1, request.getParameter("SSN_returned"));
                    pstmtFinished.setString(2, request.getParameter("DEG_returned"));
                    ResultSet rsFinished = pstmtFinished.executeQuery();

                    // only works for classes in 'PastClasses' table for now, doesn't count currently enrolled classes
                    PreparedStatement pstmtNotFinished = conn.prepareStatement("select cc.CONCNAME AS CONCENTRATIONNAME, cc.COURSEID AS COURSENAME, fc.QUARTER AS NEXTQUARTER, fc.YEAR AS NEXTYEAR from Student s, Degree d, FutureClasses fc, ConcCourseReq cc, Concentrations conc, QuarterValues q where d.DEGREEID = ? AND s.SSN = ? AND d.DEGREEID = conc.DEGREEID AND cc.CONCNAME = conc.NAME AND cc.CONCNAME = conc.NAME AND conc.DEGREEID = d.DEGREEID AND cc.COURSEID NOT IN (select c.COURSEID from Course c, PastClasses pc where pc.COURSEID = c.COURSEID AND pc.STUDENTID = s.STUDENTID) AND fc.COURSEID = cc.COURSEID AND fc.YEAR >= 2016 AND fc.QUARTER = q.NAME AND q.VAL = (select min(qr.VAL) from QuarterValues qr, FutureClasses fc2 where fc2.COURSEID = fc.COURSEID AND fc2.YEAR = fc.YEAR AND fc2.QUARTER = qr.NAME) group by cc.CONCNAME, cc.COURSEID, fc.YEAR, fc.QUARTER");
                    pstmtNotFinished.setString(1, request.getParameter("DEG_returned"));
                    pstmtNotFinished.setString(2, request.getParameter("SSN_returned"));
                    ResultSet rsNotFinished = null;
                    rsNotFinished = pstmtNotFinished.executeQuery();

                    /* PreparedStatement pstmtFutureClass = conn.prepareStatement("select fc.QUARTER AS NEXTQUARTER, fc.YEAR AS NEXTYEAR from FutureClasses fc, ConcCourseReq cc where cc.CONCNAME = ? AND cc.COURSEID = ? AND cc.COURSEID = fc.COURSEID AND fc.YEAR >= CURRENTYEAR AND fc.QUARTER <> 'SPRING' ");
                    pstmtFutureClass.setString(1, rsNotFinished.getString("CONCENTRATIONNAME"));
                    pstmtFutureClass.setString(2, rsNotFinished.getString("COURSENAME"));
                    ResultSet rsFuture = null;
                    rsFuture = pstmtFutureClass.executeQuery();*/

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    
                    %>

                    <table border="1">
                    <tr>
                        <th>Displaying Req For Student <%=request.getParameter("SSN_returned")%>, Degree <%=request.getParameter("DEG_returned")%></th>
                    </tr>
                    <br/>
                    <th>Finished Concentrations: </th>
                    <% while (rsFinished.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rsFinished.getString("FINISHEDNAME")%>
                        </td>
                    </tr>
                    <% 
                    } 
                    %>

                    <tr>
                    <th>Concentration Name </th>
                    <th>Course </th>
                    <th>Next Available Offering </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (rsNotFinished.next()) {
                    %>
                    <tr>
                        <td>
                            <%=rsNotFinished.getString("CONCENTRATIONNAME")%>
                        </td>
                        <td>
                            <%=rsNotFinished.getString("COURSENAME")%>
                        </td>
                        <td>
                            <%=rsNotFinished.getString("NEXTQUARTER")%>, <%=rsNotFinished.getInt("NEXTYEAR")%>
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
                                                "from Student s, GraduateMS g "+
                                                "where s.STUDENTID = g.STUDENTID AND EXISTS (select * from Enrolled e where s.STUDENTID = e.STUDENTID AND e.QUARTER = ? AND e.YEAR = ?)");
                ps.setString(1, currentquarter);
                ps.setInt(2, currentyear);

                resset = ps.executeQuery();
                conn.commit();
                conn.setAutoCommit(true);
                
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="concentrationFinishMS.jsp" method="POST">
        
        <div>
            Select Student:
            <select name="SSN_returned">
                <%
                    while(resset.next()){
                        %>
                        <option value='<%=resset.getInt("SSN")%>'>
                            <%=resset.getInt("SSN")%>, <%=resset.getString("STUDENTID")%>, <%=resset.getString("FIRSTNAME")%> <%=resset.getString("LASTNAME")%>
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
                                                "where d.LEVEL = 'GRAD' ");
                
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

  

