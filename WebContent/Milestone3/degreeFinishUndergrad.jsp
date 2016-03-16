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
                    //For our current schema: only have lower div and upper div. 
                    //***OPTION: can create a 'category table, that will hold lower div, uupper div, tech elec etc. stuff
                    // for the corresponding degree. If so, we just have to modify these queries to pull
                    // from the category table instead 

                    PreparedStatement pstmt3 = conn.prepareStatement("select * from Degree where degreeid = ?");
                    pstmt3.setString(1, request.getParameter("DEG_returned"));
                    ResultSet rs3 = pstmt3.executeQuery();

                    // to get number of student's units, need to find al classes they took (enrolled table) and add them up depending on what category they fall under (here, just 'lower' or 'upper')
                    // only works for classes in 'enrolled' table for now (assume all will be there)
                    PreparedStatement pstmtTotal = conn.prepareStatement("select d.TOTALUNITS AS UNITSLEFT from Degree d where d.DEGREEID = ? ");

                    PreparedStatement pstmtTaken = conn.prepareStatement("select SUM(pc.UNITS) AS TAKEN from Student s, Degree d, PastClasses pc, CourseDegreeReq cd where d.DEGREEID = ? AND s.SSN = ? AND s.STUDENTID = pc.STUDENTID AND cd.DEGREEID = d.DEGREEID AND pc.COURSEID = cd.COURSEID AND pc.GRADE <> 'f' ");
                    //(s.STUDENTID = e.STUDENTID OR s.STUDENTID = pc.STUDENTID) AND cd.DEGREEID = d.DEGREEID AND (e.COURSEID = cd.COURSEID OR pc.COURSEID = cd.COURSEID) ");
                    pstmtTotal.setString(1, request.getParameter("DEG_returned"));
                    pstmtTaken.setString(1, request.getParameter("DEG_returned"));
                    pstmtTaken.setString(2, request.getParameter("SSN_returned"));
                    ResultSet unitsLeftRS = null;
                    unitsLeftRS = pstmtTotal.executeQuery();
                    ResultSet unitstakenRS = null;
                    unitstakenRS = pstmtTaken.executeQuery();


                    //PreparedStatement pstmtView = conn.prepareStatement("CREATE VIEW UnitsTaken AS (select cat.NAME AS CATEGORYNAME, cat.UNITS AS MINUNITS, cat.UNITS - SUM(e.UNITS) AS LEFTUNITS from Student s, Degree d, CourseDegreeReq cd, Enrolled e, Course c, Category cat where s.SSN = ? AND d.DEGREEID = ? AND cat.DEGREEID = d.DEGREEID AND c.COURSEID = cd.COURSEID AND cat.NAME = c.CATEGORY AND e.STUDENTID = s.STUDENTID AND e.COURSEID = cd.COURSEID  group by cat.NAME, cat.UNITS )");
                    PreparedStatement pstmtBig = conn.prepareStatement(" (select cat.NAME AS CATEGORYNAME, cat.UNITS AS MINUNITS, cat.UNITS - SUM(pc.UNITS) AS LEFTUNITS from Student s, Degree d, CourseDegreeReq cd, PastClasses pc, Course c, CategoryCourseReq cc,  Category cat where s.SSN = ? AND d.DEGREEID = ? AND cat.DEGREEID = d.DEGREEID AND c.COURSEID = cd.COURSEID AND cd.COURSEID = cc.COURSEID AND cd.DEGREEID = d.DEGREEID AND cat.NAME = cc.CATEGORY AND pc.STUDENTID = s.STUDENTID AND pc.COURSEID = cd.COURSEID  AND pc.GRADE <> 'f' group by cat.NAME, cat.UNITS ) UNION ( select cat.NAME AS CATEGORYNAME, cat.UNITS AS MINUNITS, cat.UNITS AS LEFTUNITS from Student s, Degree d, CourseDegreeReq cd, CategoryCourseReq cc, Course c, Category cat where s.SSN = ? AND d.DEGREEID = ? AND cat.DEGREEID = d.DEGREEID AND cd.DEGREEID = d.DEGREEID AND cat.NAME NOT IN (select cat.NAME from Student s, Degree d, CourseDegreeReq cd, PastClasses pc, Course c, CategoryCourseReq cc,  Category cat where s.SSN = ? AND d.DEGREEID = ? AND cat.DEGREEID = d.DEGREEID AND c.COURSEID = cd.COURSEID AND cd.COURSEID = cc.COURSEID AND cd.DEGREEID = d.DEGREEID AND cat.NAME = cc.CATEGORY AND pc.STUDENTID = s.STUDENTID AND pc.COURSEID = cd.COURSEID AND pc.GRADE <> 'f') group by cat.NAME, cat.UNITS )");
                    pstmtBig.setString(1, request.getParameter("SSN_returned"));
                    pstmtBig.setString(2, request.getParameter("DEG_returned"));
                    pstmtBig.setString(3, request.getParameter("SSN_returned"));
                    pstmtBig.setString(4, request.getParameter("DEG_returned"));
                    pstmtBig.setString(5, request.getParameter("SSN_returned"));
                    pstmtBig.setString(6, request.getParameter("DEG_returned"));
                    //ResultSet ressetView = null;
                    //int viewCount = pstmtView.executeUpdate();
                    ResultSet ressetBig = null;
                    ressetBig = pstmtBig.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    
                    %>

                    <table border="1">
                    <tr>
                        <th>Displaying Req For Student <%=request.getParameter("SSN_returned")%>, Degree <%=request.getParameter("DEG_returned")%></th>
                    </tr>
                    <br/>
                    <%
                    int taken = 0;
                    while (unitstakenRS.next()) { taken = unitstakenRS.getInt("TAKEN"); };
                    while(unitsLeftRS.next()) {
                    %>
                        <th>Total Units Remaining:<%=unitsLeftRS.getInt("UNITSLEFT")-taken %></th>
                    <% } %>
                    <tr>
                    <th>Degree Category  </th>
                    <th>Minimum Required Units </th>
                    <th>Units Remaining</th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (ressetBig.next()) {
                    %>
                    <tr>
                        <td>
                            <%=ressetBig.getString("CATEGORYNAME")%>
                        </td>
                        <td>
                            <%=ressetBig.getInt("MINUNITS")%>
                        </td>
                        <td>
                            <%=ressetBig.getInt("LEFTUNITS")%>
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
                                                "from Student s, Undergrad u "+
                                                "where s.STUDENTID = u.STUDENTID AND EXISTS (select * from Enrolled e where s.STUDENTID = e.STUDENTID AND e.QUARTER = ? AND e.YEAR = ?)");
                ps.setString(1, currentquarter);
                ps.setInt(2, currentyear);

                resset = ps.executeQuery();

            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="degreeFinishUndergrad.jsp" method="POST">
        
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

  

