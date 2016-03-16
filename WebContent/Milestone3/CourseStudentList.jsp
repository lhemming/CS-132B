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
                    Statement stmt = null;

                    // Begin transaction
                    conn.setAutoCommit(false);

                    String[] parts = request.getParameter("returned").split(",");
                    String RETCLASSID = parts[0]; 
                    String RETQUARTER = parts[1];
                    String RETYEAR1 = parts[2]; 
                    int RETYEAR = Integer.parseInt(RETYEAR1);

                    // Create the prepared statement 
                    if( RETYEAR == 2016 ){
                        PreparedStatement pstmt = conn.prepareStatement("SELECT DISTINCT sec.classid, e.sectionid, s.ssn, s.studentid, s.firstname, s.lastname, s.residency, s.studenttype, s.enrolled, e.units, e.GRADETYPE FROM Student s, Enrolled e, Section sec WHERE sec.CLASSID = ? AND e.COURSEID = sec.CLASSID AND s.STUDENTID = e.STUDENTID");
                        pstmt.setString(1,RETCLASSID);
                        resset1 = pstmt.executeQuery();
                    } else {
                        PreparedStatement pstmt1 = conn.prepareStatement("SELECT DISTINCT sec.classid, pc.sectionid, s.ssn, s.studentid, s.firstname, s.lastname, s.residency, s.studenttype, s.enrolled, pc.units, pc.GRADETYPE FROM Student s, PastClasses pc, Section sec WHERE sec.CLASSID = ? AND pc.COURSEID = sec.CLASSID AND pc.QUARTER = ? AND pc.YEAR = ? AND s.STUDENTID = pc.STUDENTID ");
                        pstmt1.setString(1,RETCLASSID);
                        pstmt1.setString(2,RETQUARTER);
                        pstmt1.setInt(3,RETYEAR);
                        resset1 = pstmt1.executeQuery();
                    }
                    
                    


                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Roster For Class <%=request.getParameter("returned")%></th>
                    </tr>
                    <tr>
                    <th>Class </th>
                    <th>Section </th>
                    <th>SSN </th>
                    <th>SID </th>
                    <th>First Name </th>
                    <th>Last Name </th>
                    <th>Residency</th>
                    <th>Student Type </th>
                    <th>Enrolled </th>
                    <th>Units </th>
                    <th>Grade Type </th>
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
                            <%=resset1.getString("SECTIONID")%>
                        </td>
                        <td>
                            <%=resset1.getString("SSN")%>
                        </td>
                        <td>
                            <%=resset1.getString("STUDENTID")%>
                        </td>
                        <td>
                            <%=resset1.getString("FIRSTNAME")%>
                        </td>
                        <td>
                            <%=resset1.getString("LASTNAME")%>
                        </td>
                        <td>
                            <%=resset1.getString("RESIDENCY")%>
                        </td>
                        <td>
                            <%=resset1.getString("STUDENTTYPE")%>
                        </td>
                        <td>
                            <%=resset1.getString("ENROLLED")%>
                        </td>
                        <td>
                            <%=resset1.getInt("UNITS")%>
                        </td>
                        <td>
                            <%=resset1.getString("GRADETYPE")%>
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
                resset = statement.executeQuery("select CLASSID, NAME, QUARTER, YEAR from Class ORDER BY CLASSID");
                
                //resset = pstmt2.executeQuery();

                conn.commit();
                conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="CourseStudentList.jsp" method="POST">
        
          <div>
            Select Class:
            <select name="returned">
                <%
                    while(resset.next()){
                        %>
                        <option value='<%=resset.getString("CLASSID")%>,<%=resset.getString("QUARTER")%>,<%=resset.getInt("YEAR")%>'>
                            <%=resset.getString("CLASSID")%>, <%=resset.getString("NAME")%>, <%=resset.getString("QUARTER")%> <%=resset.getInt("YEAR")%>
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
