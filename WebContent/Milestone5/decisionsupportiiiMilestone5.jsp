<%@ page import="java.sql.*" %>
<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="Milestone5RequestForms.html" />
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
                    PreparedStatement pstmt = conn.prepareStatement("SELECT gradecount AS COUNT, grade FROM cpg WHERE cpg.classid = ? AND cpg.instructor = ? ORDER BY grade");

                    pstmt.setString(1, request.getParameter("CLASSID"));
                    pstmt.setString(2, request.getParameter("INSTRUCTOR"));
                    resset1 = pstmt.executeQuery();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    %>
                    <table border="1">
                    <tr>
                        <th>Displaying Report For Course: <%=request.getParameter("CLASSID")%> 
                            <br/>
                            Instructor: <%=request.getParameter("INSTRUCTOR")%></th>
                    </tr>
                    <tr>
                    <th>Grade Count </th>
                    <th>Grade </th>
                    </tr>
                    <%
                        // Iterate over the ResultSet
                        while (resset1.next()) {
                    %>
                    <tr>
                        <td>
                            <%=resset1.getString("COUNT")%>
                        </td>
                        <td>
                            <%=resset1.getString("GRADE")%>
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
               // Statement statement = conn.createStatement();
               // ResultSet resset = null;
               // conn.setAutoCommit(false);

               // PreparedStatement pstmt2 = conn.prepareStatement("select SSN, STUDENTID, FIRSTNAME, MIDDLENAME, LASTNAME " +
                 //                               "from Student");
               // resset = statement.executeQuery("select s.SSN, s.STUDENTID, s.FIRSTNAME, s.MIDDLENAME, s.LASTNAME from Student s, Enrolled e where e.STUDENTID = s.STUDENTID");
                
                //resset = pstmt2.executeQuery();

                //conn.commit();
                //conn.setAutoCommit(true);
            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="decisionsupportiiiMilestone5.jsp" method="POST">
        
         <table border="1">
                    <tr>
                        <th>Course Id</th>
                        <th>Instructor</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="decisionsupportiiiMilestone5.jsp" method="get">
                            <input type="hidden" value="submit" name="action">
                            <th><input value="" name="CLASSID" size="10"></th>
                            <th><input value="" name="INSTRUCTOR" size="10"></th>
                            
                            <th><input type="submit" value="Submit"></th>
                        </form>
                    </tr>
        
    </form>

            

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                   // resset1.close();
    
                    // Close the Statement
                    //statement.close();
    
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
