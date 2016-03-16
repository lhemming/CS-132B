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

                    // Create the prepared statement 

                    //error here rn
                    PreparedStatement pstmt = conn.prepareStatement("select e.UNITS, sec.SECTIONID, c." +
                    "CLASSID, c.NAME, c.QUARTER, c.YEAR "+
                    "from Student s, Section sec, Class c, Enrolled e "+
                    "where s.SSN = ? AND s.STUDENTID = e.STUDENTID AND sec.SECTIONID = e.SECTIONID AND sec." +
                    "CLASSID = c.CLASSID AND c.YEAR = 2016 AND c.QUARTER = 'winter'");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN_returned")));
                    resset1 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Courses For Student <%=request.getParameter("SSN_returned")%></th>
                    </tr>
                    <tr>
                    <th>Class </th>
                    <th>Class Name </th>
                    <th>Section </th>
                    <th>Quarter </th>
                    <th>Year </th>
                    <th>Units </th>
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
                            <%=resset1.getString("SECTIONID")%>
                        </td>
                        <td>
                            <%=resset1.getString("QUARTER")%>
                        </td>
                        <td>
                            <%=resset1.getInt("YEAR")%>
                        </td>
                        <td>
                            <%=resset1.getString("UNITS")%>
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
    <form action="classesTakenByStudent.jsp" method="POST">
        
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
