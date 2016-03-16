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
                    Statement stmt = null;

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement 

                    //error here rn
                    PreparedStatement pstmt = conn.prepareStatement("SELECT DISTINCT class.classid, class.name, section.sectionid, c1.classid AS conflict, c1.name AS conflicting, s1.sectionid AS conflicting_section FROM class, class c1, weeklymeeting w, section, weeklymeeting w1, section s1,enrolled e, student s WHERE w.day IN (SELECT w.day from weeklymeeting w WHERE w.time IN(SELECT DISTINCT w1.time FROM class c, weeklymeeting w1, enrolled e, student WHERE student.ssn = ? AND student.studentid = e.studentid AND e.sectionid = w1.sectionid AND c.classid = e.courseid)) AND class.classid = section.classid AND section.sectionid = w.sectionid AND class.classid NOT IN(SELECT DISTINCT c.classid FROM class c, weeklymeeting w1, enrolled e, student WHERE student.ssn = ? AND student.studentid = e.studentid AND e.sectionid = w1.sectionid AND c.classid = e.courseid) AND c1.classid = s1.classid AND s1.sectionid = w1.sectionid AND c1.classid = e.courseid AND s.ssn = ? AND s.studentid = e.studentid AND e.sectionid = w1.sectionid AND w1.day = w.day AND w1.time = w.time AND class.classid NOT IN (select distinct c.classid FROM class c, class c1, section s1, weeklymeeting w, weeklymeeting w1,section WHERE c.classid = section.classid AND c1.classid = s1.classid AND section.sectionid = w.sectionid AND s1.sectionid = w1.sectionid AND c.classid = c1.classid AND w.sectionid <> w1.sectionid AND w.day IN(SELECT w.day from weeklymeeting w WHERE w.time IN(SELECT DISTINCT w1.time FROM class c, weeklymeeting w1, enrolled e, student WHERE student.ssn = ? AND student.studentid = e.studentid AND e.sectionid = w1.sectionid AND c.classid = e.courseid)))");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN_returned")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("SSN_returned")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("SSN_returned")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("SSN_returned")));
                    resset1 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Conflicts For Student <%=request.getParameter("SSN_returned")%></th>
                    </tr>
                    <tr>
                    <th>Class </th>
                    <th>Class Name </th>
                    <th>Conflicting Class </th>
                    <th>Conflicting Class Name </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (resset1.next()) {
                    %>
                    <tr>
                        <td>
                            <%=resset1.getString("CLASSID")%>
                        </td>
                        <td>
                            <%=resset1.getString("NAME")%>
                        </td>
                        <td>
                            <%=resset1.getString("CONFLICT")%>
                        </td>
                        <td>
                            <%=resset1.getString("CONFLICTING")%>
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
                resset = statement.executeQuery("select distinct s.SSN, s.STUDENTID, s.FIRSTNAME, s.MIDDLENAME, s.LASTNAME from Student s, Enrolled e where e.STUDENTID = s.STUDENTID ORDER BY SSN");
                
                //resset = pstmt2.executeQuery();

                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="scheduleConflicts.jsp" method="POST">
        
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
