<%@ page import="java.sql.*" %>
<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="RequestForms.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
            <%---------- Open Connection Code ----------%>
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
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("submit")) {

                    ResultSet resset1 = null;
                    ResultSet resset2 = null;
                    ResultSet resset3 = null;
                    Statement stmt = null;

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement 

                    //error here rn
                    PreparedStatement pstmt = conn.prepareStatement("SELECT pastclasses.courseid, class.name, (pastclasses.quarter, pastclasses.year) AS quarter, pastclasses.units, pastclasses.grade FROM student s, class, pastclasses, grade_conversion g WHERE s.ssn = ? AND  s.studentid = pastclasses.studentid AND class.classid = pastclasses.courseid AND pastclasses.year = class.year AND pastclasses.quarter = class.quarter AND pastclasses.grade = g.letter_grade ORDER BY (pastclasses.quarter,pastclasses.year) ");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN_returned")));
                    resset1 = pstmt.executeQuery();

                     PreparedStatement pstmt1 = conn.prepareStatement("SELECT  (pastclasses.quarter, pastclasses.year) AS quarter, avg(number_grade) AS avg_grade FROM student s, class, pastclasses, grade_conversion g WHERE s.ssn = ? AND  s.studentid = pastclasses.studentid AND class.classid = pastclasses.courseid AND pastclasses.grade = g.letter_grade AND pastclasses.year = class.year AND pastclasses.quarter = class.quarter GROUP BY pastclasses.quarter, pastclasses.year ");

                    pstmt1.setInt(1, Integer.parseInt(request.getParameter("SSN_returned")));
                    resset2 = pstmt1.executeQuery();

                    PreparedStatement pstmt2 = conn.prepareStatement("SELECT DISTINCT avg(number_grade) AS cumu FROM student s, class, pastclasses, grade_conversion g WHERE s.ssn = ? AND  s.studentid =pastclasses.studentid AND class.classid = pastclasses.courseid AND pastclasses.grade = g.letter_grade AND pastclasses.year = class.year AND pastclasses.quarter = class.quarter");

                    pstmt2.setInt(1, Integer.parseInt(request.getParameter("SSN_returned")));
                    resset3 = pstmt2.executeQuery();



                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Grade Report For Student <%=request.getParameter("SSN_returned")%>
                    </tr>
                    <tr>
                    <th>Class </th>
                    <th>Name </th>
                    <th>Quarter </th>
                    <th>Grade </th>
                    <th>Units </th>

                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (resset1.next()) {
                    %>
                    <tr>
                        <td>
                            <%=resset1.getString("COURSEID")%>
                        </td>
                        <td>
                            <%=resset1.getString("NAME")%>
                        </td>
                        <td>
                            <%=resset1.getString("QUARTER")%>
                        </td>
                        <td>
                            <%=resset1.getString("GRADE")%>
                        </td>
                        <td>
                            <%=resset1.getInt("UNITS")%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </table>
                    <%
                              %>
                    <table border="1">
                    <tr>
                    <th>Quarter </th>
                    <th>Average GPA </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (resset2.next()) {
                    %>
                    <tr>
                        <td>
                            <%=resset2.getString("QUARTER")%>
                        </td>
                        <td>
                            <%=resset2.getDouble("AVG_GRADE")%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </table>
                    <%
                              %>
                    <table border="1">
                    <tr>
                    <th>Cumulative GPA </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (resset3.next()) {
                    %>
                    <tr>
                        <td>
                            <%=resset3.getDouble("CUMU")%>
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
                conn.setAutoCommit(false);

               // PreparedStatement pstmt2 = conn.prepareStatement("select SSN, STUDENTID, FIRSTNAME, MIDDLENAME, LASTNAME " +
                 //                               "from Student");
                resset = statement.executeQuery("select distinct s.SSN, s.STUDENTID, s.FIRSTNAME, s.MIDDLENAME, s.LASTNAME from Student s, pastclasses WHERE s.studentid = pastclasses.studentid ORDER BY s.SSN");
                
                //resset = pstmt2.executeQuery();

                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="gradeReport.jsp" method="POST">
        
        <div>
            Select Student:
            <select name="SSN_returned">
                <%
                    while(resset.next()){
                        %>
                        <option value='<%=resset.getInt("SSN")%>'>
                            <%=resset.getInt("SSN")%>, <%=resset.getString("STUDENTID")%>, <%=resset.getString("FIRSTNAME")%>, <%=resset.getString("MIDDLENAME")%>, <%=resset.getString("LASTNAME")%>
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
